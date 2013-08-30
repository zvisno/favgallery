require 'rubygems'
require 'pry'
require 'sinatra'
require 'fileutils'
require 'dir'

 def img(name) 
        return "<img src = 'images/#{name}' alt = '#{name}' height='100'/>"
 end
        
 def list_of_images(folder)
        return Dir.entries(folder)
 end
				

 get '/' do
	erb 	'
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
		 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		<link rel="stylesheet" href="CSS/my-style.css" type="text/css" media="screen, projection" />
		<head> 
			<title> My favpics </title>
		</head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<body>

		<!-- Form to upload an image or another file -->
			<h1> I Upload Here  </h1>
		 <p><form id="upload-form" action="/" method="post" enctype="multipart/form-data" style="text-align:center" >
		 <input type="file" name="file">
		 <input type="submit" value="Upload"> 

		 </form></br></p>
		<div class="container"> 
		<!-- Form to upload an image or another file -->
			<% list = list_of_images "./public/images"
       			i = list.size %>
			<% if i == 0 
			   	puts "There is no pictures"	
			   else
			   	while i != 0
					i = i-1 %>
					<%= img list[i] %>
				<% end
			end %>
			</div>
		</body>
		</html>
	 	'
 end

 post '/' do
	PATH="./public/images"
	tmpfile = params[:file][:tempfile]
	filename = params[:file][:filename]
	FileUtils.cp(tmpfile, "#{PATH}/#{filename}")
	redirect back
 end

