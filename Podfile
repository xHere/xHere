# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'xHere' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for xHere
   pod 'Parse'
   pod 'ParseFacebookUtils'
   pod 'Fusuma'
   pod 'PBJVision'
   pod 'AFNetworking', '~> 3.0'
   pod 'iCarousel'
   pod 'STLocationRequest'
   pod 'SVProgressHUD'
   pod 'UITextView+Placeholder', '~> 1.2'
  
  target 'xHereTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'xHereUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
