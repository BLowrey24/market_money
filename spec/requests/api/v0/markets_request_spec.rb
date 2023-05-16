require 'rails_helper'

RSpec.describe 'Markets API' do
  describe 'api/v0/markets' do
    before do
      create_list(:market, 5)

      get '/api/v0/markets'
    end

    it 'this endpoint is successful' do
      expect(response).to be_successful
    end

    it 'the response gets parsed and turned into a ruby object and looks cleaner' do
      markets = JSON.parse(response.body, symbolize_names: true)
# require 'pry'; binding.pry
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
        
        expect(market).to have_key(:vendor_count)
        expect(market[:vendor_count]).to be_a(Integer)
      end
    end
  end

  describe '/api/v1/books/#{id}' do
    before do
      @market_1 = Market.create!(name: "Mann, Gerlach and Gislason", street: "6230 Wiza Mill", city: "Howebury", county: "Willow Pointe", state: "WV", zip: "25470", lat: "-84.30181491586268", lon: "-7.17545639902275")
      @market_2 = Market.create!(name: "Robel Inc", street: "99376 Casper Village", city: "Port Duane", county: "Park Village", state: "MD", zip: "31675", lat: "47.038602535154695", lon: "117.29335732373141")

      get "/api/v0/markets/#{@market_1.id}"
    end

    it 'it is a successful endpoint' do
      expect(request.url).not_to eq("http://www.example.com/api/v0/markets/#{@market_2.id}")
      expect(request.url).to eq("http://www.example.com/api/v0/markets/#{@market_1.id}")
      expect(response).to be_successful
    end

    it 'can get a market by an id' do
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:id]).to eq(@market_1.id)

      expect(market[:name]).to eq("Mann, Gerlach and Gislason")

      expect(market[:street]).to eq("6230 Wiza Mill")

      expect(market[:city]).to eq("Howebury")

      expect(market[:county]).to eq("Willow Pointe")

      expect(market[:state]).to eq("WV")

      expect(market[:zip]).to eq("25470")

      expect(market[:lat]).to eq("-84.30181491586268")

      expect(market[:lon]).to eq("-7.17545639902275")

      expect(market[:vendor_count]).to eq(0)
    end
  end
end