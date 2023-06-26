#
# Be sure to run `pod lib lint MSNavigationController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSNavigationController'
  s.version          = '0.1.0'
  s.summary          = '全局手势返回导航栏'


  s.homepage         = 'https://github.com/yuanshuainiuniu/MSNavigationController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marshal' => '717999274@qq.com' }
  s.source           = { :git => 'https://github.com/yuanshuainiuniu/MSNavigationController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'MSNavigationController/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MSNavigationController' => ['MSNavigationController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
