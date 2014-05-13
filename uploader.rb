require 'erb'
require 'rubygems'
require 'pry'
require 'sinatra'
require 'fileutils'
require 'dir'

PATH = "./public/images"
        
def list_of_images(folder)
  return Dir.entries(folder)
end

def list_images folder
  list = list_of_images folder
  return list.map { |item|  "<img src = 'images/#{item}' alt = '#{item}' height='100'/>" }
end

get '/' do
  erb = ERB.new(File.read("./view/index.html.erb"))
  erb.result(binding)
end

post '/' do

  if !params[:file].nil?
    tmpfile = params[:file][:tempfile]
    filename = params[:file][:filename]

    FileUtils.cp(tmpfile, "#{PATH}/#{filename}")
  else
    puts "Popup"
  end

  redirect back
end
