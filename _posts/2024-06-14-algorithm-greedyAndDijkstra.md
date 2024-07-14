---
layout: post
title: "[Algorithm] Greedy & Dijkstra"
date: 2024-06-14
categories: [algorithm]
tags: [Algorithm, Greedy, Dijkstra]
author: judy
---

## 그리디 알고리즘(Greedy Algorithm)

그리디 알고리즘(Greedy Algorithm)은 문제를 해결하는 과정에서 매 단계마다 가장 최선의 선택을 하는 방법이다. 이 알고리즘은 현재 상황에서 최선이라고 생각되는 결정을 반복적으로 수행하며, 이를 통해 전체 문제의 최적해를 구하는 것을 목표로 한다. 그리디 알고리즘은 많은 경우에 효율적이고 간단하게 문제를 해결할 수 있지만, 모든 문제에 대해 최적해를 보장하지는 않는다. 즉, **각 단계에서 최선의 선택(부분 문제의 최적해)을 모두 합쳤을 때, 전체에서의 최선의 선택과 다르다면 풀이가 성립하지 않는다!** 또한, 완전탐색이 아니니 주의해야한다.

- **그리디 알고리즘의 특징**
    - **즉각적인 최적의 선택**: 그리디 알고리즘은 매 순간마다 그 순간에서의 최적의 선택을 한다.
    - **단계별로 최적 선택**: 각 단계에서 이루어지는 선택이 전체 문제의 최적 해결책으로 이어진다는 보장이 있어야 한다.

----

## 다익스트라 (Dijkstra)
각 단계에서 최선의 선택을 통해 최단 거리를 찾는 방법으로, 정해진 시작 노드에서 다른 모든 노드까지의 최단 거리를 구할 수 있는 알고리즘이다.

다익스트라 알고리즘은 아래의 단계로 이루어져 있다.

1. **초기화**: 시작 노드의 최단 거리를 0으로 설정하고, 다른 모든 노드의 최단 거리를 무한대로 설정한다.
2. **방문하지 않은 노드 중 거리가 가장 짧은 노드 선택**: 시작 노드부터 최단 거리를 갖는 노드를 선택한다.
3. **선택한 노드를 거쳐 다른 노드로 가는 거리 갱신**: 선택한 노드를 거쳐 다른 노드로 가는 거리를 계산하여 기존에 저장된 최단 거리보다 짧을 경우 해당 거리로 갱신한다.
4. **위 과정을 반복**: 모든 노드를 방문할 때까지 위 과정을 반복한다.

- **다익스트라 알고리즘의 특징**
    - **단계별 최적 선택**: 알고리즘은 시작 정점에서부터 점진적으로 최단 거리를 확장해 나간다. 매 단계에서 가장 짧은 경로를 가진 정점을 선택하여, 그 정점의 인접 정점으로의 최단 거리를 업데이트한다.
    - **우선순위 큐 사용**: 일반적으로 우선순위 큐(힙)를 사용하여 최단 거리를 가진 정점을 효율적으로 선택한다. 이를 통해 시간 복잡도를 개선할 수 있다.


*빠른 다익스트라 알고리즘 구현을 위해선 “최단 거리”, 즉 최솟값을 계속 뽑을 수 있는 자료구조가 필요하다. Python의 heapq 라이브러리를 이용할 수 있다.*

----

### BOJ-1931: 회의실 배정

- 난이도: 실버
- 분류: 그리디
- 링크: [1931번: 회의실 배정](https://www.acmicpc.net/problem/1931)


```python
#4188ms
def findmaxmeeting(meetinglist):
    #끝나는 시간 순서로 정렬하고 시작 시간을 정의
    meetinglist.sort(key= lambda x: (x[1], x[0]))
    #결과저장배열 초기화
    finish = 0
    cnt = 0
    for start, end in meetinglist:
        if start >= finish:
            cnt += 1
            finish = end

    return cnt

meetingcnt = int(input())
meetinglist = []

for _ in range(meetingcnt):
    start, end = map(int, input().split())
    meetinglist.append((start, end))

print(findmaxmeeting(meetinglist))
```

### BOJ-1916: 최소비용 구하기

- 난이도: 골드
- 분류: 다익스트라
- 링크: [1916번: 최소비용 구하기](https://www.acmicpc.net/problem/1916)

```python
#276ms
import heapq
import sys

input = sys.stdin.readline
INF = sys.maxsize

def dijkstra(start, n, graph):
    dist = [INF] * (n+1) #시작 정점에서 각 정점까지의 최단 거리를 저장
    dist[start] = 0  #시작 정점의 최단 거리: 0으로 초기화
    pq = [(0, start)]  #우선순위 큐에 (거리, 정점)을 넣음 (초기 거리는 0, 시작 정점)

    while pq:
        currdist, currnode = heapq.heappop(pq)
        
        #우선순위 큐에서 꺼낸 거리가 현재까지 계산된 거리보다 크면 무시
        if currdist > dist[currnode]:
            continue
        
        #현재 정점에서 인접한 정점 순회
        for nextnode, weight in graph[currnode]:
            distance = currdist + weight
            
            #새로 계산한 거리가 기존 최단 거리보다 짧으면 업데이트하고 우선순위 큐에 넣음
            if distance < dist[nextnode]:
                dist[nextnode] = distance
                heapq.heappush(pq, (distance, nextnode))
    
    return dist

n = int(input().strip())  # 도시의 개수
m = int(input().strip())  # 버스의 개수

graph = [[] for _ in range(n+1)]  # 그래프 초기화

for _ in range(m):
    u, v, w = map(int, input().strip().split())
    graph[u].append((v, w))

start, end = map(int, input().strip().split())

dist = dijkstra(start, n, graph)

# 도착 도시까지의 최단 거리를 출력, 도달 불가능한 경우 -1 출력
print(dist[end] if dist[end] != INF else -1)
```