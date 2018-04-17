
platform :ios, "9.0"

use_frameworks!
inhibit_all_warnings!

project = Xcodeproj::Project.open('HyperioniOSExtension.xcodeproj')
project.targets.each do |t|
    target t do
        pod 'HyperioniOS/Core'
        pod 'HyperioniOS/AttributesInspector'
        pod 'HyperioniOS/Measurements'
        pod 'HyperioniOS/SlowAnimations'
    end
end

