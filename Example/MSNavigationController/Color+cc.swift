//
//  Color+cc.swift
//  CloudCity
//
//  Created by marshal on 2021/4/2.
//  Copyright © 2021 CC. All rights reserved.
//

import UIKit

// MARK: - Color Builders
public extension UIColor {
  /// Constructing color from hex string
  ///
  /// - Parameter hex: A hex string, can either contain # or not
  convenience init(hex string: String) {
    var hex = string.hasPrefix("#")
      ? String(string.dropFirst())
      : string
    guard hex.count == 3 || hex.count == 6
      else {
        self.init(white: 1.0, alpha: 0.0)
        return
    }
    if hex.count == 3 {
      for (index, char) in hex.enumerated() {
        hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
      }
    }
    
    guard let intCode = Int(hex, radix: 16) else {
      self.init(white: 1.0, alpha: 0.0)
      return
    }
    
    self.init(
      red:   CGFloat((intCode >> 16) & 0xFF) / 255.0,
      green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
      blue:  CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0)
  }
  
  /// Adjust color based on saturation
  ///
  /// - Parameter minSaturation: The minimun saturation value
  /// - Returns: The adjusted color
  func color(minSaturation: CGFloat) -> UIColor {
    var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    return saturation < minSaturation
      ? UIColor(hue: hue, saturation: minSaturation, brightness: brightness, alpha: alpha)
      : self
  }

  /// Convenient method to change alpha value
  ///
  /// - Parameter value: The alpha value
  /// - Returns: The alpha adjusted color
  func alpha(_ value: CGFloat) -> UIColor {
    return withAlphaComponent(value)
  }
}

// MARK: - Helpers
public extension UIColor {
  
    func hex(hashPrefix: Bool = true) -> String {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let prefix = hashPrefix ? "#" : ""
    
    return String(format: "\(prefix)%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
  }
  
  internal func rgbComponents() -> [CGFloat] {
    var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return [r, g, b]
  }
  
  var isDark: Bool {
    let RGB = rgbComponents()
    return (0.2126 * RGB[0] + 0.7152 * RGB[1] + 0.0722 * RGB[2]) < 0.5
  }
  
  var isBlackOrWhite: Bool {
    let RGB = rgbComponents()
    return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91) || (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
  }
  
  var isBlack: Bool {
    let RGB = rgbComponents()
    return (RGB[0] < 0.09 && RGB[1] < 0.09 && RGB[2] < 0.09)
  }
  
  var isWhite: Bool {
    let RGB = rgbComponents()
    return (RGB[0] > 0.91 && RGB[1] > 0.91 && RGB[2] > 0.91)
  }
  
  func isDistinct(from color: UIColor) -> Bool {
    let bg = rgbComponents()
    let fg = color.rgbComponents()
    let threshold: CGFloat = 0.25
    var result = false
    
    if abs(bg[0] - fg[0]) > threshold || abs(bg[1] - fg[1]) > threshold || abs(bg[2] - fg[2]) > threshold {
        if abs(bg[0] - bg[1]) < 0.03 && abs(bg[0] - bg[2]) < 0.03 {
            if abs(fg[0] - fg[1]) < 0.03 && abs(fg[0] - fg[2]) < 0.03 {
          result = false
        }
      }
      result = true
    }
    
    return result
  }
  
  func isContrasting(with color: UIColor) -> Bool {
    let bg = rgbComponents()
    let fg = color.rgbComponents()
    
    let bgLum = 0.2126 * bg[0] + 0.7152 * bg[1] + 0.0722 * bg[2]
    let fgLum = 0.2126 * fg[0] + 0.7152 * fg[1] + 0.0722 * fg[2]
    let contrast = bgLum > fgLum
      ? (bgLum + 0.05) / (fgLum + 0.05)
      : (fgLum + 0.05) / (bgLum + 0.05)
    
    return 1.6 < contrast
  }
  
}

// MARK: - Gradient
public extension Array where Element : UIColor {
  
  func gradient(_ transform: ((_ gradient: inout CAGradientLayer) -> CAGradientLayer)? = nil) -> CAGradientLayer {
    var gradient = CAGradientLayer()
    gradient.colors = self.map { $0.cgColor }
    
    if let transform = transform {
      gradient = transform(&gradient)
    }
    
    return gradient
  }
}

// MARK: - Components
public extension UIColor {

  var redComponent: CGFloat {
    var red: CGFloat = 0
    getRed(&red, green: nil , blue: nil, alpha: nil)
    return red
  }

  var greenComponent: CGFloat {
    var green: CGFloat = 0
    getRed(nil, green: &green , blue: nil, alpha: nil)
    return green
  }

  var blueComponent: CGFloat {
    var blue: CGFloat = 0
    getRed(nil, green: nil , blue: &blue, alpha: nil)
    return blue
  }

