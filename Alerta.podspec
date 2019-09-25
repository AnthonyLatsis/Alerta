#
#  Be sure to run `pod spec lint Alerta.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |spec|

	spec.name         			= "Alerta"
	spec.version 		 		    = "4.2.2"
	spec.license      			= { :type => "MIT", :file => "LICENSE" }

  spec.platform     			= :ios, "10.0"
  spec.swift_version      = "4.2"
 	spec.framework  			  = "UIKit" 
	spec.source_files  			= "Alerta/**/*.{swift}"

  spec.homepage    		 		= "https://github.com/AnthonyLatsis/Alerta/"
  spec.source       			= { :git => "https://github.com/AnthonyLatsis/Alerta.git", :tag => "#{spec.version}" }
  
  spec.author             = { "Anthony Latsis" => "aqamoss3fan2010@gmail.com" }
  spec.social_media_url   = "https://www.instagram.com/anthonylatsis/"
  
  spec.summary      			= "An iOS native-style alert controller you can customize to your heart's content."

  spec.requires_arc 			= true
end
