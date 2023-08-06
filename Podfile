# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Netlaga' do
    # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

   # Pods for iOS Firestore
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  #pod 'Firebase/Auth', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'fix-apns-16'
  pod 'Firebase/Firestore'
  pod 'Firebase/DynamicLinks'
  pod 'FirebaseMessaging'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod "BSImagePicker", "~> 3.1"
  pod 'Alamofire'
  pod 'GeoFire'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Core'
  pod 'Kingfisher', '~> 7.6.2'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'Shuffle-iOS'
  pod 'PopBounceButton'
  pod 'MessageKit'
  pod 'Gallery'
  pod 'ProgressHUD'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage'
  pod 'SwiftyComments'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end

end
