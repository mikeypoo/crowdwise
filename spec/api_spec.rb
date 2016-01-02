ENV['RACK_ENV'] = 'test'

require_relative '../api'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'the crowdwise api' do
  def app
    Sinatra::Application
  end

  context '/' do
    it 'has the proper response for the root route' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Ed')
      expect(last_response.body).to include('Mike')
      expect(last_response.body).to include('Johnathon')
      expect(last_response.body).to include('Robert')
      expect(last_response.body).to include('Siena')
      expect(last_response.body).to include('Elena')
      expect(last_response.body).to include('Lee')
    end
  end

  context '/listings/{id}' do
    it 'has the proper response for an individual listing' do
      get '/listings/4'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Robert')
      expect(last_response.body).not_to include('Mike')
    end

    it 'has the proper response for a Listing that does not exist' do
      get "/listings/#{Listing.last.id + 1}"
      expect(last_response.body.to_s.length).to eq(0)
    end
  end
end
