# 시작하기

설정을 만들고 샘플링한`CGColor`를 정리한 다음, 반환된 색을 호스트 뷰에 적용합니다.

```swift
import KLAdaptiveSurface

let result = KLAdaptiveSurface.normalize(sampledColor)
let background = result.background
let foreground = result.foreground
```

밝기 하한, 채도 상한, 정리 강도, 전경색 정책을 바꾸려면`Configuration`을 전달합니다.
