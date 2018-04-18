#
#  Be sure to run `pod spec lint HyperioniOSExtension.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name                      = 'HyperioniOSExtension'
    s.version                   = '1.0.0'
    s.summary                   = <<-DESC
    Use HyperioniOSExtension have:
    environment selector(HyperioniOSExtension/HYPEnvironmentSelector)
    fps monitor(HyperioniOSExtension/HYPFPSMonitor)
    ui operation main thread check(HyperioniOSExtension/HYPUIMainThreadChecker)
                                    DESC
    s.description               = <<-DESC
    pod 'HyperioniOSExtension/HYPEnvironmentSelector',  :configurations => ['Debug']
    pod 'HyperioniOSExtension/HYPFPSMonitor',           :configurations => ['Debug']
    pod 'HyperioniOSExtension/HYPUIMainThreadChecker',  :configurations => ['Debug']
    github : https://github.com/ToBeDefined/HyperioniOSExtension
                                    DESC
    s.homepage                  = 'https://github.com/ToBeDefined/HyperioniOSExtension'
    s.license                   = { :type => 'MIT', :file => 'LICENSE' }
    s.author                    = { 'ToBeDefined' => 'weinanshao@163.com' }
    s.social_media_url          = 'http://tbd.ink/'
    s.source                    = { :git => 'https://github.com/ToBeDefined/HyperioniOSExtension.git', :tag => s.version}
    s.frameworks                = 'Foundation', 'UIKit'
    s.requires_arc              = true
    s.ios.deployment_target     = '9.0'

    s.subspec 'HYPEnvironmentSelector' do |ss|
        ss.dependency 'HyperioniOS/Core', '~> 1.0'
        ss.source_files         = 'HYPEnvironmentSelector/**/*.{h,m}'
        ss.public_header_files  = 'HYPEnvironmentSelector/**/*.h'
        ss.exclude_files        = '**/*.md'
        ss.resources            = 'HYPEnvironmentSelector/**/*.png', 'HYPEnvironmentSelector/**/*.xib', 'HYPEnvironmentSelector/**/*.plist'
    end

    s.subspec 'HYPFPSMonitor' do |ss|
        ss.dependency 'HyperioniOS/Core', '~> 1.0'
        ss.source_files         = 'HYPFPSMonitor/**/*.{h,m}'
        ss.public_header_files  = 'HYPFPSMonitor/**/*.h'
        ss.exclude_files        = '**/*.md'
        ss.resources            = 'HYPFPSMonitor/**/*.png', 'HYPFPSMonitor/**/*.xib', 'HYPFPSMonitor/**/*.plist'
    end

    s.subspec 'HYPUIMainThreadChecker' do |ss|
        ss.dependency 'HyperioniOS/Core', '~> 1.0'
        ss.source_files         = 'HYPUIMainThreadChecker/**/*.{h,m}'
        ss.public_header_files  = 'HYPUIMainThreadChecker/**/*.h'
        ss.exclude_files        = '**/*.md'
        ss.resources            = 'HYPUIMainThreadChecker/**/*.png', 'HYPUIMainThreadChecker/**/*.xib', 'HYPUIMainThreadChecker/**/*.plist'
    end
end

