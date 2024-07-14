---
layout: post
title: "[Algorithm] KMP Algorithm"
date: 2024-06-01
categories: [algorithm]
tags: [Algorithm, KMP]
featured_image: https://media.geeksforgeeks.org/wp-content/uploads/20221125004358/image-660x398.png
author: judy
---

## KMP(Knuth-Morris-Pratt) 알고리즘

문자열 검색 알고리즘 중 하나로, 주어진 텍스트에서 패턴을 효율적으로 찾기 위해 사용된다. 이 알고리즘은 패턴을 텍스트에서 빠르게 검색하기 위해 미리 패턴에 대한 정보를 계산하고 활용할 수 있다. 시간 복잡도는 **`O(n + m)`**으로, 여기서 **`n`**은 텍스트의 길이, **`m`**은 패턴의 길이이다.

- **KMP 알고리즘**의 두 가지 단계:
    1. **전처리 단계**: 패턴에 대해 LPS(Longest Prefix which is also Suffix) 배열을 계산
    2. **검색 단계**: LPS 배열을 사용하여 패턴을 텍스트에서 효율적으로 검색

- **KMP 알고리즘의 장점**
    - **효율성**: LPS 배열을 사용하여 중복된 비교를 피하고, 불필요한 텍스트 비교를 줄일 수 있다
    - **선형 시간 복잡도**: KMP 알고리즘의 시간 복잡도는 **`O(n + m)`**으로, 텍스트와 패턴의 길이에 선형적으로 비례함