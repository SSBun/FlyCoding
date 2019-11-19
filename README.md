<img src="http://upload-images.jianshu.io/upload_images/1594222-9138623383b862a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" alt="" />

## FlyCoding - Xcode版 Emmet

#### ⚠️ 请使用 Swift 5 编译 ⚠️ 

FlyCoding 是一个 Xcode 插件，使用苹果提供的插件机制编写，可以运行在最新的Xcode上， 它提供了类似于前端中 **Emmet** 的功能。你可以通过特殊语法来快速的生成你想要的 **Swfit / Objective-C** 代码，特别是在大量的编写界面 UI 时， 重复的编写 UI 控件和约束是一件非常繁琐和机械的劳动， 但是这又是你不可避免的。
而 FlyCoding 则可以帮助你快速的生成**属性、方法、约束（Masonry / SnapKit）**，目前 FlyCoding 刚刚发布了第一个版本，更多的功能还在构思当中，希望大家提供宝贵的意见和想法。

##### 目前开发进度：
* [x] **2.0 版本中新增加强大的 @do 命令,  通过类shell命令对文本进行操作**
    * [x] **remove 命令**
    * [x] **to 命令**
    * [x] **copy 命令**
    * [x] **move 命令**
    * [x] **sort 命令**    
* [x] **Objective-C / Swift 属性生成**
* [x] **Objective-C / Swift 视图的快速创建**
* [x] **Masonry / SnapKit 约束生成**
* [x] **Swift 下的系统原生的 AutoLayout 约束**
* [x] **快速生成方法** 
* [x] **任何完整操作都可以使用 ' + ' 进行分隔， 使用 '\* N' 进行批量操作**

### @do 命令
```Swift
@do move 10 34 to 44
// 将 10 行到 34 行的内容移动到 44 行
//
//命令的使用方法非常的简单，你可以任何地方直接编写命令
//命令以 @do 开头，接下来是你要操作的命令
//这里的 move 是移动命令，接下来饿 10 是起始行 34 是结束行
//to 也是一个命令，它是负责将内容移动到指定的位置
//to 并不是 move 命令的组合命令，它是一个独立的命令，详细的会在 to 命令中介绍中
//接下来是 to 命令的参数
```
理论上可以衔接无限制的命令数量，每个命令都是独立处理的单元，处理完毕后会通过一个通用的 `context` 进行状态传递，随着命令越来越多，一定会有更多神奇的连接用法。
#### 删除命令
* **remove/rm**
    * **`@do rm 10 .`**
    * **arg1 `[arg2]`**
        * `arg1` 表示起始行数
        * `arg2` 表示结束行数，此参数可以为空，此时 `arg1` 表示要删除的行
        * 除了可以使用 `数字` 表示行数外，也可以通过 `.` 来代表命令的当前行

#### 移动命令
* **move/mv**
  * **`@do mv 10 . to 30`**
  * **arg1 `[arg2]`**
        * `arg1` 表示起始行数
        * `arg2` 表示结束行数，此参数可以为空，此时 `arg1` 表示要移动的行
        * 除了可以使用 `数字` 表示行数外，也可以通过 `.` 来代表命令的当前行
  * **to arg1**
        * `to` 移动到指定位置需要配合 `to` 命令
        * `arg1` 表示要移动到的行

#### 拷贝命令
* **copy/cp**
  * **`@do cp 10 . to 30`**
  * **arg1 `[arg2]`**
        * `arg1` 表示起始行数
        * `arg2` 表示结束行数，此参数可以为空，此时 `arg1` 表示要拷贝的行
        * 除了可以使用 `数字` 表示行数外，也可以通过 `.` 来代表命令的当前行
  * **to arg1**
        * `to` 移动到指定位置需要配合 `to` 命令
        * `arg1` 表示要移动到的行     
        
#### 排序命令
将范围内的代码根据每行的长度，按照从少到多排列

* **sort/st**
    * **`@do st 10 . to 30`**
    * **arg1 `[arg2]`**
        * `arg1` 表示起始行数
        * `arg2` 表示结束行数，此时 `arg1` 表示结束行
        * 除了可以使用 `数字` 表示行数外，也可以通过 `.` 来代表命令的当前行

