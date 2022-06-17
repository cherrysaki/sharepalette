# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Original' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Firebase/Storage'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'IQKeyboardManagerSwift'

  pod 'GoogleMaps'
  pod 'Google-Maps-iOS-Utils'

  post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

  # Pods for Original

  target 'OriginalTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OriginalUITests' do
    # Pods for testing
  end

end
