require 'rails_helper'

RSpec.describe 'Markets search' do
  before(:each) do
    create_list(:market, 3)
  end
  describe 'market search happy path' do
    it 'can search by name' do
      get "/api/v0/markets/search", params: { name: "Market" }
      expect(response).to be_successful
      expect(response.status).to eq(200)

      markets = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(markets.count).to eq(0)

      get "/api/v0/markets/search", params: { name: "#{Market.first.name}" }

      markets_2 = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(markets_2.count).to eq(1)
    end

    it 'can search by state' do
      get "/api/v0/markets/search", params: { state: "#{Market.first.state}" }
      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(market.count).to eq(1)
    end

    it 'can search by state and city' do
      get "/api/v0/markets/search", params: { state: "#{Market.first.state}", city: "#{Market.first.city}" }
      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(market.count).to eq(1)
    end

    it 'can search by state, city, and name' do
      get "/api/v0/markets/search", params: { state: "#{Market.first.state}", city: "#{Market.first.city}", name: "#{Market.first.name}" }
      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(market.count).to eq(1)
    end

    it 'can search by state and name' do
      get "/api/v0/markets/search", params: { state: "#{Market.first.state}", name: "#{Market.first.name}" }
      expect(response).to be_successful
      expect(response.status).to eq(200)

      market = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(market.count).to eq(1)
    end
  end

  describe 'Market search sad path' do

  end
end