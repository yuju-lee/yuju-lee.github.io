---
layout: post
title: "[Algorithm] Stack and Queue"
date: 2024-06-05
categories: [algorithm]
tags: [Algorithm, Stack, Queue]
featured_image: https://miro.medium.com/v2/resize:fit:1400/1*zKnDkJpL-4GQ36kzrDiODQ.png
author: judy
---

## **스택 (Stack)**

스택은 데이터의 집합으로, 마지막에 삽입된 데이터가 가장 먼저 제거되는 **LIFO(Last In, First Out) 구조**를 가진다. 즉, “마지막에 들어간 것이 처음 나오는” 방식으로 동작한다.

**주요 연산**
1. Push: 스택의 맨 위에 데이터를 삽입
2. Pop: 스택의 맨 위에 있는 데이터를 제거하고 반환
3. Peek: 스택의 맨 위에 있는 데이터를 제거하지 않고 반환
4. IsEmpty: 스택이 비어 있는지 확인

----

## **큐 (Queue)**

큐는 스택과 다르게 처음에 삽입된 데이터가 가장 먼저 제거되는 **FIFO(First In, First Out) 구조**를 가진다. 즉, “먼저 들어간 것이 먼저 나오는” 방식으로 동작한다.

**주요 연산**
1. Enqueue: 큐의 끝에 데이터를 삽입
2. Dequeue: 큐의 앞에서 데이터를 제거하고 반환
3. Peek: 큐의 앞에 있는 데이터를 제거하지 않고 반환
4. IsEmpty: 큐가 비어 있는지 확인

----

### BOJ-2346: 풍선 터뜨리기

- 난이도: 실버
- 분류: 큐
- 링크: [2346번: 풍선 터뜨리기](https://www.acmicpc.net/problem/2346)


```python
from collections import deque

cnt = int(input())
balloon = list(map(int, input().split())) #풍선에 적힌 이름

result = []
#풍선번호, 인덱스를 큐로 / 인덱스 시작은 1로 시작
queue = deque((number, idx) for idx, number in enumerate(balloon, start=1))

while queue:
    #현재 풍선
    #queue[0]: 풍선번호
    #queue[1]: 풍선인덱스
    n, idx = queue.popleft()
    #터진 풍선의 인덱스 넣기
    result.append(idx)
    
    if n > 0: #양수일경우 -(풍선번호-1) / 왼쪽
        queue.rotate(-(n-1))
    else: #음수일경우 -(-풍선번호) / 오른쪽
        queue.rotate(-n)
    
for i in range(len(result)):
    print(result[i], end=" ")
```