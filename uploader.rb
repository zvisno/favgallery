require 'erb'
require 'rubygems'
require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'fileutils'
require 'dir'
require 'aws/s3'
require 'open-uri'
require 'net/http'

configure :development do
  register Sinatra::Reloader
end

PATH = "./public/images"

set :server, 'webrick'
set :bucket, ENV['S3_BUCKET']
set :s3_key, ENV['AWS_ACCESS_KEY_ID']
set :s3_secret, ENV['AWS_SECRET_ACCESS_KEY']
        
def list_of_images(folder)
  check_dir_exists? PATH
  return Dir.entries(folder)
end

def check_dir_exists? dir
  if !Dir.exists? dir
    Dir.mkdir dir
  end
end

def establish_s3_connection
  AWS::S3::Base.establish_connection!(:access_key_id => settings.s3_key,
                                      :secret_access_key => settings.s3_secret)
end

def list_images
  a = []

  establish_s3_connection
  bucket = AWS::S3::Bucket.find(settings.bucket)
  bucket.objects.each do |o|
    url = AWS::S3::S3Object.url_for( o.key, settings.bucket, :authenticated => false )
    a << url
  end

  AWS::S3::Base.disconnect!
  return a.map { |item|  "<div class='image-subcontainer'> <img src = '#{item}' alt = '#{item}'/> </div>" }.join
end

get '/details' do
  image_url = params[:url]
  uri = URI.parse(image_url)

  file_size = Net::HTTP.start(uri.host, uri.port) do |http|
    response = http.request_head uri
    response['Content-Length']
  end

  size = (file_size.to_i/(1024.0)).round(3).to_s
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

    establish_s3_connection
    AWS::S3::S3Object.store(filename, open(tmpfile), settings.bucket, :access => :public_read)
    AWS::S3::Base.disconnect!
    redirect back
  else
    alarm = 1
    erb = ERB.new(File.read("./view/index.html.erb"))
    erb.result(binding)  
  end
end