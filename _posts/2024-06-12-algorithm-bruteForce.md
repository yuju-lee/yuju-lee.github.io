---
layout: post
title: "[Algorithm] Brute Force"
date: 2024-06-12
categories: [algorithm]
tags: [Algorithm, Brute-force]
author: judy
---

## 브루트 포스 (Brute Force)

브루트 포스: 완전탐색은 가능한 모든 경우의 수를 탐색하는 알고리즘이다. 모든 가능한 해를 조사하여 문제를 해결하는 방식으로, 가장 단순하지만 때로는 가장 효과적인 방법이 될 수 있다. 

보통 최적화 문제나 결정 문제에서 사용되며 가능한 모든 해를 시도해 본 후, 그 중 가장 적절한 해를 선택하는 방식으로 문제를 해결한다.

**완전탐색의 특징**
- 해결 가능한 모든 방법을 시도해야 하는 경우: 문제의 조건이 복잡하거나, 최적의 해를 찾기 위해 모든 가능성을 검토해야 할 때 사용한다.
- 모든 가능성을 고려하기 때문에 항상 최적의 해(해답)를 찾을 수 있지만 경우의 수가 매우 많은 경우 시간과 메모리의 부담이 커질 수 있다. 그런 경우, 다른 효율적인 방법을 찾아야 한다.


----

### BOJ-1182: 부분수열의 합

- 난이도: 실버
- 분류: 브루트포스
- 링크: [1182번: 부분수열의 합](https://www.acmicpc.net/problem/1182)


```python
#504ms
from itertools import combinations 

count, sumnum = map(int, input().split())
numbers = list(map(int, input().split()))
ans = 0
for i in range(1, count+1):
    tmp = list(combinations(numbers, i))
    for j in tmp:
        if sum(j) == sumnum:
            ans += 1
print(ans)

```

### BOJ-4673: 셀프 넘버

- 난이도: 실버
- 분류: 브루트포스
- 링크: [4673번: 셀프 넘버](https://www.acmicpc.net/problem/4673)


```python
#48ms
def findnum(n):
    total = n
    while n > 0:
        total += n%10
        n //= 10
    return total

num = set()

for i in range(1, 10001):
    num.add(findnum(i))

for i in range(1, 10001):
    if i not in num:
        print(i)
```
