# 一、背景

## 1.业务现状

- 目前公司移动端产品有多个，且移动端未来还会承载更多的产品

- iOS侧基本实现模块化，研发新产品时，还会使用复制粘贴其他项目代码的方式，以及拖拽其他framework的形式来提高研发效率

- 多数是模块纬度的拆分

- 多数模块复用后，优化以及bug修复无法及时同步到各产品中

- 目前没有统一的入口来查询可以快速接入的模块或组件，主要靠询问才能得知

- 被复用的模块无法统一维护，维护成本成数倍增加



## 2.需求背景

- 由于在线教育行业受到国家监管，政策变化使得公司业务有些许转变；未来会在更多的赛道做出尝试。为了快速在新的赛道拿到认知，对于研发的效率提出了很大的挑战：需要在短时间内，研发出质量过硬的商业化产品。所以需要在以往项目中沉淀出稳定、易用、可拓展的基础组件作为新产品研发的有力支撑。

- 为了进一步提高研发效率，组件的维护、测试、集成、部署等还需要较为完善的工具链作为辅助。



# 二、意义

## 1.开发视角

- 提高业务开发效率，减少重复造轮子

- 降低组件维护成本，不同业务线的相同组件，可以统一维护优化

- 方便研发查询，组件统一管理

- 减少不可控因素，如第三方库更新导致的崩溃

- 提高稳定性，将模块细分为组件，进一步解耦业务，模块复杂度相对减少

- 降低业务开发的维护成本



## 2.产研视角

- 快速拿到新赛道的认知，快速做出新的决策

- 可以在相同时间内，在更多的赛道做出尝试



# 三、目标

## 1.业务RD

- 快速集成组件，简单易用，无需手动集成

- 组件统一查询入口

- 支持二进制产物，提升编译速度

- 便捷的组件管理，且支持版本控制

- 屏蔽第三方库带来的不可控因素：下载速度，稳定性等

- 支持对不同target，不同环境进行组件差异化配置

- 宿主APP可对组件注入环境变量



## 2.组件RD

- 中心化管理

- 支持源码调试

- 可对宿主APP注入环境变量

- 快速创建组件库，组件模版

- 支持依赖其他组件

- 支持组件版本控制，区分渠道

- 支持快速发布，自动生成构建产物

- 工具链社区成熟度高



# 四、调研结果

|           | 中心化管理            | 源码调试 | 二进制化 | 集成易用性 | 版本控制 | 差异化配置 | 环境配置 | 工具链成熟度 | 发布易用性 | 研发成本 |
| --------- | ---------------- | ---- | ---- | ----- | ---- | ----- | ---- | ------ | ----- | ---- |
| Carthage  | 不支持              | 不支持  | 仅动态库 | 需手动   | 支持   | 不支持   | 不支持  | 一般     | 高     | 一般   |
| CocoaPods | 支持               | 支持   | 支持   | CLI   | 支持   | 灵活    | 支持   | 成熟     | 一般    | 一般   |
| Bazel     | 支持(包括服务端、前端、移动端) | 支持   | 支持   | CLI   | 支持   | 非常灵活  | 支持   | 较少     | 高     | 很高   |



# 五、方案简介

## Carthage

### 1.优势&局限

1.优势

- 将 framework 集成到项目中，clean 后不需要重复编译

- 无缝兼容 CocoaPods

- 结构标准的项目天然支持 Carthage

- 对宿主APP编译配置无侵入

2.局限

- 没有中心仓库，管理成本增加

- 不支持源码调试

- 集成需要手动配置

- 只支持 dynamic frameworks

3.适用场景

- 单业务线，轻量化，集成成本是一次性的，例如：无法复用的业务模块

- 长时间不会改变的库（不多）

- 一般为项目初期



### 2.原理

> 由于 Carthage 没有中心化的 package list，也没有项目说明格式，大部分 frameworks 应该自动构建。通过将编译 scheme 共享，让 Carthage 通过 xcodebuild 编译。通过运行 `carthage build --no-skip-current` 后检查 Build 文件夹来检测是否构建成功。将构建后的 frameworks 拷贝到项目中，并在 "Linked Frameworks and Libraries" 选项中添加依赖。



