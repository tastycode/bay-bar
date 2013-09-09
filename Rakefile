# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Bay Bar'
  app.icon = 'icons.icns'
  app.identifier = "com.illuminatedengine.bay-bar"
  app.info_plist['NSUIElement'] = 1
end
