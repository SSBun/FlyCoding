//
//  Color+Extension.swift
//  Scaffold
//
//  Created by caishilin on 2022/3/1.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension UniversalColor: BZCompatible {}
public extension BZ where Base: UniversalColor {
    /// The hex string format of colors.
    enum HexColorFormat {
        /// (red, green ,blue, alpha)
        case rgba
        /// (alpha, red, green, blue)
        case argb
    }
    
    /// Creates a color specified by a hex string.
    /// - Parameters:
    ///   - hexString: A case insensitive string representing a hex.
    ///   - alpha: A float number from `0` to `1` to represent the color's transparence.
    ///   - hexColorFormat: The string format to representing colors of hex format.
    ///
    /// - Note: If the `hexString` contains an alpha value, you assign a value to
    /// the `alpha` prameter will override the `hexString`'s alpha vlaue.
    ///
    ///         hexString examples:
    ///         - **"abc"**
    ///         - **"abc7"**
    ///         - **"#abc7"**
    ///         - **"00FFFF"**
    ///         - **"#00FFFF"**
    ///         - **"7700FFFF"**
    ///         - **nil** clear color
    ///         - **empty string** clear color
    ///
    static func hex(
        _ hexString: String?,
        _ alpha: CGFloat? = nil,
        _ hexColorFormat: HexColorFormat = .rgba
    ) -> UniversalColor {
        let suffixAlpha = hexColorFormat == .rgba
        let normalizedHexString: String = normalize(hexString, suffixAlpha)
        var c: UInt64 = 0
        Scanner(string: normalizedHexString).scanHexInt64(&c)
        if suffixAlpha {
            return UniversalColor(
                red:   ColorSuffixAlphaMasks.redValue(c),
                green: ColorSuffixAlphaMasks.greenValue(c),
                blue:  ColorSuffixAlphaMasks.blueValue(c),
                alpha: alpha != nil ? alpha! : ColorSuffixAlphaMasks.alphaValue(c))
        } else {
            return UniversalColor(
                red: ColorPrefixAlphaMasks.redValue(c),
                green: ColorPrefixAlphaMasks.greenValue(c),
                blue: ColorPrefixAlphaMasks.blueValue(c),
                alpha: alpha != nil ? alpha! : ColorPrefixAlphaMasks.alphaValue(c))
        }
    }
    
    /// Returns a string of hex format equivalent of the current color.
    /// - Parameters:
    ///    - includeAlpha: A `Bool` value indicates whether containg the alpha value.
    ///    - hexColorFormat: The string format to representing colors of hex format.
    func hexDescription(
        _ includeAlpha: Bool = false,
        _ hexColorFormat: HexColorFormat = .rgba
    ) -> String {
        guard base.cgColor.numberOfComponents == 4 else {
            return "Color not RGB"
        }
        let a = base.cgColor.components!.map { Int($0 * CGFloat(255)) }
        let color = String.init(format: "%02x%02x%02x", a[0], a[1], a[2])
        if includeAlpha {
            let alpha = String.init(format: "%02x", a[3])
            return hexColorFormat == .rgba ? "\(color)\(alpha)" : "\(alpha)\(color)"
        }
        return color
    }
    
    private static func normalize(
        _ hex: String?,
        _ suffixAlpha: Bool = false
    ) -> String {
        guard var hexString = hex else {
            return "00000000"
        }
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        if hexString.count == 3 || hexString.count == 4 {
            hexString = hexString.map { "\($0)\($0)" } .joined()
        }
        let hasAlpha = hexString.count > 7
        if !hasAlpha {
            if suffixAlpha {
                hexString += "ff"
            } else {
                hexString = "ff" + hexString
            }
        }
        return hexString
    }
    
    private enum ColorSuffixAlphaMasks: UInt64 {
        case redMask    = 0xff000000
        case greenMask  = 0x00ff0000
        case blueMask   = 0x0000ff00
        case alphaMask  = 0x000000ff
        
        static func redValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & redMask.rawValue) >> 24) / 255.0
        }
        
        static func greenValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & greenMask.rawValue) >> 16) / 255.0
        }
        
        static func blueValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & blueMask.rawValue) >> 8) / 255.0
        }
        
        static func alphaValue(_ value: UInt64) -> CGFloat {
            return CGFloat(value & alphaMask.rawValue) / 255.0
        }
    }
    
    private enum ColorPrefixAlphaMasks: UInt64 {
        case redMask    = 0x00ff0000
        case greenMask  = 0x0000ff00
        case blueMask   = 0x000000ff
        case alphaMask  = 0xff000000
        
        static func redValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & redMask.rawValue) >> 16) / 255.0
        }
        
        static func greenValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & greenMask.rawValue) >> 8) / 255.0
        }
        
        static func blueValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & blueMask.rawValue)) / 255.0
        }
        
        static func alphaValue(_ value: UInt64) -> CGFloat {
            return CGFloat((value & alphaMask.rawValue) >> 24) / 255.0
        }
    }
}


