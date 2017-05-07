# Author : Fernando Gutierrez / Marcelo Vargas

require 'mixlib/log'
require 'fileutils'

class Log
  extend Mixlib::Log
end

def create_folder(foldername)
  root = Pathname.pwd
  FileUtils::mkdir_p "#{root}/#{foldername}/"
  return "#{root}/#{foldername}/"
end

def init_logger(path, filename)
  Log.init("#{path}/#{filename}")
  Log.level(new_level = :debug)
end