<img src="http://upload-images.jianshu.io/upload_images/1594222-9138623383b862a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" alt="" />


FlyCoding is a Xcode plugin to make auto generate swift code with tag syntax.

[![Build Status](https://travis-ci.org/SnapKit/SnapKit.svg)](https://travis-ci.org/SnapKit/SnapKit)
[![Platform](https://img.shields.io/cocoapods/p/SnapKit.svg?style=flat)](https://github.com/SnapKit/SnapKit)

#### ⚠️ **To use with Swift 4.x please ensure you are using >= 4.0.0** ⚠️ 

## Contents

- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
  - Generate Constraints (SnapKit)
  - Generate Property
  - Generate View
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

### Generate Constraints (use [SnapKit](https://github.com/SnapKit/SnapKit/blob/develop/README.md#license))

> *Grammar:*  ***`#snpm(iconView, l=titleLabel.r+10, y=titleLabel)`***
```swift
// #snpm(iconView, l=titleLabel.r+10, y=titleLabel)
iconView.snp.makeConstraints {
    $0.left.equalTo(titleLabel.snp.right).offset(10)
    $0.centerY.equalTo(titleLabel)
}

// #snpm(iconView, r=titleLabel.l-20, wh=20)
iconView.snp.makeConstraints {
    $0.right.equalTo(titleLabel.snp.left).offset(-20)
    $0.width.height.equalTo(20)
}

// #snpm(iconView, t=titleLabel.b+titleLabel.height-20, w=titLabel*0.5)
iconView.snp.makeConstraints {
    $0.top.equalTo(titleLabel.snp.bottom).offset(titleLabel.height-20)
    $0.width.equalTo(titLabel).multipliedBy(0.5)
}

// #snpm(iconView, l = superView, r <= superView~l, r <= titleLabel.l - 20~h)
iconView.snp.makeConstraints {
    $0.left.equalTo(superView)
    $0.right.lessThanOrEqualTo(superView).priority(.low)
    $0.right.lessThanOrEqualTo(titleLabel.snp.left).offset(-20).priority(.high)
}

```
**Constraints List**

```swift
// ConstraintMakerExtendable
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
                       
// ConstraintPriority
let flags = ["r": ".required",
             "h": ".high",
             "m": ".medium",
             "l": ".low"]
             
// compareFlagCode             
let flags = [">=": "greaterThanOrEqualTo",
             "<=": "lessThanOrEqualTo",
             "=": "equalTo"]

// computeFlagCode
let flags = ["-": "offset(-value)",
             "+": "offset(value)",
             "*": "multipliedBy(value)",
             "/": "dividedBy(value)"]
```


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

## Credits

- SSBun ([@ssbun](http://www.jianshu.com/u/3e8081b02399))

## License

FlyCoding is released under the MIT license. See LICENSE for details.
