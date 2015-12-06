# require just so many things
require 'rubygems'
require 'sinatra'
require 'json'
require 'data_mapper'
require_relative 'models/listing'

# establish database connection
DataMapper.setup(:default, "postgres://mike:dairyninja9@localhost/cwdev")
DataMapper.auto_upgrade!

  ##################
  ##### ROUTES #####
  ##################

get '/' do
  @listings = [ ]
  Listing.all.count.times do |index|
    if listing = Listing.get(index + 1)
      @listings.push(Listing.get(index + 1))
    end
  end
  erb :index
end

get '/listings/:id' do |id|
  listing = Listing.get(id)
  return unless listing
  {
    id: listing.id,
    name: listing.name,
    status: listing.status
  }.to_json
end

put '/listings/:id' do |id|
  listing = Listing.get(id)
  return unless listing
  new_status = params[:status] || listing.status
  return unless Listing::STATUSES.has_key?(new_status.to_sym)
  new_name = params[:name] || listing.name
  listing.update(name: new_name, status: params[:status])
end

post '/create_listing' do
  return unless name = params[:name]
  listing = Listing.new
  listing.name = name
  listing.save
end

put '/delete_listing' do
  listing = Listing.get(params[:id])
  return unless listing
  listing.delete!
end
