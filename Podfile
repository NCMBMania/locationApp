# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ncmbLocation' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for ncmbPush
  pod 'NCMB', :git => 'https://github.com/NIFCloud-mbaas/ncmb_ios.git'
  
  target 'ncmbLocationTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ncmbLocationUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

plugin 'cocoapods-keys', {
  :project => "ncmbLocation",
  :keys => [
    "applicationKey",
    "clientKey"
  ]}