---
layout: post
title: "MSA-3. 사용자 정보 암호화"
tags: [Encryption, JAVA-Springboot]
author: judy
published: true
categories: [logs]
date: 2024-06-19
---
### 암호화 기법에 대해

- Hash: 단방향 암호화 기법
- Encryption: 양방향 암호화 기법
- 비밀번호를 저장할 때는 평문 → 암호화는 가능하나 평문 → 복호화는 불가능한 **단방향 암호화 방식을 사용**
- 해당 프로젝트에서는 이름, 비밀번호, 주소 → 클라이언트가 POST하는 모든 개인정보를 암호화하여 저장한다.
    (이메일은 아이디로 사용하여 PK로 지정하였기 때문에 이메일은 제외)

### How?

Spring에서 제공하는 [Spring Security](https://spring.io/projects/spring-security)를 사용하여 암호화한다.

> Spring Security is a powerful and highly customizable authentication and access-control framework. It is the de-facto standard for securing Spring-based applications.
> 

1. dependency 추가
    
    ```java
    implementation 'org.springframework.boot:spring-boot-starter-security'
    implementation 'org.springframework.security:spring-security-crypto'
    ```
    
2. Config 디렉토리를 설정하고 SecurityConfig 클래스 내 PasswordEncoder interface의 BCryptPasswordEncoder를 Bean으로 삽입
    
    ```java
    @Configuration
    @EnableWebSecurity
    public class SecurityConfig extends WebSecurityConfigurerAdapter {

        @Bean
        public PasswordEncoder passwordEncoder() {
            return new BCryptPasswordEncoder();
        }
        
        @Override
        protected void configure(HttpSecurity http) throws Exception {
            http
                    .authorizeRequests()
                    .requestMatchers("/", "/**").permitAll(); // 모든 접속 permit
        }
    }
    ```
    
3. UserService 내 registerUser에서 setUserName(), setPassword() 를 삽입한 암호화 알고리즘으로 처리

    ```java
    public User registerUser(UserDTO userDTO) {
        if (userRepository.findByEmail(userDTO.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email already in use");
        }

        User user = new User();
        user.setEmail(userDTO.getEmail());
        user.setUserName(passwordEncoder.encode(userDTO.getUserName())); // 수정부분
        user.setPassword(passwordEncoder.encode(userDTO.getPassword())); // 수정부분
        return userRepository.save(user);
    }
    ```