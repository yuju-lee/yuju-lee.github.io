---
layout: post
title: "MSA-5. RefreshToken 적용기"
tags: [JWT, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-06-20
---

다른 기능을 구현하기 위해 API 요구와 POST를 보니… 음… 리프레시 토큰을 써야 할 것 같았다. 아니! 써야만 했다. 그래서 기존 엑세스 토큰을 발급해 주고 로그인 문구를 띄워 주는 구조를 다 뜯어 고쳐야 했다.
![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2Fd4d9e428-cc95-4b36-8ae9-c057026d67ff%2FUntitled.png?table=block&id=ba157320-073a-495c-96f2-3f52418d4434&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1440&userId=&cache=v2)

뭐… 이런 식으로 흐름을 러프하게 잡았다. 충분히 할 수 있겠다는 생각이 들었다. 이 그림에서 로그인 기능은 1~2이고, 이 부분을 먼저 구현해야겠다고 생각하고 알음알음 코드를 작성했다. 

처음 로그인 기능을 구현하였더니 404 에러가 떴다. 401도 아니고, 404…? 꿈이길... response body가 공백으로 떠서 어디서부터 어디를 고쳐야 할지 감도 안 오고… 도커로 띄워서 디버깅할 엄두가 안나 멘토님께 말씀 드렸더니 도커로 Springboot까지 띄워서 코드를 작성하고 있었고, (가이드에 적혀 있는 문장을 잘못 이해했음) 캐시 때문에 코드를 변경해도 반영이 안 되는 것이었다. 도커로 SQL, redis 같은 DB만 띄워 놓고, springboot는 IDE에서 했어야 했던 거였다. 그래서 찾기도 어려웠다.

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F9413fc87-4e5d-41d8-be09-15b802db4198%2FScreenshot_2024-06-20_at_10.38.56_AM.png?table=block&id=9ce5604e-2caf-4145-98e4-73adf7f2302c&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1920&userId=&cache=v2)

도커로 Springboot를 내리고, SQL & Redis만 올려서 다시 빌드하니 403이 떴다. 

403 외에도 자잘한 오류들이 있었다:

```Java
Parameter 2 of constructor in com.sun.sunboard.service.BoardService required a bean of type 'org.springframework.data.redis.core.RedisTemplate' that could not be found.
```

service에서는 RedisTemplate<String, String>을 사용했지만 config에서는 RedisTemplate<String, Object>를 사용해서 발생. 

형식을 맞춰 주면 해결된다.

```Java
The dependencies of some of the beans in the application context form a cycle:
┌─────┐
|  securityConfig defined in file [\SecurityConfig.class]
↑     ↓
|  userService defined in file [\MemberService.class]
└─────┘
Action:

Relying upon circular references is discouraged and they are prohibited by default. 
Update your application to remove the dependency cycle between beans. 
As a last resort, it may be possible to break the cycle automatically 
by setting spring.main.allow-circular-references to true.


Process finished with exit code 1
```

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2Fd1fc45af-643b-46b2-9c5b-153f3dbf478c%2FUntitled.png?table=block&id=484f4d0f-5699-465e-b49d-15c320dd5cd0&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=770&userId=&cache=v2)

이런 오류도 있었다. 두 개의 클래스가 서로를 참조하고 있어서 참조 서클 에러가 발생했다. 이건 그냥 나눠 주면 된다. 필터 클래스를 작성할 때 WebSecurityConfigurationAdapter를 상속받았는데, Deprecated되었다는 에러가 났다.
```Java
@Override
@Bean
public AuthenticationManager authenticationManagerBean() throws Exception{
	return super.authenticationManagerBean();
}
```
```Java
@Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration)
            throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }
```
아래 레퍼런스에서 제시한 새로운 방식으로 작성하여 해결했다.

[spring-security-without-the-websecurityconfigureradapter](https://spring.io/blog/2022/02/21/spring-security-without-the-websecurityconfigureradapter)

403 에러는 SecurityConfig 클래스의 SecurityFilterChain 내에 PermitAll을 준 링크에 /login이 빠져있어서 그랬었다. 해당 부분을 수정하고, 404 에러를 해결하려고 했다가 더 꼬인 코드를 차근차근 풀어서 다시 작성하였다.

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F7ad82664-eac9-4b41-aa41-0eadde79e889%2FScreenshot_2024-06-23_at_2.31.34_PM.png?table=block&id=abc83f2c-e91e-4733-91a3-710568ded9cb&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=2000&userId=&cache=v2)

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F95a51d47-f2ea-4025-b3a7-fd2c17d362b2%2FScreenshot_2024-06-23_at_2.31.37_PM.png?table=block&id=b59bc42f-5e44-4592-9876-94ab7be9e6cf&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1230&userId=&cache=v2)


요약하자면 흐름은 아래와 같다:
1. 최초 로그인 시 Refresh Token, Access Token을 클라이언트에게 발행하고 Access Token을 헤더에 저장하여 클라이언트에게 반환, Refresh Token은 Redis에 저장. > 로그인 이후 모든 요청은 헤더에 JWT 토큰을 담아서 요청한다. 
2. 로그아웃 시 발급한 Access Token을 Redis 블랙리스트에 등록. 
3. Refresh Token은 Access Token보다 기간을 길게 잡는다.  클라이언트가 만료된 Access Token으로 요청을 보낼 때 저장되어 있는 Refresh Token을 통해 Access Token을 새로 발급한다.
4. Refresh Token도 만료되면 재로그인을 해야 한다.