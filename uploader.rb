require 'erb'
require 'rubygems'
require 'pry'
require 'sinatra'
require 'fileutils'
require 'dir'

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
  File.size("./public/#{image}").to_s
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
