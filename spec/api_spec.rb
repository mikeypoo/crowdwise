ENV['RACK_ENV'] = 'test'
ENV['ENV'] = 'test'

require_relative '../api'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def generate_test_data
  %w{ Frasier Niles Daphne Martin }.each do |name|
    l = Listing.new
    l.name = name
    l.status = 'active'
    l.save!
  end
end

describe 'the crowdwise api' do
  before(:all) do
    generate_test_data
  end

  after(:all) do
    # you're my wonder walllllllllllll
    Listing.all.destroy
  end

  def app
    Sinatra::Application
  end

  context 'with test data' do
    context '/' do
      it 'has the proper response for the root route' do
        get '/'
        expect(last_response).to be_ok
        expect(last_response.body).to include('Frasier')
        expect(last_response.body).to include('Niles')
        expect(last_response.body).to include('Daphne')
        expect(last_response.body).to include('Martin')
      end
    end

    context '/listings/{id}' do
      it 'has the proper response for an individual listing' do
        get "/listings/#{Listing.last.id}"
        expect(last_response).to be_ok
        expect(last_response.body).to include('Martin')
        expect(last_response.body).not_to include('Frasier')
      end

      it 'has the proper response for a Listing that does not exist' do
        get "/listings/#{Listing.last.id + 1}"
        expect(last_response.body.to_s.length).to eq(0)
      end
    end
  end
end
