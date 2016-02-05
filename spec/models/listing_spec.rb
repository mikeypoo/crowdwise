ENV['ENV'] = 'test'

require_relative '../../api'
require 'rspec'
require 'rack/test'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'the listing model' do
  after(:all) do
    # you're my wonder walllllllllllll
    Listing.all.destroy
  end

  context 'active listing' do
    # not active listening, which my therapist says I should work on
    let(:listing) do
      l = Listing.new
      l.name = 'Frasier'
      l.status = 'active'
      l.save!
      l
    end

    it 'can be marked as deleted' do
      listing.delete!
      expect(listing.activated?).to eq(false)
      expect(listing.deleted?).to eq(true)
    end
  end

  context 'deleted listing' do
    # not active listening, which my therapist says I should work on
    let(:listing) do
      l = Listing.new
      l.name = 'Niles'
      l.status = 'deleted'
      l.save!
      l
    end

    it 'can be marked as active' do
      listing.activate!
      expect(listing.activated?).to eq(true)
      expect(listing.deleted?).to eq(false)
    end
  end
end
