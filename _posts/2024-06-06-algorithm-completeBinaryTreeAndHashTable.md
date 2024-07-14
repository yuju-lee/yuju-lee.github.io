---
layout: post
title: "[Algorithm] Complete Binary Tree & HashTable"
date: 2024-06-06
categories: [algorithm]
tags: [Algorithm, Binary-tree, Hash-table]
featured_image: https://media.geeksforgeeks.org/wp-content/cdn-uploads/binary-tree-to-DLL.png
author: judy
---

## 완전이진트리
완전 이진 트리(Complete Binary Tree)는 이진 트리(Binary Tree)의 특수한 형태로, 모든 레벨이 완전히 채워져 있거나 마지막 레벨을 제외하고는 모든 노드가 왼쪽부터 오른쪽으로 순서대로 채워져 있는 트리이다. 완전 이진 트리는 배열을 사용한 구현에 적합하며, 힙(Heap)과 같은 데이터 구조의 기초가 된다.

**완전 이진 트리의 특성**
1.	노드 배치:
    - 모든 레벨이 꽉 차 있거나, 마지막 레벨을 제외한 모든 레벨이 꽉 차있다.
    - 마지막 레벨의 노드는 왼쪽에서 오른쪽으로 순서대로 채워진다.
2.	높이:
    - 완전 이진 트리의 높이(또는 깊이)는 최소 높이이다. 따라서 노드의 개수가 N일 때, 높이는 O(log N)이다.

----

## 해시테이블 (Hashtable)


해시 테이블(Hash Table)은 키(key)와 값(value)을 저장하는 데이터 구조이며 빠른 검색, 삽입 및 삭제 작업이 가능하다. 해시 테이블은 해시 함수(Hash Function)를 사용하여 키를 해시값(hash value)으로 변환하고, 이 해시값을 인덱스로 사용하여 배열에서 데이터를 저장하거나 검색한다.

**주요 개념**
1. 해시 함수(Hash Function):
- 해시 함수는 임의의 길이를 가진 입력 데이터를 고정된 길이의 해시값으로 변환한다. 좋은 해시 함수는 입력이 고르게 분포되도록 하여 충돌(collisions)을 최소화한다.
- ex) ``h(key) = key % array_size``
2. 해시값(Hash Value):
- 해시 함수에 의해 생성된 고정 길이의 숫자이다. 이 값을 인덱스로 사용하여 배열에서 데이터의 위치를 결정한다.

**해시테이블의 장점**
1. 빠른 검색, 삽입, 삭제 - **O(1)의 시간 복잡도**로 데이터를 검색 및 삽입, 삭제할 수 있다.
3. 키-값 쌍의 효율적인 관리가 가능하다.

----
### BOJ-11286: 절댓값 힙

- 난이도: 실버
- 분류: 힙
- 링크: [11286번: 절댓값 힙](https://www.acmicpc.net/problem/11286)


```python
import heapq
from sys import stdin

input = stdin.readline
heap = []

count = int(input())

for i in range(1, count + 1):
    try:
        num = int(input())
        if num != 0:
            # (절대값, 실제값) 형태로 저장
            heapq.heappush(heap, (abs(num), num))
        else: # 0일 경우 배열에서 절대값이 가장 작은 값을 출력하고 제거
            if len(heap):
                print(heapq.heappop(heap)[1])
            else:
                print(0)
    except:
        print(0)
```

----

### BOJ-9375: 패션왕 신해빈

- 난이도: 실버
- 분류: 해시 테이블 (딕셔너리)
- 링크: [9375번: 패션왕 신해빈](https://www.acmicpc.net/problem/9375)


```python
import sys

t = int(input())

for _ in range(t):
    cloth = {}
    result = 1
    n = int(input())
    for _ in range(n):
        name, type = sys.stdin.readline().rstrip().split()

        if not type in cloth:
            cloth[type] = 1
        else:
            cloth[type] += 1

    for i in cloth:
        result *= (cloth[i] + 1)

    print(result - 1)

```