require 'erb'
require 'rubygems'
require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'fileutils'
require 'dir'

configure :development do
  register Sinatra::Reloader
end

PATH = "./public/images"
        
def list_of_images(folder)
  check_dir_exists? PATH
  return Dir.entries(folder)
end

def check_dir_exists? dir
  if !Dir.exists? dir
    Dir.mkdir dir
  end
end

def list_images folder
  list = list_of_images folder
  return list.map { |item|  "<img src = 'images/#{item}' alt = '#{item}' height='100'/>" }.join
 end

get '/details' do
  image = params[:url]
  file_size = File.size("./public/#{image}")
  size = (file_size/(1024.0)).round(3).to_s
  erb = ERB.new(File.read("./view/image_details.html.erb"))
  erb.result(binding)
end

get '/' do
  alarm = 0
  erb = ERB.new(File.read("./view/index.html.erb"))
  erb.result(binding)
end

post '/' do
  if !params[:file].nil?
    tmpfile = params[:file][:tempfile]
    filename = params[:file][:filename]

    FileUtils.cp(tmpfile, "#{PATH}/#{filename}")
    redirect back
  else
    alarm = 1
    erb = ERB.new(File.read("./view/index.html.erb"))
    erb.result(binding)  
  end
end
