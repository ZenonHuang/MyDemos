require 'xcodeproj'
require 'pathname'

# 如果是内部企业构建，加上自定义宏去区分
def add_channelPreprocess(channel , schema)

    dy_distribute_configuration = $dy_target.build_configurations.detect { |config|
        config.name == schema
    }

    if channel.length <= 0
        puts "[dy_build_checker] ignore channel" 
        return;
    end
        
    dy_distrubute_preprocessor = dy_distribute_configuration.build_settings["GCC_PREPROCESSOR_DEFINITIONS"]
    
    internal_version_found = false
    internal_version_macro = channel + "=1"
    
    dy_distrubute_preprocessor.each do |preprocessor|
        
        if preprocessor == internal_version_macro
            internal_version_found = true
        end
    end
    
    if internal_version_found == false
        dy_distrubute_preprocessor.push(internal_version_macro)
    end
    
    if $dy_is_jekins
       $dy_project.save 
       #构建机构建才调save，防止本地Pod update之后没有修改，工程文件也会变更
       puts "[dy_build_checker]save"
    end

    puts "[dy_build_checker]dy_distrubute_preprocessor:" + dy_distrubute_preprocessor.join(",")

end