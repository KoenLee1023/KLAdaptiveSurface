import CoreGraphics

public enum KLAdaptiveSurface {
    public static func normalize(
        _ color: CGColor,
        using configuration: Configuration = .reading
    ) -> Result {
        guard configuration.isEnabled,
              let components = ColorComponents(color: color) else {
            return Result(
                background: color,
                foreground: CGColor(gray: 0, alpha: 1),
                usesDarkForeground: true,
                wasNormalized: false
            )
        }

        let dirtiness = configuration.dirtiness(of: components)
        let normalized = configuration.normalized(
            components,
            dirtiness: dirtiness
        )
        let background = normalized.cgColor
        let usesDarkForeground = configuration.foregroundStrategy.usesDarkForeground(
            for: normalized.relativeLuminance
        )

        return Result(
            background: background,
            foreground: usesDarkForeground
                ? CGColor(gray: 0, alpha: 1)
                : CGColor(gray: 1, alpha: 1),
            usesDarkForeground: usesDarkForeground,
            wasNormalized: dirtiness > 0
        )
    }
}

public extension KLAdaptiveSurface {
    fileprivate enum Tuning {
        static let unitRange: ClosedRange<CGFloat> = 0...1
        static let automaticDarkForegroundLuminance: CGFloat = 0.50
        static let darknessWeight: CGFloat = 0.85
        static let chromaWeight: CGFloat = 0.90
        static let coolReferenceHue: CGFloat = 0.56
        static let warmReferenceHue: CGFloat = 0.08
        static let hueBiasStrength: CGFloat = 0.18
        static let secondarySaturationStrength: CGFloat = 0.50
    }

    enum ColorPreference: Sendable {
        case preserveHue
        case neutral
        case cool
        case warm
    }

    enum ForegroundStrategy: Sendable {
        case automatic
        case dark
        case light

        fileprivate func usesDarkForeground(for luminance: CGFloat) -> Bool {
            switch self {
            case .automatic:
                return luminance >= Tuning.automaticDarkForegroundLuminance
            case .dark:
                return true
            case .light:
                return false
            }
        }
    }

    struct Configuration: Sendable {
        public var isEnabled: Bool
        public var brightnessFloor: CGFloat
        public var saturationCeiling: CGFloat
        public var dirtinessThreshold: CGFloat
        public var normalizationStrength: CGFloat
        public var colorPreference: ColorPreference
        public var foregroundStrategy: ForegroundStrategy

        public init(
            isEnabled: Bool = true,
            brightnessFloor: CGFloat = 0.90,
            saturationCeiling: CGFloat = 0.12,
            dirtinessThreshold: CGFloat = 0.01,
            normalizationStrength: CGFloat = 0.88,
            colorPreference: ColorPreference = .preserveHue,
            foregroundStrategy: ForegroundStrategy = .automatic
        ) {
            self.isEnabled = isEnabled
            self.brightnessFloor = brightnessFloor.clamped(to: Tuning.unitRange)
            self.saturationCeiling = saturationCeiling.clamped(to: Tuning.unitRange)
            self.dirtinessThreshold = dirtinessThreshold.clamped(to: Tuning.unitRange)
            self.normalizationStrength = normalizationStrength.clamped(to: Tuning.unitRange)
            self.colorPreference = colorPreference
            self.foregroundStrategy = foregroundStrategy
        }

        public static let reading = Configuration(
            brightnessFloor: 0.90,
            saturationCeiling: 0.12,
            dirtinessThreshold: 0.01,
            normalizationStrength: 0.88,
            colorPreference: .preserveHue
        )

        fileprivate func dirtiness(of color: ColorComponents) -> CGFloat {
            let darkness = max(.zero, (brightnessFloor - color.brightness) / brightnessFloor)
            let chroma = max(.zero, (color.saturation - saturationCeiling) / (1 - saturationCeiling))
            let score = min(
                1,
                darkness * Tuning.darknessWeight + chroma * Tuning.chromaWeight
            )
            return score > dirtinessThreshold ? score : 0
        }

