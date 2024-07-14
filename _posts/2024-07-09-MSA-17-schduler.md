---
layout: post
title: "MSA-17. 구매 오픈 시각 기능 구현"
tags: [Test-tool, LuaScript, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-07-09
---

결제 진입 메서드에 단순히 요청 시각과 구매 오픈 시각을 비교하는 로직을 추가했다. 그리고 엔드포인트를 통해 관리자가 특정 제품에 대한 StartTime을 지정할 수 있게 한다. 구매 오픈 시각이 설정된 제품은 비교 로직을 통해 구매 시간 전 결제를 할 수 없게 구현하였다.

```Java
 // 특정 제품의 판매 시작 시간 확인
        LocalTime saleStartTime = saleTimeRepository.getProductSaleTime(productId);
        LocalTime now = LocalTime.now();
        if (saleStartTime != null && now.isBefore(saleStartTime)) {
            return "결제는 " + saleStartTime.toString() + "부터 가능합니다.";
        }
```
```Java
@PostMapping("/sale-time/{productId}")
public String setProductSaleTime(@PathVariable int productId, @RequestParam String saleTime) {
    LocalTime saleStartTime = LocalTime.parse(saleTime, DateTimeFormatter.ofPattern("HH:mm"));
    saleTimeRepository.setProductSaleTime(productId, saleStartTime);
    return "Sale start time for product " + productId + " set to " + saleStartTime.toString();
}
```

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F7b3d4949-62a1-466f-b07e-65c16d9ac684%2FScreenshot_2024-07-09_at_6.38.13_PM.png?table=block&id=7964d64f-88fc-42f8-820f-198c6a4aa377&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=2000&userId=&cache=v2)

오픈할 제품 id와 시각을 이렇게 Param으로 요청할 수 있다.

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F56c5750a-c1ee-42c4-a25e-5306f2da4785%2FScreenshot_2024-07-09_at_6.38.35_PM.png?table=block&id=ba858a55-c8e0-434b-a8dd-1267f9a39dc1&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=2000&userId=&cache=v2)

결제 시각 전의 결제 요청을 아예 거부한다.