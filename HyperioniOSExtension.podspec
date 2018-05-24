#
#  Be sure to run `pod spec lint HyperioniOSExtension.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name                      = 'HyperioniOSExtension'
    s.version                   = '1.1.0'
    s.summary                   = <<-DESC
    Use HyperioniOSExtension have: 
    environment selector(HyperioniOSExtension/EnvironmentSelector[-Plugin]),
    fps monitor(HyperioniOSExtension/FPSMonitor[-Plugin]), 
    UI operation main thread check(HyperioniOSExtension/UIMainThreadChecker[-Plugin])'
                                    DESC
    s.description               = <<-DESC
    pod 'HyperioniOSExtension/HYPEnvironmentSelector[-Plugin]',  :configurations => ['Debug']
    pod 'HyperioniOSExtension/HYPFPSMonitor[-Plugin]',           :configurations => ['Debug']
    pod 'HyperioniOSExtension/HYPUIMainThreadChecker[-Plugin]',  :configurations => ['Debug']
    github : https://github.com/ToBeDefined/HyperioniOSExtension
                                    DESC

    s.homepage                      = 'https://github.com/ToBeDefined/HyperioniOSExtension'
    s.license                       = { :type => 'MIT', :file => 'LICENSE' }
    s.author                        = { 'ToBeDefined' => 'weinanshao@163.com' }
    s.social_media_url              = 'http://tbd.ink/'
    s.source                        = { :git => 'https://github.com/ToBeDefined/HyperioniOSExtension.git', :tag => s.version}
    s.frameworks                    = 'Foundation', 'UIKit'
    s.requires_arc                  = true
    s.platform                      = :ios
    s.ios.deployment_target         = '9.0'
    s.exclude_files                 = '**/*.md', '**/LICENSE'

    s.subspec 'EnvironmentSelector' do |ss|
        ss.source_files             = 'HYPEnvironmentSelector/NoHyperCore/**/*.{h,m}'
        ss.public_header_files      = 'HYPEnvironmentSelector/NoHyperCore/**/*.h'
        ss.ios.deployment_target    = '7.0'
    end

    s.subspec 'EnvironmentSelector-Plugin' do |ss|
        ss.dependency 'HyperioniOS/Core', '~> 1.0'
        ss.dependency 'HyperioniOSExtension/EnvironmentSelector'

        ss.source_files             = 'HYPEnvironmentSelector/Plugin/**/*.{h,m}'
        ss.public_header_files      = 'HYPEnvironmentSelector/Plugin/**/*.h'
        ss.resources                = 'HYPEnvironmentSelector/Plugin/**/*.png'
    end

    s.subspec 'FPSMonitor' do |ss|
        ss.source_files             = 'HYPFPSMonitor/NoHyperCore/**/*.{h,m}'
        ss.public_header_files      = 'HYPFPSMonitor/NoHyperCore/**/*.h'
        ss.ios.deployment_target    = '6.0'
    end

    s.subspec 'FPSMonitor-Plugin' do |ss|
        ss.dependency 'HyperioniOS/Core', '~> 1.0'
        ss.dependency 'HyperioniOSExtension/FPSMonitor'

        ss.source_files             = 'HYPFPSMonitor/Plugin/**/*.{h,m}'
        ss.public_header_files      = 'HYPFPSMonitor/Plugin/**/*.h'
        ss.resources                = 'HYPFPSMonitor/Plugin/**/*.png'
    end

    s.subspec 'UIMainThreadChecker' do |ss|
        ss.source_files             = 'HYPUIMainThreadChecker/NoHyperCore/**/*.{h,m}'
        ss.public_header_files      = 'HYPUIMainThreadChecker/NoHyperCore/**/*.h'
        ss.ios.deployment_target    = '5.0'
    end


    s.subspec 'UIMainThreadChecker-Plugin' do |ss|
        ss.dependency 'HyperioniOS/Core', '~> 1.0'
        ss.dependency 'HyperioniOSExtension/UIMainThreadChecker'
        
        ss.source_files             = 'HYPUIMainThreadChecker/Plugin/**/*.{h,m}'
        ss.public_header_files      = 'HYPUIMainThreadChecker/Plugin/**/*.h'
        ss.resources                = 'HYPUIMainThreadChecker/Plugin/**/*.png'
    end
end

