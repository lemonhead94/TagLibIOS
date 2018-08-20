#
# Be sure to run `pod lib lint TagLibIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TagLibIOS'
  s.version          = '0.3.0'
  s.summary          = 'TagLibIOS is a wrapper for the TagLib Audio Meta-Data Library.'

  s.description      = <<-DESC
  **TagLibIOS Audio Meta-Data Library**

  http://TagLibIOS.org/

  TagLibIOS is a library for reading and editing the meta-data of several
  popular audio formats. Currently it supports both ID3v1 and [ID3v2](http://www.id3.org)
  for MP3 files, [Ogg Vorbis](http://vorbis.com/) comments and ID3 tags and Vorbis comments
      in [FLAC](https://xiph.org/flac/), MPC, Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF
      files.
                       DESC

  s.homepage         = 'https://github.com/lemonhead94/TagLibIOS'
  s.license          = { :type => 'LGPL and MPL', :file => 'LICENSE' }
  s.author           = { 'lemonhead94' => 'jorit.studer@gmail.com' }
  s.source           = { :git => 'https://github.com/lemonhead94/TagLibIOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.module_map = 'TagLibIOS/Framework/TagLibIOS.modulemap'
  s.public_header_files = ['TagLibIOS/Framework/TagLibIOS-umbrella.h', 'TagLibIOS/Classes/iOSWrapper/*.h']
  s.private_header_files = 'TagLibIOS/Classes/taglib/**/*.h'
  s.source_files = ['TagLibIOS/Framework/TagLibIOS-umbrella.h', 'TagLibIOS/Classes/**/**/*.{h,cpp,mm}']
  s.library = 'c++'
  s.xcconfig = {
      'CLANG_CXX_LANGUAGE_STANDARD' => 'gnu++14',
      'CLANG_CXX_LIBRARY' => 'libc++'
  }
end
