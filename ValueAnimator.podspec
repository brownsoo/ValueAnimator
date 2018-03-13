#
# Be sure to run `pod lib lint ValueAnimator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ValueAnimator'
  s.version          = '0.1.0'
  s.summary          = 'ValueAnimator makes we can get updates of value transition.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ValueAnimator makes value trainsition using various tween functions.
                       DESC

  s.homepage         = 'https://github.com/brownsoo/ValueAnimator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brownsoo' => 'hyonsoo.han@tlx.co.kr' }
  s.source           = { :git => 'https://github.com/brownsoo/ValueAnimator.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/hansoolabs'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ValueAnimator/Classes/**/*'

end