### 属性生成
#### Swift属性生成
* **单个属性**

```Swift
pv.UIImageView
// pv 是属性控制，p 是 private， v 是 var，具体的列表可以在后文中查看; . 用于区分属性和类名
private var <#name#>: UIImageView

Pv.Int/age
// Pv: public var
// `/age` 这里的 `/` 用来标记属性名
public var age: Int
```
* **可选属性**

```Swift
fv.UILabel?
// fv 是属性控制， f 是 fileprivate, v 是 var; ？表示属性是可选的
fileprivate var <#name#>: UILabel?
```
* **有默认值的属性**

```Swift
Pl.UIView{}
// Pl 是属性控制， P 是 public, l 是 let; {} 表示有默认值
// 默认值使用 Class() 来生成
// 如果有默认值，就不会再显示类型，因为 Swift 可以自己推断类型
public let <#name#> = UIView()


Pl.Int{100}
// 如果在 ｛｝ 里面添加默认值，会直接使用此默认值
public let <#name#> = 100
```
* **懒加载属性**

```Swift
lv.UIButton
// lv 是属性控制，lv 是一个特殊的组合,分来时 l 表示 let, v 表示 var; 合并在一起时表示 lazy var
lazy var <#name#>: UIButton = {
    <#code#>
}()
```
* **OC可访问属性**

```Swift
@Pv.UIImageView
// 添加 @ 将把属性标记为 @objc
@objc public var <#name#>: UIImageView
```
* **特殊的属性标识**

```Swift
 wv.EatProtocol?
// 添加 w 将把属性标记为 weak, 除了 w 之外，还有 u/unowned、 c/class 和 s/static
weak var <#name#>: EatProtocol?
```

* **批量生成属性**

```Swift
pl.UILabel{} *2
// *2 中间不能有空格， 一般用于编写数据模型，或是编写 UI 时使用
private let <#name#> = UILabel()
private let <#name#> = UILabel()
```

* **生成block初始化值**

```Swift
plb.UIButton
// 标记 b 表示的是 block 的意思
private let <#name#>: UIButton = {
    <#code#>
}()
```

>  Tips： 如果属性没有写标记，会自动使用  let 来标记属性

```Swift
.UIImageView 

 let <#name#>: UIImageView
```


#### Swift 属性标记快速查询表

| 符号 | 标记 |
| :-: | :-: |
| l | Let |
| v | var |
| lv | lazy var |
| p | private |
| P | public |
| o | open |
| f | fileprivate |
| pl | private let |
| pv | private var |
| plv | private lazy var |
| Pl | public let |
| Pv | public var |
| Plv | public lazy var |
| ol | open let |
| ov | open var |
| olv | open lazy var |
| fl | fileprivate let |
| fv | fileprivate var |
| flv | fileprivate lazy var |
| -- | -- |
| @ | @objc |
| u | unowned |
| w | weak |
| c | class |
| s | static |

| 特殊符号 | 功能 |
| :-: | :-: |
| b | block, 为属性生成block形式的初始化值，类似于 lazy var |



#### Objective-C属性生成
Objective-C 中的使用语法和 Swift 区别不大，主要是关键字和生成的样子不同

* **单个属性**

```Swift
.UIImageView *
// 默认描述就是 nonatomic, strong
@property (nonatomic, strong) UIImageView *<#name#>
```
* **生成完整属性**

```Swift
c.NSString *name;
// 如果在末尾添加 ' ; ' 表示 Class 后面已经衔接了属性名， 为了方便快速编码
@property (nonatomic, copy) NSString *name;
```

> Tips： class 可以用来标记类属性

#### Objective-C 属性标记快速查询表
| 符号 | 标记 |
| :-: | :-: |
| s | strong |
| w | weak |
| a | assign |
| r | readonly |
| g | getter=<#getterName#> |
| c | copy |
| n | nullable |
| N | nonnull |
| c | class |

---

### 生成约束代码
我选取了最常用的两个框架来实现， 在 Objective-C 中使用 Masonry，而在 Swift 当中使用 SnapKit。

#### SnapKit

* **添加布局**