### 3.使用

1.发布

- 创建 framework 工程文件，选择 "Manager Schemes" 将对应的 project 勾选为 "Shared"

- 使用 `carthage build --no-skip-current` 命令来检测 intended schemes是否能构建成功

- 将该类库 push 到 gitlab，并打一个 tag 作为版本号

2.集成

- 在工程目录下创建 Cartfile 文件，并添加依赖库 `github "Alamofire/Alamofire" ~> 4.7.2`

- 运行 `carthage update`

- 会生成 Cartfile.resolved 和 Carthage 文件夹，其中包括 Build 和 Checkout 文件夹

- 在工程中添加 framework 的依赖

- 在 Build Phases 里新建 New Run Script Phase，输入：`/usr/local/bin/carthage copy-frameworks`

- 在 `Input Files` 项里填入`$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework`

- 在 `Output Files` 项里填入`$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/Alamofire.framework`



## CocoaPods

### 1.优势&局限

1.优势

- 集成方便，无需手动配置

- 支持静态库，动态库

- 支持源码调试

- 工具链生态成熟

- 中心化管理

2.局限

- 会侵入宿主APP的环境配置

- 创建支持 CocoaPods 的相对繁琐， podsepc 写起来比较麻烦

- 每次 clean 之后编译，都要重新编译所有第三方库

3.适用场景

- 多条业务线，可复用组件或核心功能模块的

- 需要统一管理，提升研发效率和质量的



### 2.原理

> CocoaPods 默认自动创建 workspace 来管理 application 和所有依赖，通过从 repo 仓库中查找 .sepc 索引文件来确定组件版本、地址。集成时会按照命令解析、环境准备、依赖解析、组件下载、版本校验、生成工程文件的流程来执行。



### 3.使用

1.发布

- 创建私有的 spec repo

- 使用模版创建组件的Pod `pod lib create NAME`

- 编写 spec 文件：版本信息，源码地址，添加依赖，以及宿主坏境的配置

- 验证 spec 文件 `pod lib lint --allow-warnings`

- 提交代码至 gitlab

- 提交 spec 文件 `pod repo push SpecName x.podspec --allow-warnings`

2.集成

- 编写 Podfile 文件 `pod 'AFNetworking','~>2.5.0'`

- 使用 CLI `Pod install`



## Bazel

### 1.优势&局限

1.优势

- 拥有超强的多平台和多语言兼容性

- 让编译和测试更快更稳定，分布式编译，增量编译

- 更灵活精细的配置粒度，可以在工程子目录中添加build文件

- 可以对外配置文件可见性

- 只打开和编辑需要关注的部分，编译工作由 bazel 完成

2.局限

- 学习成本颇高

- 前提条件严苛：代码可以整合为一个仓库，编译环境统一，工具链统一

- 社区生态不完善

- 落地成本很高

3.适用场景

- 代码体量巨大，组件数量庞大（成百上千）

- 多条业务线编译环境、工具链都已统一



### 2.原理

> bazel 是 google 开源的一套的构建工具，它的愿景就是让编译和测试更快更稳定，拥有超强的多平台和多语言兼容性。通过 build 配置文件，指定编译环境及参数，再由 bazel 通过分布式集群进行编译，且返回构建产物。由于所有以前的构建工作都是缓存的，因此Bazel可以识别并重用缓存，只重建或重新测试更改的内容



### 3.使用

1.发布

- 创建 workspace 工作区

- 更新 workspace git 仓库的规则

- 创建 build 文件，并且设置编译规则

- 提交代码至 gitlab

2.集成

- 使用 CLI `bazel build`



# 六、参考资料

[1] [__Bazel for iOS APP__](https://docs.bazel.build/versions/main/tutorial/ios-app.html)

[2] [__实战！用Bazel来管理iOS程序__](https://zhuanlan.zhihu.com/p/271677780)

[3] [__用 bazel 更快更稳定的构建 iOS 项目__](https://bilibili.github.io/2020/07/22/bazel_ios.html)





