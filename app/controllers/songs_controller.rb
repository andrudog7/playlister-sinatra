require 'rack-flash'

class SongsController < ApplicationController
    use Rack::Flash 

    get '/songs' do 
        @songs = Song.all 
        erb :'/songs/index'
    end

    get '/songs/new' do 
        @genres = Genre.all
        @artists = Artist.all
        erb :'/songs/new'
    end

    post '/songs' do 
        @song = Song.new(name: params[:name])
        
        if !params[:genre_ids].empty?
            params[:genre_ids].each do |id|
                @song.genres << Genre.find_by_id(id)
            end
        end
        
        if params[:artist]
            artist = Artist.find_or_create_by(name: params[:artist][:name])
            @song.artist = artist 
        end
        
        @song.save
        flash[:message] = "Successfully created song."
        redirect to "/songs/#{@song.slug}"
    end

    get '/songs/:slug' do 
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/show'
    end

    get '/songs/:slug/edit' do 
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/edit'
    end

    patch '/songs/:slug' do 
        @song = Song.find_by_slug(params[:slug])
        @song.update(params[:song])

        if !params[:genre_ids].empty?
            @song.genre_ids = params[:genre_ids]
        end

        if params[:artist]
            artist = Artist.find_or_create_by(name: params[:artist][:name])
            @song.artist = artist 
        end
        @song.save
        flash[:message] = "Successfully updated song."

        redirect("/songs/#{@song.slug}")
    end
end