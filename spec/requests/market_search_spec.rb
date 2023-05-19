require 'rails_helper'

RSpec.describe 'Markets search' do
  describe 'market search happy path' do
    it 'can search by name' do
      create_list(:market, 3)

      get "/api/v0/markets/search", params: { name: "Market" }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      markets = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(markets.count).to eq(0)

      get "/api/v0/markets/search", params: { name: "#{Market.first.name}" }

      markets_2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(markets_2.count).to eq(1)
    end
  end
end