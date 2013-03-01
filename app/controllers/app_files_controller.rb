class AppFilesController < ApplicationController
	respond_to :json

	EXCLUDED_FILES = %w[Gemfile.lock log public config.ru db bin README.rdoc tmp]

	def index
		@entries = files_for_path(File.join(Rails.root, 'public', 'batman-rdio'))
		respond_with @entries
	end

	def show
		@file = File.new(params[:path], 'r')
		respond_with id: params[:path], content: @file.read
	end

	def files_for_path(path)
		Dir.entries(path)
			.select {|file| file[0] != '.' and !EXCLUDED_FILES.include?(file)}
			.map do |file|
				filepath = File.join(path, file)
				hash = {id: filepath, name: file, isDirectory: File.directory?(filepath)}
				if hash[:isDirectory]
					hash[:children] = files_for_path(hash[:id])
				end

				hash
			end
	end
end
