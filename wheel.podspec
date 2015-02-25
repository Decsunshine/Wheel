Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "wheel"
  s.version      = "1.4"
  s.summary      = "wheel SDK."

  s.description  = <<-DESC
                   A longer description of wheel in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/Decsunshine/Wheel"
  s.requires_arc = true

  s.license      = "All rights reserved"
  s.author       = { "hongliang lu" => "honglianglu1124@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Decsunshine/Wheel.git", :tag => "v0.1" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"

  s.dependency "AFNetworking", "~> 2.0" 
  s.dependency 'Masonry', '~> 0.5.2'
  s.requires_arc = true

end

