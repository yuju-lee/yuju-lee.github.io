---
layout: post
title: "Kubernetes에 대해 알아보기"
date: 2024-08-02
categories: [Knowledge]
tags: [Kubernetes]
author: judy
featured_image: https://velog.velcdn.com/images/holicme7/post/19ba7f9f-2eb4-48c3-89aa-b4e3687e2a82/image.png
---

## 쿠버네티스란?

'k8s' 또는 'kube'라고도 하는 Kubernetes는 컨테이너화된 애플리케이션의 배포, 관리 및 확장을 예약하고 자동화하기 위한 컨테이너 오케스트레이션 플랫폼이다. 

## 컨테이너란?
컨테이너는 애플리케이션 소스 코드와 모든 환경에서 코드를 실행하는 데 필요한 모든 운영 체제(OS) 라이브러리 및 종속성을 결합하는 경량의 실행 가능한 애플리케이션 구성 요소이다.

컨테이너는 프로세스를 격리하고 해당 프로세스가 액세스할 수 있는 CPU, 메모리, 디스크의 양을 제어하여 여러 애플리케이션이 단일 OS 인스턴스를 공유할 수 있도록 하는 운영 체제(OS) 가상화의 한 형태를 활용하는데, 컨테이너는 가상 머신(VM)보다 더 작고 리소스 측면에서 효율적이며 휴대성이 뛰어나기 때문에 최신 클라우드 네이티브 애플리케이션의 사실상의 컴퓨팅 단위로 자리 잡았다고 할 수 있다. (도커의 컨테이너 개념과 비슷하다!)

---


# Kubernetes를 사용한 컨테이너 오케스트레이션

컨테이너가 확산됨에 따라(오늘날에는 한 조직에 수백, 수천 개의 컨테이너가 있을 수 있음) 운영팀은 컨테이너 배포, 네트워킹, 확장성, 가용성을 예약하고 자동화해야 했고 그렇게 컨테이너 오케스트레이션 시장이 탄생했다.

다른 컨테이너 오케스트레이션 옵션, 특히 Docker Swarm과 Apache Mesos가 초기에 어느 정도 주목을 받았지만, Kubernetes는 빠르게 가장 널리 채택되었다(실제로 한 때는 오픈 소스 소프트웨어 역사상 가장 빠르게 성장하는 프로젝트이기도 했고요).

개발자들은 Kubernetes의 광범위한 기능, 방대하고 성장하는 오픈 소스 지원 툴 에코시스템, 클라우드 서비스 제공업체 전반에 걸친 지원 및 이동성 때문에 Kubernetes를 선택한다.

## 그럼 Kubernetes는 어떤 기능을 할까?
Kubernetes는 다음을 포함하여 **애플리케이션 라이프 사이클 전반에 걸쳐 컨테이너 관련 작업을 예약하고 자동화**한다.

- 배포: 지정된 수의 컨테이너를 지정된 호스트에 배포하고 원하는 상태로 계속 실행함
- 롤아웃: 배포를 변경하는 것이며, Kubernetes를 사용하면 롤아웃을 시작, 일시 중지, 재개 또는 롤백할 수 있음
- 서비스 검색: Kubernetes는 DNS 이름 또는 IP 주소를 사용하여 컨테이너를 인터넷이나 다른 컨테이너에 자동으로 노출 가능함
- 스토리지 프로비저닝: 필요에 따라 컨테이너에 대한 영구 로컬 또는 클라우드 스토리지를 마운트하도록 Kubernetes를 설정함
- 로드 밸런싱: Kubernetes 로드 밸런싱은 CPU 사용률 또는 사용자 지정 메트릭을 기반으로 네트워크 전체에 워크로드를 분산하여 성능과 안정성 유지
- 오토 스케일링: 트래픽이 급증하면 Kubernetes 자동 확장은 필요에 따라 새 클러스터를 스핀 업하여 추가 워크로드 처리
- 고가용성을 위한 자가 치료: 컨테이너에 장애가 발생하면 Kubernetes는 자동으로 컨테이너를 재시작하거나 교체하여 중단 시간을 방지하며, 또한 상태 확인 요구 사항을 충족하지 않는 컨테이너를 삭제할 수 있음

## 쿠버네티스의 특징

