#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Paper"
  s.version          = "0.0.1"
  s.summary          = "An iOS UI components library for Material Design"
  s.description      = <<-DESC
                       An iOS UI components library for Material Design (http://www.google.com/design/spec/material-design/introduction.html)

                       * PaperActionSheet (http://www.google.com/design/spec/components/bottom-sheets.html)
                       * PaperButton (http://www.google.com/design/spec/components/buttons.html)
                       * PaperCard (http://www.google.com/design/spec/components/cards.html)
                       * PaperChip (http://www.google.com/design/spec/components/chips-tokens.html)
                       * PaperDialog (http://www.google.com/design/spec/components/dialogs.html)
                       * PaperToolbar
                       * PaperHeaderPanel
                       
                       DESC
  s.homepage         = "https://github.com/Inspirify/Paper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Tom Li" => "nklizhe@gmail.com" }
  s.source           = { :git => "https://github.com/Inspirify/Paper.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nklizhe'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  # s.resources = 'Pod/Assets/*.png'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency "UIKit+Material", '~> 0.1.1'
  s.dependency "PureLayout", '~> 1.0.1'
end
