# 遷移

在 App 已經取得取色結果的位置，用`KLAdaptiveSurface.normalize(_:using:)`取代本地的顏色清理邏輯。圖片載入、調色盤取樣、視圖生命週期和快取仍由 App 負責。

建議先使用`.reading`。只有在有明確測量依據時，再調整閾值或色彩偏好。
