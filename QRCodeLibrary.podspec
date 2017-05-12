Pod::Spec.new do |s|
  s.name         = 'QRCodeLibrary'
  s.version      = '0.0.2'
  s.summary      = 'QRCodeLibrary is a high level request util based on AVFoundation'
  s.homepage     = 'https://github.com/chengshiliang/QRCode-master'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'chengshiliang' => '285928582@qq.com' }
  s.source       = { :git => 'https://github.com/chengshiliang/QRCode-master.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = 'QRCodeLibrary/*.{h,m}'
  s.resource     = 'Bundle/*'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit', 'AVFoundation' , 'CoreImage'
  s.dependency   'Masonry', '~> 1.0.2'
 #s.library      = 'sqlite3'
end