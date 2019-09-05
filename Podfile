use_frameworks!
platform :ios, '10.0'

def shared_pods
  pod 'Moya', '~> 13'
  pod 'SDWebImage'
  pod 'ReachabilitySwift'
end

target 'LocalWeather' do
	shared_pods
    
    target 'LocalWeatherTests' do
        inherit! :search_paths
    end
end
