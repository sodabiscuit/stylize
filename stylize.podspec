#
# Be sure to run `pod lib lint stylize.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "stylize"
  s.version          = "0.3.0"
  s.summary          = "a simple layout framework."
  s.description      = <<-DESC
                       An optional longer description of stylize

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/sodabiscuit/stylize"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yulin Ding" => "sodabiscuit@gmail.com" }
  s.source           = { :git => "https://github.com/sodabiscuit/stylize.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/sodabiscuit'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Ono', '~> 1.2.2'
end
