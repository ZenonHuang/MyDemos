require 'xcodeproj'
require 'pathname'

$dy_project = Xcodeproj::Project.open("xx.xcodeproj")

$dy_target = $dy_project.native_targets.detect { |target|
    target.name == "Xx"
}

dy_distribute_configuration = $dy_target.build_configurations.detect { |config|
	# 可以是 release /debug 等其它环境名称
    config.name == "Snapshot"
}

#设置bundleID,profile
bundle_ID = "some bundle_ID you need";
profile_name = "your profile name ";

#获得build settings
build_settings = dy_distribute_configuration.build_settings
build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = bundle_ID
build_settings["PROVISIONING_PROFILE_SPECIFIER"] = profile_name

$dy_project.save