```Swift
 #snpm(iconView, e=self)
 // snpm 就是 makeConstraints， 在 （） 中使用，号来分割各个语句
 // 第一个参数是要添加约束的对象，剩下的都是布局语句
 // 每个语句都分为三个部分，左边是被约束对象的属性，中间是约束方式，
 // 而右边是约束的值或是其它的约束对象
 iconView.snp.makeConstraints {
    $0.edges.equalTo(self)
 }
```
* **更新布局**

```Swift
#snpu(iconView, h=100)
// snpu 是 updateConstraints
iconView.snp.updateConstraints {
    $0.height.equalTo(100)
}
```
* **重置布局**

```Swift
#snprm(iconView, r=self - 20)
// snprm 是 remakeConstraints
iconView.snp.remakeConstraints {
    $0.right.equalTo(self).offset(-20)
}
```

* **布局演示 1 (相对距离)**

```Swift
#snpm(iconView, r=titleLabel.l-20, wh=20)
// 更加直观的使用 + - 来进行相对距离的设置
iconView.snp.makeConstraints {
    $0.right.equalTo(titleLabel.snp.left).offset(-20)
    $0.width.height.equalTo(20)
}
```
* **布局演示 2 (+-的作用)**

```Swift
#snpm(iconView, t=titleLabel.b-superView.height-20, wh=100)
// 在约束语句中，第一个加减号除了有正负的含义，还是分割前后语句的标记
 iconView.snp.makeConstraints {
    $0.top.equalTo(titleLabel.snp.bottom).offset(-superView.height-20)
    $0.width.height.equalTo(100)
}
```
* **布局演示 3 (比例约束)**

```Swift
#snpm(iconView, wh=self/2)
// 进行比例约束也是常用的约束手法
iconView.snp.makeConstraints {
    $0.width.height.equalTo(self).dividedBy(2)
}

// 相同作用 
#snpm(iconView, wh=self*0.5)
// 使用 * 法当然也是可以的
iconView.snp.makeConstraints {
    $0.width.height.equalTo(self).multipliedBy(0.5)
}
```
* **布局演示 4 (比较)**

```Swift
#snpm(titleLabel, tl=self, r<=self - 20)
// 常用的根据文本的长度自适应宽度
// 也可以使用 >= 表示大于等于
 titleLabel.snp.makeConstraints {
    $0.top.left.equalTo(self)
    $0.right.lessThanOrEqualTo(self).offset(-20)
}
```

* **布局演示 4 (约束等级)**

```Swift
#snpm(iconView, l = self, r <= superView~20, r <= titleLabel.l - 20~h)
// 在约束语句的最后使用 ～ 可以用来设置约束登记
// 你可以使用数字来表示约束登记，也可以使用 r\h\m\l 来标记
 iconView.snp.makeConstraints {
    $0.left.equalTo(self)
    $0.right.lessThanOrEqualTo(superView).priority(20)
    $0.right.lessThanOrEqualTo(titleLabel.snp.left).offset(-20).priority(.high)
}
```

#### SnapKit 属性标记快速查询表
* 属性

| 符号 | 属性 |
| --- | --- |
| l | left |
| t | top |
| b | bottom |
| r | right |
| w | width |
| h | height |
| x | centerX |
| y | centerY |
| c | center |
| s | size |
| e | edges |
| **---** | **约束等级** |
| r | .required |
| h | .high |
| m | .medium |
| l | .low |
| **---** | **比较参数** |
| >= | greaterThanOrEqualTo |
| <= | lessThanOrEqualTo |
| = | equalTo |
| **---** | **运算符号** |
| - | Offset(-value) |
| + | Offset(value) |
| * | multipliedBy(value) |
| / | dividedBy(value) |

#### Masonry

主要的用法和 SnapKit 一致， 下面主要说不同点

* **创建、更新、重置**

```Swift
@masm(iconView, e=self)   // 创建
@masu(iconView, e=self)    // 更新
@masrm(iconView, e=self)  // 重置
```
> Tips: 在 OC 中可以使用 @ 作为命令的前缀，主要是 # 在OC文件中会自动变第一列， 影响代码结构

* **约束中没有 r 这个等级了**
* **比较里面新加了 == / >== / <==， 主要是相比少一个 = 的版本，在前面加上了 mas_** 

