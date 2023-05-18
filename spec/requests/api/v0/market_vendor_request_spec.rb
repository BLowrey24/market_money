require 'rails_helper'

RSpec.describe 'MarketVendor requests' do

  before(:each) do
    @market_1 = create(:market)
    @market_2 = create(:market)

    @vendor_1 = create(:vendor)
    @vendor_2 = create(:vendor)
  end

  describe ' create happy path' do
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
  
  describe 'create sad path' do
    it 'returns an error if the market does not exist' do
      post "/api/v0/market_vendors", params: { market_id: 0, vendor_id: @vendor_1.id }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it 'returns an error if the vendor does not exist' do
      post "/api/v0/market_vendors", params: { market_id: @market_1.id, vendor_id: 0 }

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
    end

    it 'returns an error if the market vendor already exists' do
      MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_1.id)
      post "/api/v0/market_vendors", params: { market_id: @market_1.id, vendor_id: @vendor_1.id }
      
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
    end
  end

  describe 'delete marketvendor' do
    describe 'delete a marketvendor happy path' do
      it 'can delete a marketvendor' do
        marketvendor1 = MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_1.id)
        marketvendor2 = MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_2.id)

        get "/api/v0/markets/#{@market_1.id}/vendors"

        vendors_before_delete = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(vendors_before_delete.count).to eq(2)
        
        delete "/api/v0/market_vendors/", params: { market_id: @market_1.id, vendor_id: @vendor_2.id }
        expect(response).to be_successful
        expect(response.status).to eq(204)
  
        get "/api/v0/markets/#{@market_1.id}/vendors"
  
        vendors_after_delete = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(vendors_after_delete.count).to eq(1)
      end
    end

    describe 'delete a marketvendor sad path' do
      it 'returns an error if the marketvendor does not exist' do
        delete "/api/v0/market_vendors/", params: { market_id: 0, vendor_id: 0}
        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        expect(body[:errors][0][:detail]).to eq("Could not find MarketVendor with market_id of 0 OR vendor_id of 0.")
      end
    end
  end
end