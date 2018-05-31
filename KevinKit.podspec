#
# Be sure to run `pod lib lint KevinKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KevinKit'
  s.version          = '1'
  s.summary          = 'A short description of KevinKit.'
  s.description      = 'A short description of KevinKit.'

  s.homepage         = 'https://github.com/OuYangJiwen/KevinKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'OuYangJiwen' => '2122774806@qq.com' }
  s.source           = { :git => 'https://github.com/OuYangJiwen/KevinKit.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '8.0'

  s.source_files = 'KevinKit/Classes/**/*'
end
