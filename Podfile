# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AnalogueTimeApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AnalogueTimeApp
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'

  pod 'JGProgressHUD'

  pod "Floaty", "4.0.0" # Use version 4.0.0 for Swift 4.0
  pod 'SwiftDate'
  pod 'DropDown', "2.0.2"
  pod 'SDWebImage', '~> 4.0'

  target 'AnalogueTimeAppTests' do
    inherit! :search_paths
    # Pods for testing

  end

  target 'AnalogueTimeAppUITests' do
    inherit! :search_paths
    # Pods for testing
  end


end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
