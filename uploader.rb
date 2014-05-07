require 'erb'
require 'rubygems'
require 'pry'
require 'sinatra'
require 'fileutils'
require 'dir'

  def img name
    
  end
        
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
  PATH="./public/images"
  tmpfile = params[:file][:tempfile]
  filename = params[:file][:filename]
  FileUtils.cp(tmpfile, "#{PATH}/#{filename}")
  redirect back
 end
