
Pod::Spec.new do |s|

  s.name         = "ZappMerchantLib"
  s.version      = "1.0.2"
  s.summary      = "Zapp Merchant Library"

  s.description  = <<-DESC
                   ZappMerchantLib is a library for iOS used to integrate Pay by Bank app payments.
                   DESC

  s.homepage = "http://www.zapp.co.uk"
  s.license  = "Apache 2.0"
  s.authors  = "Alex Maimescu"
  s.platform = :ios, '8.0'

  s.source = { :git => 'https://github.com/vocalinkzapp/ZappMerchantLib-R2-iOS.git', :tag => s.version.to_s }
  
  s.public_header_files = [
    "ZappMerchantLib/ZappMerchantLib.h",
    "ZappMerchantLib/PBBAAppUtils.h",
    "ZappMerchantLib/PBBAButton.h",
    "ZappMerchantLib/PBBAPopupViewController.h",
    "ZappMerchantLib/PBBAUIElementAppearance.h",
    "ZappMerchantLib/PBBAAnimatable.h",
    "ZappMerchantLib/PBBALibraryUtils.h"
  ]

  s.source_files = "ZappMerchantLib/**/*.{h,m}"

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.ios.resource_bundle = { 'ZappMerchantLibResources' => [
      "ZappMerchantLibResources/**/*.otf", 
      "ZappMerchantLibResources/**/*.lproj", 
      "ZappMerchantLibResources/*.xcassets",
      "ZappMerchantLib/**/*.xib"
    ] 
  }

end
