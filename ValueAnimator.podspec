Pod::Spec.new do |s|
  s.name             = "ValueAnimator"
  s.version          = "0.6.9"
  s.summary          = "Value Animation Util in Swift"
  s.description      = <<-DESC
                        ValueAnimator makes value transition in specific duration with various easing utils.
                        DESC
  s.homepage         = "https://github.com/brownsoo/ValueAnimator"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "brownsoo" => "hansune@me.com" }
  s.source           = { :git => "https://github.com/brownsoo/ValueAnimator.git", :tag => s.version.to_s }
  s.ios.deployment_target     = '12.0'
  s.osx.deployment_target     = '11.0'
  s.tvos.deployment_target    = '12.0'
 s.watchos.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files     = 'Sources/**/*.swift'
  s.swift_versions = ['4.0', '4.2', '5.0']
end
