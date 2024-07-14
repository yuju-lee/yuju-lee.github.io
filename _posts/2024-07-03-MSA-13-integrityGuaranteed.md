---
layout: post
title: "MSA-13. 재고 데이터의 무결성 보장"
tags: [Redis, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-07-03
---
남은 수량은 실시간으로 줄어들기 때문에 최대한 빠르게 Read & Write 할 수 있어야 한다. 

따라서 실제 재고 데이터는 ProductService의 연결된 MySQL - spring_proj_product DB에 저장되어 있지만 빠른 읽기와 쓰기를 위해 Redis를 추가적으로 이용했다. 재고 관리를 위한 Redis는 단 하나, 모든 서비스가 통합하여 사용하기 때문에 Redis를 연결만 해서 사용하면 된다. 

Redis 재고와 SQL DB 사이의 무결성 보장은 **결제 과정 중 결제가 완료되어 주문이 생성되었을 때에만 이벤트를 발행**한다.

```Java
Map<String, Object> stockUpdateData = new HashMap<>();
stockUpdateData.put("productId", productId);
stockUpdateData.put("stock", redisTemplate.opsForValue().get(redisKey));
kafkaTemplate.send(stockUpdateTopic, objectMapper.writeValueAsString(stockUpdateData));
```

결제가 완료되면 이런 식으로 카프카 이벤트를 발행한다. 그럼 Payment에서 발행하는 이벤트를 구독하던 Product Service가 결제 완료 이벤트 시 발생했을 때 이벤트를 냉큼 받아 sql 내 저장된 재고를 차감하는 로직을 수행한다.

이렇게 하면 반대로 Payment가 터져서 레디스가 기록하지 못 해도 MySQL 데이터가 남아있어서 괜춘하다.

결제는 이렇게 했고, 주문 과정에서 주문 후 취소 / 배송 후 취소(Return)도 MySQL 데이터와 레디스를 동시에 재고를 복구하도록 했다.
