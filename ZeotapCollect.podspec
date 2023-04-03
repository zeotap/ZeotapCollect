
Pod::Spec.new do |s|
    s.name         = "ZeotapCollect"
    s.version      = "0.0.4"
    s.summary      = "ZeotapCollect SDK is used to integrate with client application for sending events"
    s.description  = "ZeotapCollect SDK is used to integrate with client application for sending events to Zeotap"
    s.homepage     = "https://github.com/zeotap/ios-package-manager"
    s.license =  { :type => 'MIT', :file => 'LICENSE' }
    s.author             = { "karthik-zeotap" => "karthik.datta@zeotap.com" }
    s.source       = { :git => "https://github.com/zeotap/ios-package-manager.git", :tag => s.version }
    s.vendored_frameworks = "ZeotapCollect.xcframework"
    s.platform = :ios
    s.swift_version ="5.3.0"
    s.ios.deployment_target  = '11'
end
