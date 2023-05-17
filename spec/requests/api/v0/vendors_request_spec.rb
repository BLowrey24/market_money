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

    it 'returns an error if vendor does not exist' do
      get "/api/v0/vendors/10"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      body = JSON.parse(response.body, symbolize_names: true)
      error = body[:errors].first

      expect(error[:detail]).to eq("Could not find Vendor with id of 10.")
    end
  end

  describe 'create a vendor' do
    it 'can create a new vendor' do
      vendor_attributes = {
        name: 'Bostons',
        description: 'Good place for good food',
        contact_name: 'Boston Lowrey',
        contact_phone: '1231231250',
        credit_accepted: false
      }

      post '/api/v0/vendors', params: { vendor: vendor_attributes }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      body = JSON.parse(response.body, symbolize_names: true)[:data]
      vendor = body[:attributes]

      expect(body).to have_key(:id)
      expect(body[:id]).to be_a(String)

      expect(body).to have_key(:type)
      expect(body[:type]).to eq('vendor')

      expect(vendor).to have_key(:name)
      expect(vendor[:name]).to eq(vendor_params[:name])

      expect(vendor).to have_key(:description)
      expect(vendor[:description]).to eq(vendor_params[:description])

      expect(vendor).to have_key(:contact_name)
      expect(vendor[:contact_name]).to eq(vendor_params[:contact_name])

      expect(vendor).to have_key(:contact_phone)
      expect(vendor[:contact_phone]).to eq(vendor_params[:contact_phone])

      expect(vendor).to have_key(:credit_accepted)
      expect(vendor[:credit_accepted]).to eq(vendor_params[:credit_accepted])
    end
  end
end