require 'rails_helper'

RSpec.describe 'Markets requests' do
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

  describe 'sad path' do
    it 'returns a error message' do

      get "/api/v0/markets/12345678910"

      body = JSON.parse(response.body, symbolize_names: true)
      error_detail = body[:errors].first[:detail]

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      expect(body).to have_key(:errors)

      expect(error_detail).to eq("Couldn't find market with 'id'=12345678910.")
    end
  end

  before(:each) do
    @market_1 = create(:market)
    @market_2 = create(:market)
    vendor_1 = create(:vendor)
    vendor_2 = create(:vendor)
    vendor_3 = create(:vendor)
    MarketVendor.create(market_id: @market_1.id, vendor_id: vendor_1.id)
    MarketVendor.create(market_id: @market_1.id, vendor_id: vendor_2.id)
    MarketVendor.create(market_id: @market_2.id, vendor_id: vendor_3.id)
    MarketVendor.create(market_id: @market_2.id, vendor_id: vendor_1.id)
  end

  describe '/api/v0/markets/#{market.id}/vendors' do
    it 'returns all of the for a market vendors' do
      get "/api/v0/markets/#{@market_1.id}/vendors"
      expect(response).to be_successful

      body = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(body.count).to eq(2)

      body.each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq('vendor')

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to be_a(Hash)

        attributes = vendor[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:contact_name)
        expect(attributes).to have_key(:contact_phone)
        expect(attributes).to have_key(:credit_accepted)
      end
    end

    it 'returns an error if the id does not match any existing markets id' do
      get "/api/v0/markets/1/vendors"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      body = JSON.parse(response.body, symbolize_names: true)
      error = body[:errors].first
      
      expect(error[:detail]).to eq("Could not find Market with id of 1.")
    end
  end
end