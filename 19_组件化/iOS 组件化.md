# 需求背景

> 由于在线教育行业受到国家监管，政策变化使得公司业务有些许转变；未来会在更多的赛道做出尝试。为了快速在新的赛道拿到认知，对于研发的效率提出了很大的挑战：需要在短时间内，研发出质量过硬的商业化产品。所以需要在以往项目中沉淀出稳定、易用、可拓展的基础组件作为新产品研发的有力支撑。

> 为了进一步提高研发效率，组件的维护、测试、集成、部署等还需要较为完善的工具链作为辅助。

> 组件化同时也是移动端持续交付中的依赖管理模块。

> 【引用】[__iOS 组件化技术选型__](https://thoughts.teambition.com/workspaces/5e97c34d3d91f8001ad49f07/docs/610a673012d5ba0001c2b88d)



# 需求分析

## 组件集成

- 快速集成组件，简单易用，无需手动集成

- 组件统一查询入口

- 支持二进制产物，提升编译速度

- 便捷的组件管理，且支持版本控制，依赖管理

- 屏蔽第三方库带来的不可控因素：下载速度，稳定性等

- 支持对不同target，不同环境进行组件差异化配置

- 宿主APP可对组件注入环境变量



## 组件研发

- 中心化管理

- 支持源码调试

- 可对宿主APP注入环境变量

- 快速创建组件库，组件模版

- 支持依赖其他组件

- 支持组件版本控制，区分渠道

- 支持快速发布，自动生成构建产物



# CocoaPods

## 简介

> CocoaPods 是 Swift 和 Objective-C Cocoa 项目的依赖管理器。它拥有超过 85,000 个库，并在超过 300 万个应用程序中使用。CocoaPods 可以帮助您优雅地扩展您的项目。



**Podfile**

> Podfile 是一个文件，以 DSL（其实直接用了 Ruby 的语法）来描述依赖关系，用于定义项目所需要使用的第三方库。该文件支持高度定制，你可以根据个人喜好对其做出定制。

**Podfile.lock**

> 这是 CocoaPods 创建的最重要的文件之一。它记录了需要被安装的 Pod 的每个已安装的版本。如果你想知道已安装的 Pod 是哪个版本，可以查看这个文件。

**Manifest.lock**

> 这是每次运行 `pod install` 命令时创建的 Podfile.lock 文件的副本。如果你遇见过这样的错误 沙盒文件与 Podfile.lock 文件不同步 (The sandbox is not in sync with the Podfile.lock)，这是因为 Manifest.lock 文件和 Podfile.lock 文件不一致所引起。

**Master Specs Repo**

> 作为包管理工具，CocoaPods 的目标是为我们提供一个更加集中的生态系统，来提高依赖库的可发现性和参与度。本质上是为了提供更好的检索和查询功能。



## Ruby生态

> 其实 CocoaPods 的思想借鉴了其他语言的 PM 工具，例：RubyGems, Bundler, npm,Gradle。我们知道 CocoaPods 是通过 Ruby 语言实现的，它本身就是一个 Gem 包。



**RVM&rbenv**

> 都是管理多个 Ruby 环境的工具，它们都能提供不同版本的 Ruby 环境管理和切换。

**RubyGems**

> RubyGems 是 Ruby 的一个包管理工具，这里面管理着用 Ruby 编写的工具或依赖我们称之为 Gem。

> 并且 RubyGems 还提供了 Ruby 组件的托管服务，可以集中式的查找和安装 library 和 apps。当我们使用 `gem install xxx` 时，会通过 rubygems.org 来查询对应的 Gem Package。

> 而 iOS 日常中的很多工具都是 Gem 提供的，例：Bundler，fastlane，jazzy，CocoaPods 等。

**Bundler**

> Bundler 是管理 Gem 依赖的工具，可以隔离不同项目中 Gem 的版本和依赖环境的差异，也是一个 Gem。

> Bundler 通过读取项目中的依赖描述文件 Gemfile ，来确定各个 Gems 的版本号或者范围，来提供了稳定的应用环境。当我们使用 `bundle install` 它会生成 Gemfile.lock 将当前 librarys 使用的具体版本号写入其中。之后，他人再通过 `bundle install` 来安装 libaray 时则会读取 Gemfile.lock 中的 librarys、版本信息等。



## 核心组件

- 



## 原理

**Pod Install**

> 整个 Pod Install 流程最核心的就是 `::Pod::Installer` 类，Pod Install 命令会初始化并配置 Installer，然后执行 install! 流程，install! 流程

```ruby
def install!
  prepare                   # 1.准备
  resolve_dependencies      # 2.依赖决议
  download_dependencies     # 3.依赖下载
  validate_targets          # 4.Pods 校验
  generate_pods_project     # 5.Pods Project 生成
  if installation_options.integrate_targets?
    integrate_user_project  # 6.User Project 整合
  else
    UI.section 'Skipping User Project Integration'
  end
  perform_post_install_actions # 收尾
end

```

**Prepare**

- 确保 `pod install`在沙盒外执行

- 如果 pods 版本有变更，则解除之前对 User Project 的整合

- 如果沙盒目录不存在，则创建

- 确保 pods 插件已安装

- 执行插件



# 架构设计

## 代码管理

- 创建公司级仓库 Spec Repo：存放组件 spec

- 创建组件二进制 Spec Repo：存放二进制的 spec

- 创建公司级组件 group：组件列表

- 创建cocoapods插件仓库：管理cocoapods插件

- 创建cocoapods模版仓库

- 组件采用单仓多组件形式：每个组件仓库中包含源码组件和二进制组件



## 环境搭建

- 提供 cocoapods 自动化环境搭建插件：homebrew+rbenv+RubyGems+Bundler+CocoaPods



## 模版生成

- 提供组件模版生成CLI

- 提供项目工程模版以及CLI



## 发布&构建

- 提供快速发布CLI

- 自动构建二进制产物：debug/release



## 组件集成

- 支持源码/二进制切换插件

- 支持oc/swift混编

- 多 target 差异化处理，xcconfig，虚拟target

- 支持双向环境变量注入



# 架构实现

## 代码管理

- CocoaPods插件库：[CPPlugins](https://git.corp.hetao101.com/app/CPPlugins)

- pod 模版仓库：[CocoaPods-template](https://git.corp.hetao101.com/app/CocoaPods-template)

- 创建组件 group，组件查询的统一入口：[Component-iOS](https://git.corp.hetao101.com/app/component-ios)

- 组件源码 specs 仓库：[Source-specs](https://git.corp.hetao101.com/app/source-specs)



## 环境搭建

- cocoapods 工具链搭建脚本 `cocoapodsEnv.sh` 

    - 无参数执行脚本，在执行命令的文件夹中搭建 ruby+cocoapods 环境

    - 把文件夹路径作为参数，可以指定环境搭建路径

    - 提供 `-h` 选项，查看帮助

    - 提供 `-u` 选选，更新 alias shell 命令

```shell
#!/bin/sh
# version: 1.0.1
#
# Ruby+Gems+CocoaPods 环境搭建
#
# "Usage: iOSpackage.sh [<option>] [<arg>]"
# " [<path>]    path to configurate environment, default is current directory"
# "	-u 			update shell command alias"
# "	-h 			show this message"
#
#


#-----------global env-------------

# ruby 版本号
ruby_version=3.0.2

# cocoapods 版本号
pod_version=1.10.2

# 指定路径安装gems
gemfile_path=$(pwd)/Gemfile

# 入参
arg=$1

#-----------function-------------

# 检测工具是否安装
toolIsInstalled()
{
	local cmd="$1 --version"
	# 工具已安装
	if $cmd > /dev/null
	then
		echo "======$1 工具已安装======"
		return 0
	# 工具未安装
	else
		return 1
	fi
}

# homebrew是否需要安装
homebrewIfNeedInstall() 
{
	if !(toolIsInstalled brew); then
		# 开始安装tool
		echo "======开始安装 Homebrew======"
		eval $1

		# 安装结果查询
		if !(toolIsInstalled brew)
		then
			exit "======安装 Homebrew 失败，请手动安装 Homebrew======"
		fi
	fi
}

# rbenv是否需要安装
rbenvIfNeedInstall() 
{
	if !(toolIsInstalled rbenv); then
		# 开始安装tool
		echo "======开始安装 rbenv======"
		$2
		$1
		
		# 安装结果查询
		if !(toolIsInstalled brew); then
			exit "======安装 rbenv 失败，请手动安装 rbenv======"
		fi

		# 添加 pod 别名
		deleteOriginPodAlias
		addPodAlias

		return 1
	else
		return 0
	fi
}

# ruby是否正确安装
rubyIsInstalled()
{
	# 获取本地ruby版本号
	local version=$(ruby --version)
	version=${version:5:5}
	
	# 校验版本号
	if [ "${ruby_version}" = "${version}" ]; then
		return 0
	else
		return 1
	fi
}

# ruby是否需要安装
rubyIfNeedInstall()
{
	if !(rubyIsInstalled); then
		local ruby_path=~/.rbenv/versions/${ruby_version}
		if [ ! -d "${ruby_path}" ]; then
			echo "======开始安装 ruby ${ruby_version}======"
			$1

			if [ ! -d "${ruby_path}" ]; then
				exit "======安装 ruby ${ruby_version} 失败，请手动安装======"
			fi
		fi
		
		# 切换ruby环境
		$2
	fi	
}

# bundler是否需要安装
bundlerIfNeedInstall() 
{
	if !(toolIsInstalled bundle); then
		# 开始安装tool
		echo "======开始安装 Bundler======"
		$1

		# 安装结果查询
		if !(toolIsInstalled bundle)
		then
			exit "======安装 Bundler 失败，请手动安装 Bundler======"
		fi
	fi
}

# 安装gems
bundleInstall()
{
	# 创建Gemfile
	if [ ! -f "${gemfile_path}" ]; then
		$1

		if [ -f "${gemfile_path}" ]; then
			echo "gem 'cocoapods', '${pod_version}'" >> "${gemfile_path}"
			echo "gem 'cocoapods-release', :git => 'https://git.corp.hetao101.com/app/CPPlugins.git'" >> "${gemfile_path}"
		else
			exit "======创建 Gemfile 失败，请手动创建 Gemfile======"
		fi

		# 安装gems
		$2

	# 更新gems
	else
		$3
	fi
}

# 添加 pod 别名
addPodAlias()
{
	echo "alias bpod=\"bundle exec pod\"" >> ~/.zshrc
	echo "alias pod_lib_create='_a(){ pod lib create \$1 --template-url=https://git.corp.hetao101.com/app/CocoaPods-template.git; }; _a'" >> ~/.zshrc
}

deleteOriginPodAlias()
{
	sed -i "" "s/^alias bpod.*//g" ~/.zshrc
	sed -i "" "s/^alias pod_lib_create.*//g" ~/.zshrc
}

# 开启新窗口
newCmdWindow()
{
	osascript -e 'tell app "Terminal"
    	do script "cd '$1';echo \"======cocoapods 环境构建完成======\""
	end tell'
}

# 关闭原窗口
closeLastWindow()
{
	osascript -e 'tell application "Terminal" to close second window' & exit
}


#-----------excution-------------

# 环境搭建
configurateEnv()
{
	echo "======配置 ruby version=${ruby_version}======"
	echo "======配置 cocoapods version=${pod_version}======"
	echo "======配置 gemfile path=${gemfile_path}======"

	echo "======ruby 工具链搭建开始======"
	homebrewIfNeedInstall "/bin/zsh -c \"\$(curl -fsSL https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh)\""
	local rbenvInstalled=$(rbenvIfNeedInstall "brew install rbenv" "brew update")
	rubyIfNeedInstall "rbenv install ${ruby_version}" "rbenv local ${ruby_version}"
	echo "======ruby 环境搭建完成======"

	echo "======cocoapods 环境搭建开始======"
	bundlerIfNeedInstall "gem install bundler"
	bundleInstall "bundle init" "bundle install" "bundle update cocoapods"
	echo "======cocoapods 环境搭建完成======"

	if [ ! rbenvInstalled ]; then
		echo "======cocoapods 指令添加开始======"
		local shell_path=$(pwd)
		newCmdWindow "${shell_path}"
		closeLastWindow
	fi
}

main()
{
	# 当前目录，配置cocoapods环境
	if [ ! -n "${arg}" ]; then
	    configurateEnv

	# help
	elif [ "${arg}" == "-h" ]; then
		echo "Usage: iOSpackage.sh [<option>] [<arg>]"
		echo "	[<path>]		path to configurate environment, default is current directory"
		echo "	-u 			update shell command alias"
		echo "	-h 			show this message"

	# 更新 alias 命令
	elif [ "${arg}" == "-u" ]; then
		deleteOriginPodAlias
		addPodAlias
		local shell_path=$(pwd)
		newCmdWindow "${shell_path}"
		closeLastWindow
		
	# 指定目录，配置cocoapods环境
	else 
	    gemfile_path=${arg}Gemfile
	    if [ ! -d "${arg}" ]; then
	    	exit "======指定目录不存在，-h 获取更多信息======"
	    fi
	    cd ${arg}
	    configurateEnv
	fi
}

main

```



## 模版生成

- 模版快捷生成命令

```shell
pod_lib_create ProjectName
```



- 统一的模版创建，预置 Podspec  标准设置等；更新模版工程，规范 `Podfile` 编写

- 修改 `TemplateConfigurator.rb` 文件，加入远程 git 库关联；加入ruby + cocoapods 环境搭建；替换 `pod` 命令为 `bpod` 命令

```shell
bpod install # 相当于 bundle exec pod install
```



- 预置 pod 插件安装，提供扩展入口



## 发布&构建

- ~~提供组件构建插件：cocoapods-generate 根据 sepc 生成工程项目，然后利用打包脚本打出动态库；创建/更新动态库的 sepc 文件~~

- 提供组件发布插件：`cocoapods-release` ，发布组件源码

    - 获取本地的公司私有 repo 列表

    - 验证组件 version 在 repo 列表中是否已经存在，如果存在，则发布失败，需更新版本号

    - 执行本地 spec 验证

    - git库打tag并推送远端

    - 发布 pod 版本到公司 repo 

```ruby
# 核心代码
def run
        specs = Dir.entries(".").select { |s| s.end_with? ".podspec" }
        abort "No podspec found" unless specs.count > 0

        specs = specs.reverse if @reverse

        puts "#{"==>".magenta} updating repositories"
        SourcesManager.update

        # verify version
        for spec in specs
          name = spec.gsub(".podspec", "")
          version = Specification.from_file(spec).version
          name = Specification.from_file(spec).name

          sources = SourcesManager.all.select { |r| r.url.include?("git.corp.hetao101.com") }
          sources = sources.select { |s| s.name == @repo } if @repo
          pushed_sources = []
          # available_sources = SourcesManager.all.map { |r| r.name }

          abort "Please run #{"pod install".green} to continue" if sources.count == 0
          for source in sources
            pushed_versions = source.versions(name)
            next unless pushed_versions

            pushed_sources << source
            pushed_versions = pushed_versions.collect { |v| v.to_s }
            abort "#{name} (#{version}) has already been pushed to #{source.name}".red if pushed_versions.include? version.to_s
          end

          repo_unspecified = pushed_sources.count == 0 && sources.count > 1
          if repo_unspecified
            puts "When pushing a new podspec, please specify a repository to push #{name} to:"
            puts ""
            for source in sources
              puts "  * pod release #{source.name}"
            end
            puts ""
            abort
          end

          if pushed_sources.count > 1
            puts "#{name} has already been pushed to #{pushed_sources.join(', ')}. Please specify a repository to push #{name} to:"
            puts ""
            for source in sources
              puts "  * pod release #{source.name}"
            end
            puts ""
            abort
          end
        end

        for spec in specs
          name = spec.gsub(".podspec", "")
          version = Specification.from_file(spec).version
          name = Specification.from_file(spec).name

          sources = SourcesManager.all.select { |r| r.url.include?("git.corp.hetao101.com") }
          sources = sources.select { |s| s.name == @repo } if @repo
          pushed_sources = []

          for source in sources
            pushed_versions = source.versions(name)
            next unless pushed_versions

            pushed_sources << source
            pushed_versions = pushed_versions.collect { |v| v.to_s }
          end

          # verify lib
          # execute "pod lib lint #{spec} #{@allow_warnings} --sources=#{available_sources.join(',')}"
          execute "pod lib lint #{spec} --use-libraries #{@allow_warnings} --sources=#{pushed_sources.join(',')}"

          # if @carthage
          #   execute "carthage build --no-skip-current"
          # end

          # TODO: create git tag for current version
          unless system("git tag | grep #{version} > /dev/null")
            # execute "git add -A && git commit -m \"Releases #{version}.\"", :optional => true
            execute "git tag #{version}"
            execute "git push --tags" #"git push && git push --tags"
          end
            
          repo = sources.first.name
          repo = @repo || pushed_sources.first.name if pushed_sources.first
          # if repo == "master"
          #   execute "pod trunk push #{spec} #{@allow_warnings}"
          # else
            execute "pod repo push #{repo} #{spec} #{@allow_warnings}"
          # end

          # if @carthage && `git remote show origin`.include?("github.com")
          #   execute "carthage archive #{name}"

          #   user, repo = /(\w*)\/(\w*).git$/.match(`git remote show origin`)[1, 2]
          #   file = "#{name}.framework.zip"

          #   create_release = %(github-release release --user #{user} --repo #{repo} --tag #{version} --name "Version #{version}" --description "Release of version #{version}")
          #   upload_release = %(github-release upload --user #{user} --repo #{repo} --tag #{version} --name "#{file}" --file "#{file}")

          #   if ENV['GITHUB_TOKEN'] && system("which github-release")
          #     execute create_release
          #     execute upload_release
          #     execute "rm #{file}"
          #   else
          #     puts "Run `#{create_release} --security-token XXX` to create a github release and"
          #     puts "    `#{upload_release} --security-token XXX` to upload to github releases"
          #   end
          # end
        end
      end

```



## 组件集成

- 



# 时间计划





# 落地效果





# 局限&规划

## 局限



## 规划





# 参考文档

> [__iOS 基于 Cocoapods 插件进行组件二进制的探索__](https://juejin.cn/post/6882212750513307655#heading-11)

> [__CocoaPods guide__](https://guides.cocoapods.org/contributing/contribute-to-cocoapods.html)

> [__整体把握 CocoaPods 核心组件__](https://juejin.cn/post/6861792671489327111)

