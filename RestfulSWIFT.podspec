Pod::Spec.new do |podspec|
  podspec.name             = 'PromisedRestfulSwift'
  podspec.version          = ENV['LIB_VERSION'] || '1.0' #fallback to major version
  podspec.summary          = 'Provides a Restful API for SWIFT based on Promises.'
  podspec.homepage         = 'https://github.com/geigervlad/RestfulSWIFT'
  podspec.license          = { :type => 'MIT', :file => 'LICENSE' }
  podspec.author           = { 'Vlad Geiger' => 'geiger.vlad.mihaly@gmail.com' }
  podspec.source           = { :git => 'https://github.com/geigervlad/RestfulSWIFT.git', :tag => podspec.version.to_s }
  podspec.ios.deployment_target = '11.4'
  podspec.swift_version   = '5.0'
  podspec.source_files = 'RestfulSWIFT Sources/Sources/**/*'
  podspec.dependency 'PromiseKit', '~> 6.13.0'
  
end
