<img src="http://snapkit.io/images/banner.jpg" alt="" />

FlyCoding is a Xcode plugin to make auto generate swift code with tag syntax.

[![Build Status](https://travis-ci.org/SnapKit/SnapKit.svg)](https://travis-ci.org/SnapKit/SnapKit)
[![Platform](https://img.shields.io/cocoapods/p/SnapKit.svg?style=flat)](https://github.com/SnapKit/SnapKit)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/SnapKit.svg)](https://cocoapods.org/pods/SnapKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

#### ⚠️ **To use with Swift 4.x please ensure you are using >= 4.0.0** ⚠️ 

## Contents

- [Requirements](#requirements)
- [Migration Guides](#migration-guides)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
- [Credits](#credits)
- [License](#license)

## Requirements

- Xcode 9.0+
- Swift 4.0+

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Installation

* You can download this project and build it in your Xcode
* You should move the application in project folder 'Products' to Mac Application and open it. Then you can close it.

⚠️ **If you cannot see 'flyCoding' in Xcode menu Editor, you can go to System Extension config to check flyCoding** ⚠️

---

## Usage

You print tag syntax and click FlyCoding or shortcut, The generated code will be print.

### Generate Property

> *Grammar:*  ***`pl.UIView{}*2 + .l.String{""}`***

```swift
  private let <#name#> = UIView()
  private let <#name#> = UIView()
  private let <#name#> = ""
```
- `[pl]` is property prefix
- `[.]`  separate prefix and property class
- `[{}]` give a default value, you can pass a value or default `class()`
- `[*2]` you can duplicate the property serveal times.
- `[+]`  you can generate another property at the same time.

**Prefix List**

```swift
static let allScopeMark = ["l": "let",
                               "v": "var",
                               "p": "private",
                               "P": "public",
                               "o": "open",
                               "f": "fileprivate",
                               "pl": "private let",
                               "pv": "private var",
                               "Pl": "public let",
                               "Pv": "public var",
                               "ol": "open let",
                               "ov": "open var",
                               "fl": "fileprivate let",
                               "fv": "fileprivate var",
                               "lv": "lazy var"]
    
    static let allSystemMark = ["@": "@objc",
                                "u": "unowned",
                                "w": "weak",
                                "c": "class"]

```
---

### Generate View

> *Grammar:*  ***`#make(UILabel) + make(UIView)`***
```swift
let <#name#> = UILabel()
<#name#>.font = <#font#>
<#name#>.textColor = <#color#>
<#name#>.text = <#text#>
<#name#>.backgroundColor = <#color#>
<#superView#>.addSubview(<#name#>)

let <#name#>  = UIView()
<#name#>.backgroundColor = <#color#>
<#superView#>.addSubview(<#name#>)
```
**Supprot View**

- UIView
- UILabel
- UIButton
- UIImageView
- UITableView
- UICollectionView

---

### Generate Constraints (use [SnapKit](https://github.com/SnapKit/SnapKit/blob/develop/README.md#license))

> *Grammar:*  ***`#snpm(iconView, l = titleLabel.r + 10, y =  titleLabel)`***
```swift
iconView.snp.makeConstraints {
    $0.left.equalTo(titleLabel.snp.right).offset(10)
    $0.centerY.equalTo(titleLabel)
}
```
**Constraints List**

```swift
static let makerMap = ["l": "left",
                           "t": "top",
                           "b": "bottom",
                           "r": "right",
                           "w": "width",
                           "h": "height",
                           "x": "centerX",
                           "y": "centerY",
                           "c": "center",
                           "s": "size",
                           "e": "edges"]
```

---

## Credits

- SSBun ([@ssbun](http://www.jianshu.com/u/3e8081b02399))

## License

FlyCoding is released under the MIT license. See LICENSE for details.