  var alphaComponent: CGFloat {
    var alpha: CGFloat = 0
    getRed(nil, green: nil , blue: nil, alpha: &alpha)
    return alpha
  }

  var hueComponent: CGFloat {
    var hue: CGFloat = 0
    getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
    return hue
  }

  var saturationComponent: CGFloat {
    var saturation: CGFloat = 0
    getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
    return saturation
  }

  var brightnessComponent: CGFloat {
    var brightness: CGFloat = 0
    getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
    return brightness
  }
}


// MARK: - Blending
public extension UIColor {
  
  /**adds hue, saturation, and brightness to the HSB components of this color (self)*/
  func add(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
    var (oldHue, oldSat, oldBright, oldAlpha) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    getHue(&oldHue, saturation: &oldSat, brightness: &oldBright, alpha: &oldAlpha)
    
    // make sure new values doesn't overflow
    var newHue = oldHue + hue
    while newHue < 0.0 { newHue += 1.0 }
    while newHue > 1.0 { newHue -= 1.0 }
    
    let newBright: CGFloat = max(min(oldBright + brightness, 1.0), 0)
    let newSat: CGFloat = max(min(oldSat + saturation, 1.0), 0)
    let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
    
    return UIColor(hue: newHue, saturation: newSat, brightness: newBright, alpha: newAlpha)
  }
  
  /**adds red, green, and blue to the RGB components of this color (self)*/
  func add(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    var (oldRed, oldGreen, oldBlue, oldAlpha) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    getRed(&oldRed, green: &oldGreen, blue: &oldBlue, alpha: &oldAlpha)
    // make sure new values doesn't overflow
    let newRed: CGFloat = max(min(oldRed + red, 1.0), 0)
    let newGreen: CGFloat = max(min(oldGreen + green, 1.0), 0)
    let newBlue: CGFloat = max(min(oldBlue + blue, 1.0), 0)
    let newAlpha: CGFloat = max(min(oldAlpha + alpha, 1.0), 0)
    return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
  }
  
  func add(hsb color: UIColor) -> UIColor {
    var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return self.add(hue: h, saturation: s, brightness: b, alpha: 0)
  }
  
  func add(rgb color: UIColor) -> UIColor {
    return self.add(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: 0)
  }
  
  func add(hsba color: UIColor) -> UIColor {
    var (h,s,b,a) : (CGFloat, CGFloat, CGFloat, CGFloat) = (0,0,0,0)
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return self.add(hue: h, saturation: s, brightness: b, alpha: a)
  }
  
  /**adds the rgb components of two colors*/
  func add(rgba color: UIColor) -> UIColor {
    return self.add(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: color.alphaComponent)
  }
}
public extension UIColor{
    static func dl_color(withHexString hex:String) -> UIColor{
        return UIColor(hex: hex)
    }
    ///主蓝色，如确认按钮
    static func dl_3944BD()->UIColor{
        return dl_color(withHexString: "#3944BD")
    }
    ///淡蓝色
    static func dl_C3CFFB()->UIColor{
        return dl_color(withHexString: "#C3CFFB")
    }
    ///浅蓝色
    static func dl_E6EBFD()->UIColor{
        return dl_color(withHexString: "#E6EBFD")
    }
    ///灰色，按钮disable色
    static func dl_CBCBD8()->UIColor{
        return dl_color(withHexString: "#CBCBD8")
    }
    ///蓝色，如超链接色
    static func dl_0A74F1()->UIColor{
        return dl_color(withHexString: "#0A74F1")
    }
    ///橙色
    static func dl_EB7838()->UIColor{
        return dl_color(withHexString: "#EB7838")
    }
    ///浅橙色
    static func dl_FCF0EC()->UIColor{
        return dl_color(withHexString: "#FCF0EC")
    }
    ///红色，警告色
    static func dl_EC1037()->UIColor{
        return dl_color(withHexString: "#EC1037")
    }
    ///绿色，成功色
    static func dl_1EA31C()->UIColor{
        return dl_color(withHexString: "#1EA31C")
    }
    ///浅绿色
    static func dl_A7F9A6()->UIColor{
        return dl_color(withHexString: "#A7F9A6")
    }
    ///黑色，主文字色
    static func dl_211C40()->UIColor{
        return dl_color(withHexString: "#211C40")
    }
    ///灰色，二级文字色
    static func dl_9797A7()->UIColor{
        return dl_color(withHexString: "#9797A7")
    }
    ///灰色，三级文字色
    static func dl_C4C4CE()->UIColor{
        return dl_color(withHexString: "#C4C4CE")
    }
    ///灰色，四级灰
    static func dl_D6D6E4()->UIColor{
        return dl_color(withHexString: "#D6D6E4")
    }
    ///常用于背景色
    static func dl_backGroundColor()->UIColor{
        return dl_color(withHexString: "#F6F6F6")
    }
}
