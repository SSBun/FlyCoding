<img src="http://upload-images.jianshu.io/upload_images/1594222-9138623383b862a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" alt="" />

#### ⚠️ **To use with Swift 4.x please ensure you are using >= 4.0.0** ⚠️ 



FlyCoding是一个Xcode插件，使用苹果提供的插件机制编写，可以运行在最新的Xcode上， 它提供了类似于HTML中 **Emmet** 的功能。你可以通过特殊语法来快速的生成你想要的**Swfit**代码，特别是在大量的编写界面UI时， 重复的编写UI控件和约束是一件非常繁琐和机械的劳动， 但是这又是你不可避免的。
而FlyCoding则可以帮助你快速的帮你生成**视图代码、属性、SnapKit约束**，目前FlyCoding刚刚发布了第一个版本，更多的功能还在构建当中，接下来我们先在看一下目前的三个功能：


![img](http://upload-images.jianshu.io/upload_images/1594222-4f086115d244a228.gif?imageMogr2/auto-orient/strip)

![img](http://upload-images.jianshu.io/upload_images/1594222-4ed65e4f26f2dfcf.gif?imageMogr2/auto-orient/strip)

![img](http://upload-images.jianshu.io/upload_images/1594222-2c296f57ecf6b251.gif?imageMogr2/auto-orient/strip)

### 生成Snapkit的约束代码
使用Swift来编写UI的时候，AutoLayout肯定是必不可少的。而直接使用苹果的AutoLayout约束语句太过于麻烦，所以我们肯定会使用一些布局框架来实现AutoLayout， 在Swift当中，SnapKit的使用量最高，它和OC中的Masonry有着几乎一样的语法，这也使得使用过Masonry的从OC转向Swift的开发者能很快的适应SnapKit的语法。

说完了SnapKit，我们来看一下FlyCoding是如何生成约束代码的, 我们假设有两个view(iconView 和 titleLabel)被添加在一个view(superView)上
先来看几个例子:
* **`#snpm(iconView, l=titleLabel.r+10, y=titleLabel)`**
```swift
//生成代码如下:
iconView.snp.makeConstraints {
    $0.left.equalTo(titleLabel.snp.right).offset(10)
    $0.centerY.equalTo(titleLabel)
}
```
在这里`#snpm`就是一个标签，它代表创建一个snapKit约束，而小括号内的就是约束的参数，`iconView`是指谁接受约束，`l=titleLabel.r+10` 就是指iconView的左侧等于IconView的右侧再偏移10个点的位置。而`y=titleLabel`就是指iconView的中心y轴和titleLabel的中心y轴相等。

* **`#snpm(iconView, r=titleLabel.l-20, wh=20)`**

类似的`wh=20`就是iconView的宽高等于20，你可以任意的组合要约束的部位，比如如果两个view的位置想同，你可以写`ltbr=titleLabel`,
`l=left、r=right、t=top、b=bottom`。 当然直接写`e=titleLabel`就是`edges`的意思。

* **`#snpm(iconView, t=titleLabel.b+superView.height-20, w=titLabel*0.5)`**
```swift
iconView.snp.makeConstraints {
    $0.top.equalTo(titleLabel.snp.bottom).offset(superView.height-20)
    $0.width.equalTo(titLabel).multipliedBy(0.5)
}
```
再FlyCoding中，`t=titleLabel.b+superView.height-20`中的第一个`+`号拥有最低的执行等级， 哪怕此处由`+`成了`*`它也不会参与到后面的计算当中，或者你可以说它有特殊的作用。
`w=titleLabel*0.5`就是说iconView的宽只有titleLabel的一半，这里写起来十分的简单。你也可以说是`w=titleLabel/2`,效果也是一样的。

* **`#snpm(iconView, l = superView, r <= superView~l, r <= titleLabel.l - 20~h)`**
```swift
iconView.snp.makeConstraints {
    $0.left.equalTo(superView)
    $0.right.lessThanOrEqualTo(superView).priority(.low)
    $0.right.lessThanOrEqualTo(titleLabel.snp.left).offset(-20).priority(.high)
}
```
这里的`<=`当然就是**小于等于**的意思啦， 在例子中你可以明显的看出它的用途，而`~`放在约束的最后用来设置约束的等级。你可以使用数值来表示，也可以通过几个默认的值如(r,h,m,l)来设置相应的约束等级。

* **`#snpm(iconView, t=titleLabel.b-20, w=titLabel*0.5) + snpm(titleLabe, wh = 100)`**
```swift
iconView.snp.makeConstraints {
    $0.top.equalTo(titleLabel.snp.bottom).offset(-20)
    $0.width.equalTo(titLabel).multipliedBy(0.5)
}

titleLabe.snp.makeConstraints {
    $0.width.height.equalTo(100)
}
```

**如果你在一个约束写完以后想要直接写下一个直接在中间连一个`+`号即可，后面的`snpm`不用在跟`#`,`#`号是用来区分功能的. 所有同模块的功能都能在中间加上+号来连接**

更多的用法，大家可以去尝试，下面是它的所有可用项：

**除了#snpm以外，还可以使用#snprm、#snp，来分别remake和update约束**

> * **属性** * 
>   * `l -> left`
>   * `t -> top`
>   * `b -> bottom`
>   * `r -> right`
>   * `w -> width`
>   * `h -> height`
>   * `x -> centerX`
>   * `y -> centerY`
>   * `c -> center`
>   * `s -> size`
>   * `e -> edges`

> * **约束等级**
>   * `r -> .required`
>   * `h -> .high`
>   * `m -> .medium`
>   * `l -> .low`

> * **比较参数**
>   * `>= -> greaterThanOrEqualTo `
>   * `<= -> lessThanOrEqualTo `
>   * `= -> equalTo`

> * **运算符**
>   * `-` `-> offset(-value)`
>   * `+ -> offset(value)`
>   * `* -> multipliedBy(value)`
>   * `/ -> dividedBy(value)`

### 生成属性代码

如果你已经看过了SnapKit的用法，那这里就容易的多了，话不多说，我们举个🌰

* **`pl.UIView{}*2 + .l.String{""}`**
```swift
  private let name = UIView()
  private let name = UIView()
  private let name = ""
```
不需要任何的前缀，`pl`分别是`private`和`let`,其实都是第一个字母. `UIView`表示你要创建的`Class`, `{}`就是你要初始化的意思，默认的初始化是在类名后面加上一对小括号, 当然你也可以在{}中写上你想要的默认值，`*2`就是要把这个属性重复两遍，对于码界面的时候，一个界面上显示多个UILabel是很正常的事，这里再也不用复制粘贴了。后面就很容易理解了,`{""}`的意思就是创建String的默认值

FlyCoding 会在你使用了默认值的时候，把你的类名给省略掉，如果你并没有设置默认值，就会是这个样子
* **`@pl.String`**
```swift
@objc private let name: String
```

用起来十分的简单，下面是你能使用的属性

```swift
"l": "let",
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
"lv": "lazy var",

"@": "@objc",
"u": "unowned",
"w": "weak",
"c": "class"
```

### 生成view代码

这部分使用Xcode的代码块也可以实现，但是写代码的时候，打出了对应的短语后还要看一眼和等待Xcode反应实在是令人着急。我们为的就是快！！！
通过**#make()**命令我们可以快速的添加创建一个View的代码，又是一波🌰

* **`#make(UILabel) + make(UILabel) + make(UITableView) + make(UICollectionView)`**
```swift
let name = UILabel()
name.font = font
name.textColor = color
name.text = text
name.backgroundColor = color
superView.addSubview(name)

let name = UILabel()
name.font = font
name.textColor = color
name.text = text
name.backgroundColor = color
superView.addSubview(name)

let name = UITableView(frame: frame, style: style)
name.backgroundColor = color
name.delegate = delegate
name.dataSource = dataSource
name.separatorStyle = style
name.register(class, forCellReuseIdentifier: identifier)
superView.addSubview(name)

let flowLayout = UICollectionViewFlowLayout()
flowLayout.scrollDirection = direction
flowLayout.minimumInteritemSpacing = spacing
let name = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
name.showsVerticalScrollIndicator = show
name.showsHorizontalScrollIndicator = show
name.dataSource = self
name.delegate = self
name.backgroundColor = color
name.register(class, forCellWithReuseIdentifier: id)
superView.addSubview(name)
```
当然了，这里你同样可是使用`*`来创建多个视图，目前支持的种类不是很多，常见的够用，以后会继续的添加

**这是目前支持的创建类型**
- UIView
- UILabel
- UIButton
- UIImageView
- UITableView
- UICollectionView

然后，目前的主要功能就说完了，刚开始使用的时候可能不习惯，但是用惯了以后，真不想在一行一行的去敲键盘了，对于码农来说，懒就是生产力。

现在你可以跳转到[FlyCoding](https://github.com/SSBun/FlyCoding/blob/master/README.md#installation)去下载此插件，你可以直接下载作者的[压缩包](https://github.com/SSBun/FlyCoding/blob/master/FlyCoding.zip) 打开后，直接运行程序，然后关闭程序就ok了，最好设置一个你喜欢的快捷键，这样才能体会飞一般的速度。

如果有什么问题的话，大家可以在github上提交issue，有想要的特性也可以提交issue。











 [图片上传失败...(image-a8f742-1510135880746)]

FlyCoding是一个Xcode插件，使用苹果提供的插件机制编写，可以运行在最新的Xcode上， 它提供了类似于HTML中 **Emmet** 的功能。你可以通过特殊语法来快速的生成你想要的**Swfit**代码，特别是在大量的编写界面UI时， 重复的编写UI控件和约束是一件非常繁琐和机械的劳动， 但是这又是你不可避免的。
而FlyCoding则可以帮助你快速的帮你生成**视图代码、属性、SnapKit约束**，目前FlyCoding刚刚发布了第一个版本，更多的功能还在构建当中，接下来我们先在看一下目前的三个功能：

### 生成Snapkit的约束代码
使用Swift来编写UI的时候，AutoLayout肯定是必不可少的。而直接使用苹果的AutoLayout约束语句太过于麻烦，所以我们肯定会使用一些布局框架来实现AutoLayout， 在Swift当中，SnapKit的使用量最高，它和OC中的Masonry有着几乎一样的语法，这也使得使用过Masonry的从OC转向Swift的开发者能很快的适应SnapKit的语法。

说完了SnapKit，我们来看一下FlyCoding是如何生成约束代码的, 我们假设有两个view(iconView 和 titleLabel)被添加在一个view(superView)上
先来看几个例子:
* **`#snpm(iconView, l=titleLabel.r+10, y=titleLabel)`**
```swift
//生成代码如下:
iconView.snp.makeConstraints {
    $0.left.equalTo(titleLabel.snp.right).offset(10)
    $0.centerY.equalTo(titleLabel)
}
```
在这里`#snpm`就是一个标签，它代表创建一个snapKit约束，而小括号内的就是约束的参数，`iconView`是指谁接受约束，`l=titleLabel.r+10` 就是指iconView的左侧等于IconView的右侧再偏移10个点的位置。而`y=titleLabel`就是指iconView的中心y轴和titleLabel的中心y轴相等。

* **`#snpm(iconView, r=titleLabel.l-20, wh=20)`**

类似的`wh=20`就是iconView的宽高等于20，你可以任意的组合要约束的部位，比如如果两个view的位置想同，你可以写`ltbr=titleLabel`,
`l=left、r=right、t=top、b=bottom`。 当然直接写`e=titleLabel`就是`edges`的意思。

* **`#snpm(iconView, t=titleLabel.b+superView.height-20, w=titLabel*0.5)`**
```swift
iconView.snp.makeConstraints {
    $0.top.equalTo(titleLabel.snp.bottom).offset(superView.height-20)
    $0.width.equalTo(titLabel).multipliedBy(0.5)
}
```
再FlyCoding中，`t=titleLabel.b+superView.height-20`中的第一个`+`号拥有最低的执行等级， 哪怕此处由`+`成了`*`它也不会参与到后面的计算当中，或者你可以说它有特殊的作用。
`w=titleLabel*0.5`就是说iconView的宽只有titleLabel的一半，这里写起来十分的简单。你也可以说是`w=titleLabel/2`,效果也是一样的。

* **`#snpm(iconView, l = superView, r <= superView~l, r <= titleLabel.l - 20~h)`**
```swift
iconView.snp.makeConstraints {
    $0.left.equalTo(superView)
    $0.right.lessThanOrEqualTo(superView).priority(.low)
    $0.right.lessThanOrEqualTo(titleLabel.snp.left).offset(-20).priority(.high)
}
```
这里的`<=`当然就是**小于等于**的意思啦， 在例子中你可以明显的看出它的用途，而`~`放在约束的最后用来设置约束的等级。你可以使用数值来表示，也可以通过几个默认的值如(r,h,m,l)来设置相应的约束等级。

* **`#snpm(iconView, t=titleLabel.b-20, w=titLabel*0.5) + snpm(titleLabe, wh = 100)`**
```swift
iconView.snp.makeConstraints {
    $0.top.equalTo(titleLabel.snp.bottom).offset(-20)
    $0.width.equalTo(titLabel).multipliedBy(0.5)
}

titleLabe.snp.makeConstraints {
    $0.width.height.equalTo(100)
}
```

**如果你在一个约束写完以后想要直接写下一个直接在中间连一个`+`号即可，后面的`snpm`不用在跟`#`,`#`号是用来区分功能的. 所有同模块的功能都能在中间加上+号来连接**

更多的用法，大家可以去尝试，下面是它的所有可用项：

**除了#snpm以外，还可以使用#snprm、#snp，来分别remake和update约束**

> * **属性** * 
>   * `l -> left`
>   * `t -> top`
>   * `b -> bottom`
>   * `r -> right`
>   * `w -> width`
>   * `h -> height`
>   * `x -> centerX`
>   * `y -> centerY`
>   * `c -> center`
>   * `s -> size`
>   * `e -> edges`

> * **约束等级**
>   * `r -> .required`
>   * `h -> .high`
>   * `m -> .medium`
>   * `l -> .low`

> * **比较参数**
>   * `>= -> greaterThanOrEqualTo `
>   * `<= -> lessThanOrEqualTo `
>   * `= -> equalTo`

> * **运算符**
>   * `-` `-> offset(-value)`
>   * `+ -> offset(value)`
>   * `* -> multipliedBy(value)`
>   * `/ -> dividedBy(value)`

### 生成属性代码

如果你已经看过了SnapKit的用法，那这里就容易的多了，话不多说，我们举个🌰

* **`pl.UIView{}*2 + .l.String{""}`**
```swift
  private let name = UIView()
  private let name = UIView()
  private let name = ""
```
不需要任何的前缀，`pl`分别是`private`和`let`,其实都是第一个字母. `UIView`表示你要创建的`Class`, `{}`就是你要初始化的意思，默认的初始化是在类名后面加上一对小括号, 当然你也可以在{}中写上你想要的默认值，`*2`就是要把这个属性重复两遍，对于码界面的时候，一个界面上显示多个UILabel是很正常的事，这里再也不用复制粘贴了。后面就很容易理解了,`{""}`的意思就是创建String的默认值

FlyCoding 会在你使用了默认值的时候，把你的类名给省略掉，如果你并没有设置默认值，就会是这个样子
* **`@pl.String`**
```swift
@objc private let name: String
```

用起来十分的简单，下面是你能使用的属性

```swift
"l": "let",
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
"lv": "lazy var",

"@": "@objc",
"u": "unowned",
"w": "weak",
"c": "class"
```

### 生成view代码

这部分使用Xcode的代码块也可以实现，但是写代码的时候，打出了对应的短语后还要看一眼和等待Xcode反应实在是令人着急。我们为的就是快！！！
通过**#make()**命令我们可以快速的添加创建一个View的代码，又是一波🌰

* **`#make(UILabel) + make(UILabel) + make(UITableView) + make(UICollectionView)`**
```swift
let name = UILabel()
name.font = font
name.textColor = color
name.text = text
name.backgroundColor = color
superView.addSubview(name)

let name = UILabel()
name.font = font
name.textColor = color
name.text = text
name.backgroundColor = color
superView.addSubview(name)

let name = UITableView(frame: frame, style: style)
name.backgroundColor = color
name.delegate = delegate
name.dataSource = dataSource
name.separatorStyle = style
name.register(class, forCellReuseIdentifier: identifier)
superView.addSubview(name)

let flowLayout = UICollectionViewFlowLayout()
flowLayout.scrollDirection = direction
flowLayout.minimumInteritemSpacing = spacing
let name = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
name.showsVerticalScrollIndicator = show
name.showsHorizontalScrollIndicator = show
name.dataSource = self
name.delegate = self
name.backgroundColor = color
name.register(class, forCellWithReuseIdentifier: id)
superView.addSubview(name)
```
当然了，这里你同样可是使用`*`来创建多个视图，目前支持的种类不是很多，常见的够用，以后会继续的添加

**这是目前支持的创建类型**
- UIView
- UILabel
- UIButton
- UIImageView
- UITableView
- UICollectionView

# 1.1
#### 新增方法创建功能
* **` #func(p.getAge:>)  `**
```
private func getAge(param) -> return {
    code
}
```
通过 `#func`调用，只有一个参数，`getAge`是方法名， `p`就是方法权限， 中间使用`.`隔开，与我们使用属性时相同, 参数中的`:`和`>`分别代表是否有参数和返回值。同样可以使用`*`来进行复制，或是使用`+`来继续添加

当然也可以写入多个`:`来生成多个参数，大于一个`>`所产生的返回是一个元组，元组在Swfit中可以被用来返回多个结果

#### 新增UIView动画创建功能(相比较系统的自动提示并没有什么太大的区别，就是懒得选)
* **` #anim(df)`**
```
UIView.animate(withDuration: T##TimeInterval) {
    code
}
```
通过 `#anim`调用，只有一个参数用来表示是什么动动画
* df 普通的动画
* dc  带完成回调的普通动画
* dd 普通延时动画
* ds 弹簧动画
* dk 关键帧动画


#End


FlyCoding is a Xcode plugin to make auto-generate swift code with marking language.


![img](https://ws2.sinaimg.cn/large/006tKfTcly1fljxvy6u2og30go0g4gmi.gif)

![img](https://ws1.sinaimg.cn/large/006tKfTcly1fljxx4234bg30go0g4gm5.gif)

![img](https://ws2.sinaimg.cn/large/006tKfTcly1fljxxaavzdg30go0g4dgp.gif)

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

### Download Application
[FlyCoding.dmg](https://github.com/SSBun/FlyCoding/blob/master/FlyCoding.dmg)

### Build Project
* You can download this project and build it in your Xcode
* You should move the application in project folder 'Products' to Mac Application and run it.

⚠️ **If you cannot see 'flyCoding' in Xcode menu Editor, you can go to System Extension config to check flyCoding** ⚠️

---

## Usage

[中文指南](http://www.jianshu.com/p/5a1b064b2457)

You write marking language then click FlyCoding or use shortcut, The generated code will be print.

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

### Generate Func




---

## Credits

- SSBun ([@ssbun](http://www.jianshu.com/u/3e8081b02399))

## License

FlyCoding is released under the MIT license. See LICENSE for details.