### 1. 다양한 배포 방식
![](https://velog.velcdn.com/images/holicme7/post/c3737747-b4af-4d22-b5aa-5dc43f3b9ecb/image.png)
- Deployment, StatefulSets, DaemonSet, Job, CronJob 등 다양한 배포 방식을 지원
- 여러대의 애플리케이션을 띄우고 싶을 경우에는 Deployment 이용
- 로그나 모니터링 등 모든 서버에 설치가 필요한 경우엔 DaemonSet을 이용
- 배치성 작업은 Job이나 CronJob을 이용

### 2. Namespace & Label
![](https://velog.velcdn.com/images/holicme7/post/890af825-10ee-4e77-b71c-dcc5dc55c83a/image.png)
- 네임스페이스(Namespace) 기능으로 하나의 클러스터를 논리적으로 구분하여 사용 가능
- 라벨(label) 기능으로 유연하면서 확장성 있게 리소스를 관리

### 3. RBAC (role-based access control)
![](https://velog.velcdn.com/images/holicme7/post/e3f80335-fb23-47e3-8934-7cdd034ea746/image.png)
- 역할 기반 액세스 제어
- 누가(주체), 무엇을(동사), 어디에(네임스페이스) 실행할 수 있는지 결정하는 권한 또는 템플릿 집합을 수반하는 Identity 및 액세스 관리 형식
- 각각의 리소스에 대해 유저별로 CRUD스러운 권한을 손쉽게 지정
- 클러스터 전체에 적용하거나 특정 네임스페이스에 적용
- AWS의 경우 IAM을 연동해서 사용 가능

### 4. Auto Scaling
- 손쉽게 리소스 확장 가능
- Horizontal Pod Autoscaling(HPA) : CPU, MEM 사용량에 따라 Pod 수평 확장 기능
- Vertical Pod Autoscaling(VPA) : Pod 리소스 할당량 조정 (CPU, memory..)
- Cluster Autoscaling(CA) : 노드(서버) 개수 조정 가능 (클라우드 환경에서만)
- 이 외에도 KEDA 라는 오픈소스를 활용하여 HTTP 요청량이나 이벤트 수에 따라 Pod를 스케일링할 수 있음

### 5. Federation, Multi Cluster
클라우드에 설치한 쿠버네티스 클러스터와 자체 서버에 설치한 쿠버네티스를 묶어서 하나로 사용 가능
구글의 Anthos를 이용하면 한 곳에서 여러 클라우드의 쿠버네티스 클러스터들을 관리 가능

## 쿠버네티스 기본 개념과 구성 요소

### 마스터 - 노드 구조
![](https://velog.velcdn.com/images/holicme7/post/843b1f0b-f4f8-476b-b80b-50587c6f5f22/image.png)
- 중앙(Master)에 API 서버와 상태 저장소를 두고 각 서버(Node) 의 에이전트(kubelet)과 통신하는 단순한 구조
- 모든 명령은 마스터의 API 서버를 호출하고, 노드는 마스터와 통신하면서 필요한 작업 수행
- Kubectl 이라는 Client 도구로 API 서버 접근 가능

### Desired State
![](https://velog.velcdn.com/images/holicme7/post/03c3be54-9d7a-4550-92be-c344657b4483/image.png)
- 관리자가 서버를 배포할 때 직접적인 동작을 명령하지 않고 원하는 상태를 선언하는 방식을 사용 (RUN x, Create o)
    - A 컨테이너를 실행해 줘. 그리고 80 포트로 오픈해 줘. -> 현재 상태를 원하는 상태로 바꾸기 위한 명령(imperative)
    - 80 포트를 오픈한 A 컨테이너를 1개 유지해 줘. -> 원하는 상태를 선언(declarative)

- Desired State (원하는 상태)
    - 관리자가 바라는 환경 (구체적으로 웹서버 몇개 띄울건지, 몇번 포트로 띄울건지)
    - 현재 상태(current state) 를 모니터링하면서 관리자가 설정한 원하는 상태(desired state)를 유지하는 방향으로 동작

- 쿠버네티스의 핵심은 상태이며 쿠버네티스를 사용하려면 어떤 상태가 있고 어떻게 상태를 선언하는지를 알아야 함

### Kubernetes Object

- **POD** 

    ![](https://velog.velcdn.com/images/holicme7/post/85c6c7ab-7d2d-434e-9e93-ddf281e5ac8d/image.png)
    - 쿠버네티스에서 배포할 수 있는 가장 작은 단위
    - 한 개 이상의 컨테이너와 스토리지, 네트워크 속성 가짐
    - 컨테이너를 하나만 사용하는 경우도 반드시 Pod으로 감싸서 관리


- **Replicaset & Deployment**

    ![](https://velog.velcdn.com/images/holicme7/post/d8f2ad0e-0e6e-46b9-9e6b-38dab0822fd7/image.png)
    - Pod을 여러 개(한 개 이상) 복제하여 관리하는 오브젝트
    - 복제할 개수, 개수를 체크할 라벨 선택자, 생성할 Pod의 설정값(템플릿)등 설정
    - 자동으로 롤링 업데이트 가능


- **Service**
    - 네트워크 관련 Object
    - Pod <-> Pod 연결, 외부에서 접근할때 등등 사용

### Kubernetes Object Spec 기술 - Manifest 파일

- 오브젝트의 명세Spec, 상태desired state 정의는 YAML 파일로 정의
- 오브젝트의 종류와 원하는 상태를 입력
- 배포 노드나 RBAC(접근 권한 설정) 도 가능

### Kubernetes 배포 방식

- 애플리케이션을 배포하기 위해 오브젝트(object)에 라벨Label 을 붙여 원하는 상태(desired state) 로 정의(yaml)하고 API 서버에 전달하는 방식을 사용
- yaml 파일을 만들어서, 쿠버네티스 API 서버에 전달하면 됨


---
### Ref.
- [Kubernetes](https://www.ibm.com/kr-ko/topics/kubernetes)
- [쿠버네티스란 무엇인가?](https://velog.io/@holicme7/K8s-%EC%BF%A0%EB%B2%84%EB%84%A4%ED%8B%B0%EC%8A%A4%EB%9E%80-%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)