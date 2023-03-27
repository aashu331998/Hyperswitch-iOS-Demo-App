platform :ios, '13.0'
source 'https://shashank-shivam@bitbucket.org/shashank-shivam/pods.git'
source 'https://cdn.cocoapods.org/'

use_frameworks!
target 'Hyperswitch-iOS-Demo-App' do

 pod 'hyperswitch', '1.0.0-alpha01'
 end

 post_install do |installer|
  installer.pods_project.targets.each do |target|
   target.build_configurations.each do |config|
    config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = "arm64"
   end
  end
 end