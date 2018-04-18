
platform :ios, "9.0"

use_frameworks!
inhibit_all_warnings!

# 手动控制，手动控制打包是否导入
is_debug = true

project = Xcodeproj::Project.open('HyperioniOSExtension.xcodeproj')
project.targets.each do |t|
    target t do
        if is_debug
            pod 'HyperioniOS/Core'
        end
    end
end