```Swift
@masm(iconView, e=self)   // 创建
@masu(iconView, e=self)    // 更新
@masrm(iconView, e=self)  // 重置
```

#### AutoLayout(Swift)

主要的用法和 SnapKit/Masonry 一致， 下面主要说不同点

* **使用 #layout 来执行语句**
* **移除了 s(size) / c(center) / e(edges) 的支持， 在以后的版本更新当中会重新添加回来**
* **移除了约束中除法的运算不能再使用 `/`**
* **对于偏移的控制不在简单的使用`+``-`, 如果想要设置常量约束或是偏移使用 `:100` 的形式**

```Swift
@layout(view, l=self:100, t=self:-20, w=self*2, h=:50)
```




### 视图的快速创建

这部分使用 Xcode 的代码块也可以实现，但是写代码的时候，打出了对应的短语后还要看一眼和等待Xcode反应实在是令人着急。我们为的就是快！！！并且我们可以直接赋予视图一个变量名，而代码块还是不行的

通过 **#make** 命令我们可以快速的添加创建一个 View 的代码

**这是目前支持的创建类型**

* UIView
* UILabel
* UIButton
* UIImageView
* UITableView
* UICollectionView
* 

* **普通创建 UIImageView**

```Swift
#make(UIImageView)
// 生成 Swift 视图
let <#name#>  = UIImageView()
<#name#>.backgroundColor = <#color#>
<#name#>.image = <#image#>
<#superView#>.addSubview(<#name#>)
// 生成 OC 视图
UIImageView *<#name#> = [[UIImageView alloc] init];
self.<#name#> = <#name#>;
<#name#>.backgroundColor = <#color#>;
<#name#>.image = <#image#>;
[<#superView#> addSubview: <#name#>];
```

* **设置属性名创建 UILabel**

```Swift
@make(UILabel, titleLabel)
// 生成 Swift 视图
let titleLabel = UILabel()
titleLabel.font = <#font#>
titleLabel.textColor = <#color#>
titleLabel.text = <#text#>
titleLabel.backgroundColor = <#color#>
<#superView#>.addSubview(titleLabel)
// 生成 OC 视图
UILabel *titleLabel = [[UILabel alloc] init];
self.titleLabel = titleLabel;
titleLabel.font = <#font#>;
titleLabel.textColor = <#color#>;
titleLabel.text = <#text#>;
titleLabel.backgroundColor = <#color#>;
[<#superView#> addSubview:titleLabel];
```

### 创建方法
#### Swift
* **创建方法**

>`#func` 可以使用 `#f` 缩写

``` Swift
#func(eat)
// 生成一个简单的方法
func eat() {
    <#code#>
}
```
* **设定权限的方法**

``` Swift
#func(@p.run)
// 标记和属性一样
@objc private func run() {
    <#code#>
}
```

* **有参数的方法**

``` Swift
#func(run::)
// 一个 ： 代表有一个参数
func run(<#name#>: <#type#>, <#name#>: <#type#>) {
    <#code#>
}
```
* **有返回值的方法**

``` Swift
#func(run>)
// 一个 > 代表有一个返回值
func run() -> <#return#> {
    <#code#>
}
// 多个返回值会返回元组
#func(run>>)
func run() -> (<#return#>, <#return#>) {
    <#code#>
}
```
#### Objective-C
* **创建方法**

``` Swift
#func(run)
// 生成一个简单的方法
- (void)run {
    <#code#>
}
```
* **有返回值的方法**

``` Swift
#func(run>)
// 一个 > 代表有一个返回值
- (<#type#>)run {
    <#code#>
}
```
* **有参数的方法**

``` Swift
#func(run::)
// 一个 ： 代表有一个参数
- (void)run:(<#type#>)<#param0#> <#name1#>:(<#type#>)<#param1#> {
    <#code#>
}
```

### 通用语法功能
* **批量处理：** 以上所有的命令都可以通过后接 ***n** 进行批量的生成
* **多命令执行：** 你可以通过 **+** 连续的编写多句命令一块生成 

> **希望大家提出宝贵的意见和建议, 你可以提出 issue 或是发邮件到 caishilin@yahoo.com**

#End

