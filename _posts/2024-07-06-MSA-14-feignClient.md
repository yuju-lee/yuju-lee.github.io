---
layout: post
title: "MSA-14. Feign Client 적용기"
tags: [Feign-Client, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-07-06
---
기존에 느슨한 결합을 중요 순위 1순위로 생각해 결제-주문 로직을 제외한 Service간의 통신도 Kafka를 통한 비동기 통신으로 구현했었다. 다만 Kafka의 비동기 통신 특성 상, 이벤트 형식으로 발행되는 응답을 수신 Service가 제대로 받지 못 하는 상황이 발생하여 Latch로 차이를 뒀는데, 이럴 바에는 feign client 방식으로의 동기 통신과 Kafka의 비동기 통신을 적절히 혼용하는 방향이 더욱 간결하다고 판단하였다. 따라서 단순한 요청과 응답을 주고받는 건 feign client로 서비스 간 통신 로직을 변경하였다.

현재 내 프로젝트에서의 서비스간 단순 통신은 아래와 같고, 이 로직을 전부 변경했다.

**myPage**

- Product Service → Member Service / 위시리스트 전달 / 완료
- Order Service → Member Service / 주문내역 전달 / 완료

**createOrder** 

- Prodcut Service → Order Service / 상품 정보 / 완료

변경 과정은 어렵지 않았으나, 에러가 한 번 생겨 트러블 슈팅한 기록이다.

```Java
java.lang.IllegalStateException: Error processing condition on org.springframework.boot.autoconfigure.context.PropertyPlaceholderAutoConfiguration.propertySourcesPlaceholderConfigurer
```

뭐 한 것도 없는데 오류가 나서 찾아 보니 Spring Colud랑 Springboot 버전이 맞지 않아서였다. Spring Cloud 버전을 맞춰 주고 다시 실행하니 잘 됐다.