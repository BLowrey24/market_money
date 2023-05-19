require 'rails_helper'

RSpec.describe 'Markets requests' do
  describe 'index happy path' do
    describe 'api/v0/markets' do
      before do
        create_list(:market, 5)

        get '/api/v0/markets'
      end

      it 'this endpoint is successful' do
        expect(request.url).to eq("http://www.example.com/api/v0/markets")
        expect(response).to be_successful
      end

      it 'returns all markets' do
        markets = JSON.parse(response.body, symbolize_names: true)[:data]

        markets.each do |market|
          expect(market[:id]).to be_a(String)
          expect(market[:attributes][:name]).to be_a(String)
          expect(market[:attributes][:street]).to be_a(String)
          expect(market[:attributes][:city]).to be_a(String)
          expect(market[:attributes][:county]).to be_a(String)
          expect(market[:attributes][:state]).to be_a(String)
          expect(market[:attributes][:zip]).to be_a(String)
          expect(market[:attributes][:lat]).to be_a(String)
          expect(market[:attributes][:lon]).to be_a(String)
          expect(market[:attributes][:vendor_count]).to be_a(Integer)
        end
      end
    end
  end
  describe 'show happy path' do
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

      it 'returns a single market based on the id in the endpoint' do
        market = JSON.parse(response.body, symbolize_names: true)

        expect(market[:data][:id]).to eq("#{@market_1.id}")
        expect(market[:data][:attributes][:name]).to eq("Mann, Gerlach and Gislason")
        expect(market[:data][:attributes][:street]).to eq("6230 Wiza Mill")
        expect(market[:data][:attributes][:city]).to eq("Howebury")
        expect(market[:data][:attributes][:county]).to eq("Willow Pointe")
        expect(market[:data][:attributes][:state]).to eq("WV")
        expect(market[:data][:attributes][:zip]).to eq("25470")
        expect(market[:data][:attributes][:lat]).to eq("-84.30181491586268")
        expect(market[:data][:attributes][:lon]).to eq("-7.17545639902275")
        expect(market[:data][:attributes][:vendor_count]).to eq(0)
      end
    end
  end

  describe 'show sad path' do
    it 'returns a error message' do

      get "/api/v0/markets/12345678910"

      body = JSON.parse(response.body, symbolize_names: true)
      error_detail = body[:errors].first[:detail]

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(body).to have_key(:errors)

      expect(error_detail).to eq("Could not find market with id of '12345678910'.")
    end
  end
end