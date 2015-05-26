require 'rubygems'
require 'sinatra'
require 'erb'
require 'sinatra/reloader' if development?
require 'sinatra/cookies'
require 'aws/s3'
require 'fileutils'
require 'dir'
require 'open-uri'
require 'net/http'
require 'pry'

configure :development do
  register Sinatra::Reloader
end

PATH = "./public/images"

set :server, 'webrick'
set :bucket, ENV['S3_BUCKET']
set :s3_key, ENV['AWS_ACCESS_KEY_ID']
set :s3_secret, ENV['AWS_SECRET_ACCESS_KEY']
set :layout, "./view/layout.html.erb"
set :upload, "./view/upload.html.erb"
set :start, "./view/start.html.erb"
set :resume, "./view/resume.html.erb"

def list_of_images(folder)
  check_dir_exists? PATH
  return Dir.entries(folder)
end

def list_images_from_bucket
  a = []
  establish_s3_connection

  bucket = AWS::S3::Bucket.find(settings.bucket)
  bucket.objects.each do |o|
    url = AWS::S3::S3Object.url_for(o.key, settings.bucket, :authenticated => false)
    a << url
  end

  aws_s3_disconnect

  return a
end

def check_dir_exists? dir
  if !Dir.exists? dir
    Dir.mkdir dir
  end
end

def establish_s3_connection
  AWS::S3::Base.establish_connection!(:access_key_id     => settings.s3_key,
                                      :secret_access_key => settings.s3_secret)
end

def aws_s3_disconnect
  AWS::S3::Base.disconnect!
end

def custom_render item
  erb = ERB.new(File.read("./view/layout.html.erb"))
  erb.result(binding)
end

#routes

get '/' do
  custom_render settings.start
end

get '/start' do
  custom_render settings.start
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

get '/upload' do
  @alarm = 0
  custom_render settings.upload
end

get '/resume' do
  custom_render settings.resume
end

post '/' do
  if !params[:file].nil?
    tmpfile = params[:file][:tempfile]
    filename = params[:file][:filename]
    if tmpfile.size < 2000000
      establish_s3_connection
      AWS::S3::S3Object.store(filename, open(tmpfile), settings.bucket, :access => :public_read)
      aws_s3_disconnect
    end
  else
    @alarm = 1
    my_render settings.upload
  end
  redirect "/upload"
end

post '/delete' do
  establish_s3_connection
  filename = params[:filename]
  AWS::S3::S3Object.delete filename, settings.bucket
  redirect back
  aws_s3_disconnect
end
