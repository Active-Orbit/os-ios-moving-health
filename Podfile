workspace 'App.xcworkspace'
platform :ios, '12.0'
use_frameworks!

def required_pods
  
  pod 'Alamofire', '= 5.7.1'
  pod 'RealmSwift', '= 10.40.2'
  
  pod 'ObjectMapper'
  pod 'Kingfisher'
  pod 'DropDown'
  pod 'Toast-Swift'
  pod 'SideMenu'
  pod 'CBPinEntryView'
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  
  pod 'GoogleMaps'
  pod 'DGCharts'
  
end

target 'MovingHealth' do
  project 'App.xcodeproj'
  platform :ios, '12.0'
  required_pods
end

target 'MovingHealthDev' do
  project 'App.xcodeproj'
  platform :ios, '12.0'
  required_pods
end

target 'MovingHealthTests' do
  required_pods
end

target 'MovingHealthUITests' do
  required_pods
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
end
