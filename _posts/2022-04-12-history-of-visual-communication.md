---
layout: post
title: "The History of Visual Communication"
tags: [tips, Development]
featured_image: "/assets/images/posts/3.jpg"
author: judy
published: true
categories: [logs]
---
```python
import datetime

# 주어진 밀리초 단위의 타임스탬프
timestamp_ms = 1720841280075

# 밀리초를 초로 변환
timestamp_s = timestamp_ms / 1000.0

# Unix 타임스탬프를 datetime 객체로 변환
date_time = datetime.datetime.fromtimestamp(timestamp_s)

# 밀리초 부분 계산
milliseconds = int(timestamp_ms % 1000)

# 원하는 형식으로 변환 (밀리초 포함)
formatted_date_time = date_time.strftime('%Y-%m-%d %H:%M:%S') + f'.{milliseconds:03d}'

print(formatted_date_time)
```