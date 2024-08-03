---
layout: post
title: "Springboot 개념 정리하기"
date: 2024-06-10
categories: [Knowledge]
tags: [JAVA, JAVA-Springboot]
author: judy
featured_image: https://velog.velcdn.com/images/falling_star3/post/b976acbe-551f-4775-bebb-f0d56c6a3b8a/%EC%8A%A4%ED%94%84%EB%A7%81%EB%B6%80%ED%8A%B8.JPG
---

# Java Spring Boot란?

스프링 부트(Spring Boot) 는 웹 프로그램(웹 애플리케이션)을 쉽고 빠르게 만들 수 있도록 도와주는 자바의 웹 프레임워크이다. 스프링 부트는 스프링(Spring) 프레임워크에 톰캣(Tomcat)이라는 서버를 내장하고 여러 편의 기능들을 추가하여 개발자들 사이에서 꾸준히 인기를 누리고 있다. 톰캣은 클라이언트의 요청을 해석하여 그에 맞는 자바 프로그램을 실행한 후 그 결과를 응답해 주는 웹 애플리케이션 서버이다.

## Java Springboot의 특징

### 1. 일반적인 자바 개발
객체의 의존성을 생성후 객체에서 제공하는 기능, 쉽게 말해 객채를 생성해서 일련의 작업들은 개발자가 직접 제어한다.

### 2. 제어 역전(IoC)
객체를 직접 생성 하지 않고 객체의 생명주기 관리를 Springboot에 위임한다.

### 3. 의존성 주입(DI)
스프링 컨테이너에서 객체 Bean을 먼저 생성해두고 생성한 객체를 지정한 객체에 주입하는 방식을 의존성 주입이라고 한다.

객체 자체가 코드 상에서 객체 생성에 관여하지 않아도 되기 때문에 객체 사이의 의존도를 낮출 수 있다. 스프링 컨테이너에서 객체의 생명주기를 관리하며 객체의 의존관계 또한 관리해 줍니다. 의존성 주입을 사용하면 유연하고 확장성이 뛰어난 코드 작성이 가능해진다.

**의존성 주입 방법**
- 생성자를 통한 의존성 주입
- 필드 객체 선언을 통한 의존성 주입
- setter 메서드 통한 의존성 주입

**스프링에서는 생성자 주입 방식을 권장하고 있다.**

### 4. 관점 지향 프로그래밍(AOP)
스프링 AOP는 프록시 기반의 AOP 구현체로, 주로 **스프링 빈에 대해 AOP가 적용**된다. 관점 지향 프로그래밍(AOP, Aspect-Oriented Programming)은 소프트웨어 개발의 모듈화 방법론 중 하나로, 주로 객체 지향 프로그래밍(OOP)의 한계를 보완하기 위해 사용된다. 

**객체지향 프로그래밍(OOP)**
- 추상화(abstraction)
    - 복잡한 시스템에서 필요한 중요한 부분만을 모델링하여 불필요한 세부 사항을 숨기는 과정
    - 추상화는 주로 클래스와 인터페이스를 사용하여 구현
- 캡슐화(encapsulation)
    - 객체의 상태와 행위를 하나로 묶고, 외부로부터 내부 구현을 숨기는 개념
    - 데이터 무결성을 유지하고, 객체 간의 상호작용을 제한
    - 클래스 내에서 변수와 메서드를 정의하고, 접근 제한자(private, protected, public)를 사용하여 외부 접근 제어
- 상속(inheritance)
    - 기존 클래스의 속성과 메서드를 새로운 클래스에서 재사용할 수 있도록 하는 개념
    - 코드의 재사용성을 높이고, 계층 구조를 통해 시스템을 설계할 수 있음
    - 자식 클래스는 부모 클래스의 모든 속성과 메서드를 상속받으며, 필요에 따라 추가적인 속성이나 메서드 정의
- 다형성(polymorphism)
    - 동일한 인터페이스나 부모 클래스를 통해 여러 다른 형태의 객체를 다룰 수 있는 개념
    - 메서드 오버로딩과 오버라이딩을 통해 구현
    - 프로그램의 유연성과 확장성을 높이는 데 중요한 역할

**관점지향 프로그래밍(AOP)**
- 관점(Aspect)
    - 애플리케이션의 주요 기능에 부가적인 동작을 정의하는 모듈
