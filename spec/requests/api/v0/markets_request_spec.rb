require 'rails_helper'

RSpec.describe 'Markets API' do
  describe 'api/v0/markets' do
    it 'this endpoint is successful' do
      create_list(:market, 5)

      get '/api/v0/markets'

      expect(response).to be_successful
    end

    it 'the response gets parsed and turned into a ruby object and looks cleaner' do
      create_list(:market, 5)

      get '/api/v0/markets'

      markets = JSON.parse(response.body, symbolize_names: true)

      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(Integer)
  
        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)
  
        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)
  
        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)
  
        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)

        expect(market).to have_key(:state)
        expect(market[:state]).to be_a(String)

        expect(market).to have_key(:zip)
        expect(market[:zip]).to be_a(String)

        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_a(String)

        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_a(String)
      end
    end
  end

  describe '/api/v1/books/#{id}' do
    it 'it is a successful endpoint' do
      id = create(:market).id

      get "/api/v0/markets/#{id}"

      expect(response).to be_successful
    end
  end
end