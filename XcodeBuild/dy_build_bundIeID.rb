require 'xcodeproj'
require 'pathname'

#这里代表的是环境，如 debug,release，被当作参数输入进来
$dy_mode = ARGV[0]

## 需要修改名称使用,以及在 yourProject.xcodeproj 同级目录下使用
$dy_project = Xcodeproj::Project.open("xx.xcodeproj")

$dy_target = $dy_project.native_targets.detect { |target|
    target.name == "xx"
}

dy_distribute_configuration = $dy_target.build_configurations.detect { |config|
    config.name == $dy_mode
}

#获得build settings
build_settings = dy_distribute_configuration.build_settings
$dy_mode_bundleID = build_settings["PRODUCT_BUNDLE_IDENTIFIER"]

puts $dy_mode_bundleID