- 조인 포인트(Join Point)
    - Aspect가 적용될 수 있는 프로그램 실행 지점
    - 일반적으로 메서드 호출, 객체 생성, 예외 발생 등의 시점이 조인 포인트가 될 수 있음
- 어드바이스(Advice)
    - 특정 조인 포인트에서 실행되는 코드를 정의. 
    - 어드바이스는 조인 포인트에 적용될 행동을 나타내며, 실행 시점에 따라 다양한 유형이 있음
        - Before: 조인 포인트 이전에 실행
        - After: 조인 포인트 이후에 실행
        - Around: 조인 포인트 전후에 실행
        - After Returning: 조인 포인트가 정상적으로 종료된 후에 실행
        - After Throwing: 조인 포인트에서 예외가 발생한 후에 실행
- 포인트컷(Pointcut)
    - 하나 이상의 조인 포인트를 선택하는 표현식
    - 포인트컷을 통해 어드바이스가 적용될 조인 포인트를 정의
- 위빙(Weaving)
    - 어드바이스를 실제 조인 포인트에 적용하는 과정
    - 위빙은 컴파일 시점, 클래스 로딩 시점, 런타임 시점에 이루어질 수 있음

---

## 스프링 빈(bean)이란?

스프링(Spring) 컨테이너가 관리하는 자바 객체를 빈(Bean)이라 한다.

제어의 역전이란, 위에서 적었듯 객체의 생성 및 제어권을 사용자가 아닌 스프링에게 맡기는 것이다. 지금까지는 사용자가 ``new`` 연산을 통해 객체를 생성하고 메소드를 호출했는데, **IoC가 적용된 경우에는 이러한 객체의 생성과 사용자의 제어권을 스프링에게 넘긴다.** 사용자는 직접 ``new``를 이용해 생성한 객체를 사용하지 않고, 스프링에 의하여 관리당하는 자바 객체를 사용한다. **이 객체를 '빈(bean)'이라 한다.**

## 스프링 빈(bean)을 스프링 컨테이너에 등록하는 방법

### 컴포넌트 스캔과 자동 의존관계 설정
- ``@Component`` 애노테이션이 있으면 스프링 빈으로 자동 등록된다. 또한, ``@Component``를 포함하는 ``@Controller``, ``@Service``, ``@Repository`` 애노테이션도 스프링 빈으로 자동 등록된다.


![](https://velog.velcdn.com/images%2Ffalling_star3%2Fpost%2Fde5bf80c-0210-42df-b702-c9bd721d6739%2Fimage.png)

이런 식의 회원 관리가 이루어질 때, 회원 컨트롤러를 등록하고, 회원 컨트롤러가 회원서비스와 회원 리포지토리를 사용할 수 있게 의존관계를 설정할 수 있다.

``` JAVA
@Controller
public class MemberController {

    private final MemberService memberService;

	@Autowired
    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }
}
```

``` JAVA
@Service
public class MemberService {

	private final MemberRepository memberRepository;

	@Autowired
	public MemberService(MemberRepository memberRepository) {
		this.memberRepository = memberRepository;
	}
}
```

``` JAVA
@Repository
public class MemoryMemberRepository implements MemberRepository {}
```


**@Autowired**

생성자에 ``@Autowired``가 있으면 스프링이 연관된 객체를 스프링 컨테이너에 찾아서 넣어준다. 이렇게 객체 의존관계를 외부에서 넣어주는 것이 아까 작성했던 '의존성 주입(DI)'이다. 위 관계 그림에서 -> 의존관계를 표현한 화살표 역할을 해준다. (생성자가 1개만 있으면 생략 가능)


스프링은 스프링 컨테이너에 스프링 빈을 등록할 때, 기본으로 싱글톤으로 등록한다.(유일하게 하나만 등록해서 공유한다.) 따라서 같은 스프링 빈이면 모두 같은 인스턴스다. 설정으로 싱글톤이 아니게 설정할 수 있지만, 특별한 경우를 제외하면 대부분 싱글톤을 사용한다.


### 자바 코드로 직접 스프링 빈 등록하기(Configuration)
``@Configuration``과 ``@Bean`` 애노테이션을 이용해 스프링 빈을 등록한다. ``@Configuration``을 이용하면 스프링 프로젝터에서 Configuration 역할을 하는 Class를 지정할 수 있다.
