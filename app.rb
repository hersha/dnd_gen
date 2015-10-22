require 'sinatra/base'
require 'redis'
require 'digest'
require 'ostruct'

require_relative 'lib/character'

class App < Sinatra::Base
  REDIS = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost")

  def cache
    hash = Digest::MD5.hexdigest(@character.to_json)
    REDIS.set hash[0..9], @character.to_json
    REDIS.expire hash[0..9], 60*10
    hash[0..9]
  end

  def load_character
    json = REDIS.get @id
    OpenStruct.new JSON.parse(json)
  end

  set :public_folder, 'public'
  configure :production do
    require 'newrelic_rpm'
  end

  get '/' do
    @character = Character.new
    @id = cache
    erb :index
  end

  get '/:id' do
    @id = params[:id]
    @character = load_character
    erb :index
  end

  get '/save/:id' do
    @id = params[:id]
    REDIS.persist @id
    redirect to("/#{@id}")
  end 
end
