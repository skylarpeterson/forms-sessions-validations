class PhotosController < ApplicationController
	def index
		if(params[:id] != nil) then
			@user = User.find(params[:id])
			@photos = Photo.find(:all, :conditions => "user_id = " + @user.id.to_s);
			@title = @user.first_name + " " + @user.last_name + ": Photos"
		else
			@title = "Error"
		end
	end
	
	def new
		if session[:user_id] then
			@user = User.find(session[:user_id])
			@title = "Upload New Photo"
		else
			redirect_to "users/login", :notice => "Must be logged in to upload photos"
		end
	end
	
	def create
		if session[:user_id] then
			file = params[:photo][:file_val];
			name = file.original_filename
			directory = "public/images"
			path = File.join(directory, name)
			File.open(path, "wb") { |f| f.write(file.read) }
			user = User.find(session[:user_id])
			photo = Photo.new
			photo.user_id = user.id
			photo.date_time = DateTime.now
			photo.file_name = name
			photo.save()
			url = "/photos/index/" + user.id.to_s
			redirect_to url
		else 
			redirect_to "users/login", :notice => "Must be logged in to upload photos"
		end
	end
end
