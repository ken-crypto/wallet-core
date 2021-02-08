version = '2.3.3.1'

Pod::Spec.new do |s|
  s.name         = 'TrustWalletCore'
  s.version      = version
  s.summary      = 'Trust Wallet core data structures and algorithms.'
  s.homepage     = 'https://github.com/monacohq/wallet-core'
  s.license      = 'MIT'
  s.authors      = { 'Alejandro Isaza' => 'al@isaza.ca' }
  s.module_name  = 'WalletCore'
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.1'

  s.source = {
    http: "https://github.com/monacohq/wallet-core/releases/download/#{version}/TrustWalletCore-iOS-#{version}.zip"
  }
  s.default_subspec = 'Core'
  
  s.subspec 'Types' do |ss|
    ss.source_files = 
      'swift/Sources/Types/*.swift',
      'swift/Sources/Generated/Enums/*.swift',
      'swift/Sources/Generated/Protobuf/*.swift'
    ss.dependency 'SwiftProtobuf'
  end

  s.subspec 'Core' do |ss|
    ss.preserve_paths = 'build/ios/*.a'
    ss.vendored_libraries = 'build/ios/*.a'
    ss.exclude_files = 'swift/Sources/Generated/WalletCore.h'
    ss.source_files =
      'include/**/*.h',
      'swift/Sources/*.{swift,h,m,cpp}',
      'swift/Sources/Extensions/*.swift',
      'swift/Sources/Generated/*.{swift,h}'
    ss.public_header_files =
      'include/**/*.h',
      'swift/Sources/*.h'
    ss.libraries = 'c++'
    ss.xcconfig = {
        'OTHER_LDFLAGS' => '$(inherited) -fprofile-instr-generate'
    }
    ss.pod_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    ss.user_target_xcconfig = { 
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' 
    }
    ss.dependency 'TrustWalletCore/Types'
  end
end
