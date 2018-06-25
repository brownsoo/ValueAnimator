Pod::Spec.new do |s|
  s.name             = "ValueAnimator"
  s.version          = "0.2.0"
  s.summary          = "Value Animation in Swift"
  s.description      = <<-DESC
                        ValueAnimator makes value transition in specific duration with various easing utils.
                        DESC
  s.homepage         = "https://github.com/brownsoo/ValueAnimator"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = { "brownsoo" => "hansune@me.com" }
  #s.documentation_url = "http://brownsoo.github.io/ValueAnimator/"
  s.social_media_url = "http://twitter.com/hansoolabs"
  s.source           = { :git => "https://github.com/brownsoo/ValueAnimator.git", :tag => s.version.to_s }
  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.10'
  s.tvos.deployment_target    = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = true
  s.source_files     = 'ValueAnimator/**/*.swift'
end
