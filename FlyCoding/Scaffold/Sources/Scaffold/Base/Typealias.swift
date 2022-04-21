//
//  Aliases.swift
//  BZExtension
//
//  Created by caishilin on 2022/3/1.
//

import Foundation

#if canImport(UIKit)
import UIKit

public typealias UniversalColor = UIColor
public typealias UniversalImageView = UIImageView
public typealias UniversalImage = UIImage
public typealias UniversalStackView = UIStackView
public typealias UniversalView = UIView

#elseif canImport(AppKit)
import AppKit

public typealias UniversalColor = NSColor
public typealias UniversalImageView = NSImageView
public typealias UniversalImage = NSImage
public typealias UniversalStackView = NSStackView
public typealias UniversalView = NSView

#endif
