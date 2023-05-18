require 'rails_helper'

RSpec.describe 'MarketVendor requests' do

  before(:each) do
    @market_1 = create(:market)
    @market_2 = create(:market)

    @vendor_1 = create(:vendor)
    @vendor_2 = create(:vendor)
  end

  describe 'post /api/v0/market_vendors' do
    it 'can add a vendor to a market' do
      post "/api/v0/market_vendors", params: { market_id: @market_1.id, vendor_id: @vendor_1.id }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:market_id]).to eq(@market_1.id)
      expect(body[:vendor_id]).to eq(@vendor_1.id)
      expect(@market_1.vendors.count).to eq(1)
      expect(@market_1.vendors.first.id).to eq(@vendor_1.id)
    end
  end
end