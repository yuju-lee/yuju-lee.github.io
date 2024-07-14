---
layout: post
title: "MSA-12. 분산락 전환기"
tags: [Kafka, Redis, Transaction, Distributed-Lock, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-07-03
---
기획했던 대로 우선 구현해 보았다.

### 결제 진입 로직

클라이언트는 결제 요청을 하면 대기열에 진입한다. (Client → PaymentController → PaymentQueueService → PaymentService)

- **PaymentController**: 결제 요청을 수신
- **PaymentQueueService:** 결제 요청을 대기열에 추가하고 대기열에서 요청을 가져옴
- **PaymentService:** 주기적으로 대기열을 확인하여 결제 요청 처리 (1초로 일단 잡음)

클라이언트는 결제 요청을 할 때 {제품명, 구매수량} 형식으로 PaymentService에 요청한다.

클라이언트의 결제 요청을 PaymentQueueService가 받으면, **실시간 재고확인을 우선적으로 진행**

1. 재고가 남아있는 경우 가상 대기열에 추가
2. 재고가 없는 경우 대기열 추가 거부 → 품절 메시지 응답

PaymentService는 대기열의 요청을 결제 요청 로직을 결제 서비스로 보낸다. (결제 시도 실패 20% / 결제 중 실패 20%)
결제는 실제 결제가 이루어지지 않기 때문에 결제가 성공하면 결제 메시지와 함께 해당 정보를 order 서비스로 보내고, 결제가 실패하면 레디스에서 재고를 바로 복구한다.

여기까지는 구현하였으나, 분산락으로도 구현이 가능하다고 한다. 따라서 분산락 완성 → 테스트툴 구축 → 분산락 테스트하고 이전 가상 대기열로 롤백해서 같은 테스트툴로 테스트를 해 볼 예정이다.

### 분산락이란? 🔐

분산 락은 여러 클라이언트가 동시에 특정 자원에 접근하지 못하도록 하는 락 메커니즘이다. 이는 주로 Redis와 같은 인메모리 데이터 저장소를 통해 구현되며, 고속의 락/언락 연산이 가능하여 분산 환경에서 효율적인 자원 관리를 할 수 있는 것이 장점이다.

### Redis를 사용한 분산 락의 작동 방식

1. **락 획득 (Lock Acquisition)**
    - 클라이언트는 특정 키에 대해 SETNX (Set if Not Exists) 명령을 사용하여 락을 시도
    - 락 키에 대한 값을 “locked”로 설정하고, 유효 시간(TTL)을 설정하여 자동으로 락 해제
2. **락 해제 (Lock Release)**
    - 클라이언트는 작업이 완료된 후 락 해제 → DEL 명령을 사용하여 락 키 삭제
        - 락 해제 시 키가 다른 클라이언트에 의해 변경되지 않았음을 보장하기 위해 원자적 체크와 삭제 사용
3. **락 유효 시간 (Lock Expiry)**
    - 락을 설정할 때 유효 시간을 설정하여 특정 시간이 지나면 자동으로 락이 해제
        - 이는 클라이언트가 비정상적으로 종료되어 락을 해제하지 못할 경우에도 다른 클라이언트가 락을 획득할 수 있도록 보장할 수 있음

```Java
public String processPayment(String email, int productId, int amount) throws JsonProcessingException {
    // 제품 재고를 위한 Redis 키
    String redisKey = redisStockKeyPrefix + productId;

    // 분산 락을 10초 동안 획득 시도
    Boolean acquired = redisTemplate.opsForValue().setIfAbsent(redisKey + ":lock", "locked", 10, TimeUnit.SECONDS);
    if (acquired != null && acquired) {
        try {
            // Redis에서 현재 재고 값을 가져옴
            String stockValueStr = redisTemplate.opsForValue().get(redisKey);

            if (stockValueStr != null) {
                Integer stock = Integer.valueOf(stockValueStr);

                // 재고 확인
                if (stock >= amount) {
                    // 결제 실패 확률 20%
                    boolean paymentSuccess = random.nextDouble() >= 0.2;

                    if (paymentSuccess) {
                        // 결제 성공 시 재고 차감
                        redisTemplate.opsForValue().decrement(redisKey, amount);

                        // Kafka 이벤트 발행
                        Map<String, Object> orderData = new HashMap<>();
                        orderData.put("email", email);
                        orderData.put("productId", productId);
                        orderData.put("amount", amount);
                        orderData.put("status", "COMPLETED");
                        kafkaTemplate.send("order-topic", objectMapper.writeValueAsString(orderData));
                        System.out.println("order sent");

                        // Kafka 재고 차감 이벤트 발행
                        Map<String, Object> stockUpdateData = new HashMap<>();
                        stockUpdateData.put("productId", productId);
                        stockUpdateData.put("stock", redisTemplate.opsForValue().get(redisKey));
                        kafkaTemplate.send(stockUpdateTopic, objectMapper.writeValueAsString(stockUpdateData));

                        System.out.println("Payment succeeded for " + email + " for product " + productId);
                            return "Payment succeeded for " + email + " for product " + productId;
                        } else {
                            System.out.println("Payment failed for " + email + " for product " + productId);
                            return "Payment failed for " + email + " for product " + productId;
                        }
                    } else {
                    System.out.println("재고가 부족합니다. 현재 재고: " + stock);
                    return "재고가 부족합니다. 현재 재고: " + stock;
                }
            } else {
                System.out.println("재고 정보가 존재하지 않습니다. Redis 키: " + redisKey);
                return "재고 정보가 존재하지 않습니다. Redis 키: " + redisKey;
            }
        } finally {
            // 락 해제
            redisTemplate.delete(redisKey + ":lock");
        }
    } else {
        System.out.println("잠시 후 다시 시도해 주세요.");
        return "잠시 후 다시 시도해 주세요.";
    }
}
```

위와 같은 방식으로 구현하였고, 테스트 시 결제가 완료되었다.