        fileprivate func normalized(
            _ color: ColorComponents,
            dirtiness: CGFloat
        ) -> ColorComponents {
            let strength = dirtiness * normalizationStrength
            let targetSaturation = colorPreference.saturation(
                source: color.saturation,
                strength: strength,
                ceiling: saturationCeiling
            )
            let targetBrightness = max(
                color.brightness,
                brightnessFloor + (1 - brightnessFloor) * strength
            )
            let targetHue = colorPreference.hue(
                source: color.hue,
                strength: strength
            )
            return ColorComponents(
                hue: targetHue,
                saturation: targetSaturation,
                brightness: targetBrightness,
                alpha: color.alpha
            )
        }
    }

    struct Result {
        public let background: CGColor
        public let foreground: CGColor
        public let usesDarkForeground: Bool
        public let wasNormalized: Bool
    }
}

private struct ColorComponents {
    let hue: CGFloat
    let saturation: CGFloat
    let brightness: CGFloat
    let alpha: CGFloat

    init?(color: CGColor) {
        guard let space = CGColorSpace(name: CGColorSpace.sRGB),
              let converted = color.converted(to: space, intent: .defaultIntent, options: nil),
              let values = converted.components,
              values.count >= 3 else {
            return nil
        }

        let red = values[0]
        let green = values[1]
        let blue = values[2]
        let maximum = max(red, green, blue)
        let minimum = min(red, green, blue)
        let delta = maximum - minimum

        let hue: CGFloat
        if delta == 0 {
            hue = 0
        } else if maximum == red {
            hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6) / 6
        } else if maximum == green {
            hue = ((blue - red) / delta + 2) / 6
        } else {
            hue = ((red - green) / delta + 4) / 6
        }

        self.init(
            hue: hue >= 0 ? hue : hue + 1,
            saturation: maximum == 0 ? 0 : delta / maximum,
            brightness: maximum,
            alpha: values.count > 3 ? values[3] : 1
        )
    }

    init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        self.hue = hue.clamped(to: KLAdaptiveSurface.Tuning.unitRange)
        self.saturation = saturation.clamped(to: KLAdaptiveSurface.Tuning.unitRange)
        self.brightness = brightness.clamped(to: KLAdaptiveSurface.Tuning.unitRange)
        self.alpha = alpha.clamped(to: KLAdaptiveSurface.Tuning.unitRange)
    }

    var relativeLuminance: CGFloat {
        let rgb = rgbComponents
        return rgb.red * 0.2126 + rgb.green * 0.7152 + rgb.blue * 0.0722
    }

    var cgColor: CGColor {
        let rgb = rgbComponents
        return CGColor(
            red: rgb.red,
            green: rgb.green,
            blue: rgb.blue,
            alpha: alpha
        )
    }

    private var rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let scaledHue = hue * 6
        let sector = Int(scaledHue.rounded(.down))
        let fraction = scaledHue - CGFloat(sector)
        let low = brightness * (1 - saturation)
        let middle = brightness * (1 - saturation * fraction)
        let high = brightness * (1 - saturation * (1 - fraction))

        switch sector % 6 {
        case 0: return (brightness, high, low)
        case 1: return (middle, brightness, low)
        case 2: return (low, brightness, high)
        case 3: return (low, middle, brightness)
        case 4: return (high, low, brightness)
        default: return (brightness, low, middle)
        }
    }
}

private extension KLAdaptiveSurface.ColorPreference {
    func saturation(
        source: CGFloat,
        strength: CGFloat,
        ceiling: CGFloat
    ) -> CGFloat {
        switch self {
        case .preserveHue:
            return source * (1 - strength)
        case .neutral:
            return min(source, ceiling) * (1 - strength)
        case .cool, .warm:
            return min(source, ceiling) * (1 - strength * KLAdaptiveSurface.Tuning.secondarySaturationStrength)
        }
    }

    func hue(source: CGFloat, strength: CGFloat) -> CGFloat {
        switch self {
        case .preserveHue, .neutral:
            return source
        case .cool:
            return source + (KLAdaptiveSurface.Tuning.coolReferenceHue - source)
                * strength * KLAdaptiveSurface.Tuning.hueBiasStrength
        case .warm:
            return source + (KLAdaptiveSurface.Tuning.warmReferenceHue - source)
                * strength * KLAdaptiveSurface.Tuning.hueBiasStrength
        }
    }
}

private extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
