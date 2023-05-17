require 'rails_helper'

RSpec.describe 'Vendors requests' do
  describe '/api/v0/vendors/#{vendor_id}' do
    before(:each) do
      @market_1 = create(:market)
      @market_2 = create(:market)
      @vendor_1 = create(:vendor)
      @vendor_2 = create(:vendor)
      @vendor_3 = create(:vendor)
      MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_1.id)
      MarketVendor.create(market_id: @market_1.id, vendor_id: @vendor_2.id)
      MarketVendor.create(market_id: @market_2.id, vendor_id: @vendor_3.id)
      MarketVendor.create(market_id: @market_2.id, vendor_id: @vendor_1.id)
    end
    it 'returns one vendor' do
      create(:vendor)
      
      get "/api/v0/vendors/#{@vendor_1.id}"
      
      expect(response).to be_successful
      
      body = JSON.parse(response.body, symbolize_names: true)[:data]
      attributes = body[:attributes]
      
      expect(body).to have_key(:id)
      expect(body[:id]).to be_a(String)
      expect(attributes).to have_key(:name)
      expect(attributes).to have_key(:description)
      expect(attributes).to have_key(:contact_name)
      expect(attributes).to have_key(:contact_phone)
      expect(attributes).to have_key(:credit_accepted)
    end
  end
end