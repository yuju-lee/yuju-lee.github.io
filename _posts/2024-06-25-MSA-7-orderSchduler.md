---
layout: post
title: "MSA-7. 주문 상태 스케줄링"
tags: [TaskScheduler, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-06-25
---
프로젝트의 명세에 따라 주문서의 상태에 따라 스케줄링이 필요했다. MySQL에서 스케줄링은
1. 특정 간격을 주기로 감시하는 방법
2. 특정 시각 + 특정 주기에 변경되도록 스케줄링하는 방법

이 두가지가 있는데, 1보다 2의 코스트가 더 낮다고 판단되어 2의 방법을 구현하기 위해 구글링했고 TaskScheduler 라는 기능을 사용하기로 했다.

### 변경 프로세스

1. ORDER_CREATE → ORDER_CANCEL (0HR~24HR available / D+0)
2. OREDER_CREATE → ON_DELIVERY (24HR / D+1)
3. ON_DELIVERY → ORDER_COMPLETE (24HR / D+2)
4. ORDER_COMPLETE → RETURN CREATE (0HR~24HR available / D+3)
5. RETURN CREATE → RETURN_COMPLETE (24HR / D+4) 
6. ORDER_COMPLETE ~


```java
@Bean
public TaskScheduler taskScheduler() {
    ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
    scheduler.setPoolSize(10);
    scheduler.setThreadNamePrefix("task-scheduler-");
    return scheduler;
}
```

우선 SchedulerConfig에 해당 빈을 정의해 사용할 수 있도록 설정했다.

기획 당시 생각했던 주문 상태 변경 로직을 적용했다. 로그도 띄워 주면 보기 편하니 로그도 만들었다.

```java
public void updateOrderStatus(Integer orderKey, String status) {
        OrderEntity order = orderRepository.findById(orderKey).orElseThrow(
                () -> new IllegalArgumentException("Order not found")
        );

        switch (status) {
            case "ON_DELIVERY":
                if ("ORDER_CREATE".equals(order.getOrderStatus())) {
                    order.setOrderStatus("ON_DELIVERY");
                    scheduleNextStatusUpdate(order, "DELIVERY_COMPLETE", 24);
                }
                break;
            case "DELIVERY_COMPLETE":
                if ("ON_DELIVERY".equals(order.getOrderStatus())) {
                    order.setOrderStatus("DELIVERY_COMPLETE");
                    scheduleNextStatusUpdate(order, "ORDER_COMPLETE", 24);
                }
                break;
            case "ORDER_COMPLETE":
                if ("DELIVERY_COMPLETE".equals(order.getOrderStatus())) {
                    order.setOrderStatus("ORDER_COMPLETE");
                }
                break;
            default:
                log.warn("Unknown status: {}", status);
        }

        orderRepository.save(order);
        log.info("Order {} status updated to {}", order.getOrderKey(), status);
    }
```
