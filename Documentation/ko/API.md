# API 레퍼런스

## `KLAdaptiveSurface.normalize(_:using:)`

`Configuration`에 따라 하나의`CGColor`를 정리합니다. 동기적으로 실행되며 이미지 데이터를 저장하거나 보유하지 않습니다.

## `KLAdaptiveSurface.Configuration`

정리 활성화 여부, 밝기와 채도 범위, 탁한 색상 판정 임계값, 정리 강도, 색상 선호도, 전경색 정책을 정의합니다. 수치는`0...1`범위로 제한됩니다.

## `KLAdaptiveSurface.Result`

정리된`background`, 권장`foreground`, `usesDarkForeground`, `wasNormalized`를 담습니다.

## 샘플 색상 정규화

원본 이미지 전체가 아니라 실제로 표시되는 이미지 영역을 먼저 분석한 뒤`KLAdaptiveSurface.normalize(_:using:)`를 호출합니다. 이 메서드는 이미지를 로드하거나 상태를 보존하지 않습니다. `Configuration.isEnabled`가`false`이거나 변환할 수 없는 색상이면 원래 색상을 반환합니다.

```swift
let result = KLAdaptiveSurface.normalize(sampledColor, using: .reading)
view.backgroundColor = result.background
view.tintColor = result.foreground
```

`wasNormalized`로 배경이 변경되었는지 확인할 수 있습니다. 호스트는 이를 사용해 캐시 색상을 유지할지, 정규화 상태를 표시할지 결정합니다.

## Configuration 의미

`brightnessFloor`는 밝기 하한이고`saturationCeiling`은 컨트롤 배경의 색도 상한입니다. `dirtinessThreshold`는 샘플 색상이 깨끗한 표면에서 얼마나 벗어났을 때 정규화를 시작할지 정합니다. `normalizationStrength`는 원래 색상과 정규화 결과를 섞는 정도입니다.

`colorPreference`로 색조를 유지하거나 중화하거나 차갑거나 따뜻한 방향으로 조정합니다. `foregroundStrategy`는 자동 대비 또는 명시적인 어두운색·밝은색 전경을 선택합니다. 이 정책은 기기 낮/밤 모드와 독립적이므로 밝은 배경에는 어두운 시스템 설정에서도 대비에 맞는 어두운 글자를 반환할 수 있습니다.

## 성능과 갱신 책임

작업은 동기적으로 수행되며 이미지 데이터를 보존하지 않습니다. 호스트는 이미지 영역과 설정의 동일한 식별자를 사용해`Result`를 캐시해야 합니다. 패키지는 결과를 자체 캐시하거나 외관 변화를 감시하지 않으며 갱신 시점도 결정하지 않습니다.
