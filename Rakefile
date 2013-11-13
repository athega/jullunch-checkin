# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'rubygems'
require 'bundler'
Bundler.require

require 'bubble-wrap/core'
require 'sugarcube-image'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'jullunch-checkin'
  app.frameworks += ['QuartzCore', 'AssetsLibrary']
  app.codesign_certificate = "iPhone Developer: Mikael Forsberg (SNAR5QY84P)"
end
