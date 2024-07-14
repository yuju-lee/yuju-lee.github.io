---
layout: post
title: "MSA-8. Google SMTP를 활용한 이메일 인증 단계 구현"
tags: [Auth, googleSMTP, mail-service, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-06-26
---

Google STMP를 이용하여 구현하였다. 

member/signup 엔드포인트로 회원가입 요청을 보내면 인증 상태 false, 일반 회원 ROLE_USER 로 가입이 된다. 이후 가입 당시 작성한 이메일로 가입 링크를 보내고, 해당 링크를 접속하면 인증 상태를 true로 값을 변경한다. 발급된 토큰은 레디스에 저장하고 24시간 뒤 or 사용자의 상태가 true로 변경되었을 때 삭제한다.

```yml
#google mail
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=
spring.mail.password=
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.timeout=5000
spring.mail.properties.mail.smtp.starttls.enable=true
```

여기서 username에는 발신 이메일을, password에는 앱 인증 비밀번호를 Google 설정에서 생성해 작성한다.

```yml
implementation group: 'org.springframework.boot', name: 'spring-boot-starter-mail', version: '3.0.5'
implementation 'org.springframework.boot:spring-boot-starter-mail'
```
종속성을 주입하고...

```Java
@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void sendEmail(String to, String subject, String text) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);
        mailSender.send(message);
    }
}
```

이메일 서비스 클래스를 작성한다.

```Java
private void sendVerificationEmail(MemberEntity member) {
        String token = UUID.randomUUID().toString();
        redisTemplate.opsForValue().set(token, member.getEmail(), 24, TimeUnit.HOURS);

        String url = "http://localhost:8080/member/verify?token=" + token;
        emailService.sendEmail(member.getEmail(), "Email Verification", "Click the link to verify your email: " + url);
    }
```
그리고 회원 가입 완료 후 이메일을 발송하는 메서드를 작성한다. param에는 토큰을 생성해 URL에 추가하여 보낸다. 
추가로, SecurityConfig에 verify** 링크의 permit을 all로 설정해 준다. 

```Java
    public void completeSignup(String token) {
        String email = (String) redisTemplate.opsForValue().get(token);
        if (email == null) {
            throw new IllegalArgumentException("Invalid or expired verification token");
        }

        MemberEntity member = jpaMemberRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        member.setEnabled(true);
        jpaMemberRepository.save(member);

        redisTemplate.delete(token);
    }
```
해당 링크를 클릭하면 GET mapping이 되어있는 /verify 엔드포인트에 위의 메소드가 실행되어 회원 가입이 최종적으로 완료된다.

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2F8c243caf-561c-4b78-b886-bb975d441261%2FScreenshot_2024-07-02_at_9.12.40_PM.png?table=block&id=f2b743a1-3360-4f21-8f53-9d5e4d8b31e0&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1860&userId=&cache=v2)

![](https://yuju-lee.notion.site/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2F44912d2a-41d8-4efb-a178-49f42e164aad%2Fbbb4425d-28c5-44a1-ad04-87da5166c15c%2FScreenshot_2024-07-03_at_2.22.02_AM.png?table=block&id=dca2c242-0ff7-4207-9006-76b4b13774e4&spaceId=44912d2a-41d8-4efb-a178-49f42e164aad&width=1540&userId=&cache=v2)

이메일이 발송되고, 해당 링크를 클릭하면 인증된 것을 확인할 수 있다.