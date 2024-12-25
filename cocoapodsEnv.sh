#!/bin/sh
# version: 1.0.3
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

		# 启动rbenv
		echo "eval \"\$(rbenv init -)\"" >> ~/.zshrc

		# 添加 pod 别名
		deleteOriginPodAlias
		addPodAlias

		return 1
	else
		# 更新 rbenv 库的版本号
		brew upgrade ruby-build
		
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

