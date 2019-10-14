Pod::Spec.new do |s|
    s.name         = "AMClockView"
    s.version      = "2.1.0"
    s.summary      = "AMClockView is a view can select time."
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage     = "https://github.com/adventam10/AMClockView"
    s.author       = { "am10" => "adventam10@gmail.com" }
    s.source       = { :git => "https://github.com/adventam10/AMClockView.git", :tag => "#{s.version}" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.source_files = 'Source/*.{swift}'
    s.swift_version = "5.0"
end
