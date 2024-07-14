---
layout: post
title: "MSA-15. 자동화 테스트 툴 제작"
tags: [Test-tool, Distributed-lock, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-07-06
---
### Python 스크립트로 과부하 테스트

쿼리문으로 10000명의 회원 정보를 넣었다.
![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2Fdbf328e7-f800-4d94-adad-8fac9e1429d8%2FScreenshot_2024-07-07_at_2.34.30_AM.png?table=block&id=23d99b6d-4d55-442c-98d4-38ef652ec8cc&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1120&userId=&cache=v2)

이메일 인증을 우회하기 위해 enabled=true로 직접 지정하여 10000개를 생성.

이메일, 토큰 정보가 헤더에 들어가야 하니 10000명을 순차적으로 로그인 시키는 파이썬 스크립트를 만들어 돌린 뒤, 이 정보를 헤더에 함께 넣어 결제 진입 API로 동시에 요청한다. 그리고 결과를 txt 파일로 뽑아 summary했다. 

분산 락으로 테스트하였을 때에는 서버가 터지거나 그러진 않았다. order도 잘 생성되었음.

---
![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2Faff44e53-cf32-4c26-91ee-578402eb38cb%2FScreenshot_2024-07-07_at_2.38.30_AM.png?table=block&id=79486b68-9142-4a08-84ee-77047b956dd5&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1440&userId=&cache=v2)
<center>첫 번째 테스트 결과</center>


![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F9de5acea-1fb6-467e-a7a5-c8cde6569593%2FScreenshot_2024-07-07_at_2.36.30_AM.png?table=block&id=5a85c351-c15e-4916-886b-bdf8fb5b027b&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1440&userId=&cache=v2)
<center>두 번째 테스트 결과</center>

----

모든 결과는 [여기](https://docs.google.com/spreadsheets/d/1EtPv7QxRM_sXQHPGmroqycDekuZ1-orG6XYZ0TE27EQ/edit?gid=356041803#gid=356041803)에서 확인할 수 있다.