#
# Be sure to run `pod lib lint CTCamera.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CTCamera"
  s.version          = "0.1.1"
  s.summary          = "自定义相机 custom camera mosaic"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                            自定义相机，模仿微信。
                            可使用简单的涂抹功能。
                            支持保存到相册。
                       DESC

  s.homepage         = "https://github.com/Mikora/CustomCamera"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "root" => "632300630@qq.com" }
  s.source           = { :git => "https://github.com/Mikora/CustomCamera.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  
  
#  s.public_header_files = 'Pod/Classes/**/*.h'
#  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'CTCamera' => ['Pod/Assets/resources/cameraicon/*.png','Pod/Assets/localizations/**','Pod/Assets/resources/filter/*.png']
  }
   
   s.public_header_files = 'Pod/Classes/*.h'
   s.source_files = 'Pod/Classes/*.{h,m}'
   
   s.subspec 'categories' do |ss|
       ss.public_header_files = 'Pod/Classes/categories/**/*.h'
       ss.source_files = 'Pod/Classes/categories/**/*'
        end
   
   s.subspec 'configuration' do |ss|
       ss.public_header_files = 'Pod/Classes/configuration/**/*.h'
       ss.source_files = 'Pod/Classes/configuration/**/*'
       end
   
   s.subspec 'delegate' do |ss|
       ss.public_header_files = 'Pod/Classes/delegate/**/*.h'
       ss.source_files = 'Pod/Classes/delegate/**/*'
       end
   s.subspec 'managers' do |ss|
       ss.public_header_files = 'Pod/Classes/managers/**/*.h'
       ss.source_files = 'Pod/Classes/managers/**/*'
       ss.frameworks = 'AVFoundation','CoreMotion','UIKit','Foundation'
       end
   s.subspec 'views' do |ss|
       ss.dependency 'CTCamera/categories'
       ss.dependency 'CTCamera/configuration'
       ss.dependency 'CTCamera/delegate'
       ss.dependency 'CTCamera/managers'
       ss.frameworks = 'AVFoundation','CoreGraphics','CoreImage','UIKit','Foundation'
       ss.public_header_files = 'Pod/Classes/views/**/*.h'
       ss.source_files = 'Pod/Classes/views/**/*'
       end
   
   s.subspec 'controller' do |ss|
       ss.dependency 'CTCamera/views'
       ss.frameworks = 'AVFoundation','CoreGraphics','CoreImage','UIKit','Foundation'
       ss.public_header_files = 'Pod/Classes/controller/**/*.h'
       ss.source_files = 'Pod/Classes/controller/**/*'
   end
   s.frameworks = 'UIKit', 'MapKit', 'AVFoundation','CoreMotion','CoreGraphics','CoreImage'
end
