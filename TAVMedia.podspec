Pod::Spec.new do |spec|

  spec.name         = "TAVMedia"
  spec.version  = '2.0.108'
  spec.summary      = "TAVMedia is a cross-platform engine that defines a media pipeline to efficiently process media samples and manage queues of media data."

  spec.homepage     = "https://github.com/TencentCloud/tavmedia-sdk-ios"
  spec.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  spec.author       = "Tencent TAVGroup"

  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/TencentCloud/tavmedia-sdk-ios.git", :tag => '2.0.108' }

  spec.frameworks = ["UIKit", "CoreFoundation", "QuartzCore", "CoreGraphics", "CoreText", "OpenGLES",
                      "VideoToolbox", "CoreMedia", "JavaScriptCore", "AVFoundation", "CoreML",
                      "MetalPerformanceShaders", "Accelerate", "Metal", "AssetsLibrary", "CoreVideo", "IOSurface"]

  spec.vendored_frameworks = "framework/FFmpeg.xcframework", "framework/TAVMedia.xcframework"

  spec.libraries = ["iconv", "z", "c++"]

end
