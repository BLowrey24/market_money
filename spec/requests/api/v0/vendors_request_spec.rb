require 'rails_helper'

RSpec.describe 'Vendors requests' do

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

  describe '/api/v0/markets/#{market.id}/vendors' do
    describe 'vendor index happy path' do
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
    end

    describe 'vendor index sad path' do
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

  describe '/api/v0/vendors/#{vendor_id}' do
    describe 'vendor show happy path' do
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
  
    describe 'vendor show sad path' do
      it 'returns an error if vendor does not exist' do
        get "/api/v0/vendors/10"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error[:detail]).to eq("Could not find Vendor with id of 10.")
      end
    end
  end

  describe 'create a vendor' do
    describe 'create a vendor happy path' do
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
        expect(vendor[:name]).to eq(vendor_attributes[:name])

        expect(vendor).to have_key(:description)
        expect(vendor[:description]).to eq(vendor_attributes[:description])

        expect(vendor).to have_key(:contact_name)
        expect(vendor[:contact_name]).to eq(vendor_attributes[:contact_name])

        expect(vendor).to have_key(:contact_phone)
        expect(vendor[:contact_phone]).to eq(vendor_attributes[:contact_phone])

        expect(vendor).to have_key(:credit_accepted)
        expect(vendor[:credit_accepted]).to eq(vendor_attributes[:credit_accepted])
      end
    end

  describe 'create a vendor sad path' do
      it 'returns an error if attribute is missing' do
        vendor_attributes = {
          name: '',
          description: 'Good place for good food',
          contact_name: 'Boston Lowrey',
          contact_phone: '1231231250',
          credit_accepted: false
        }

        post '/api/v0/vendors', params: { vendor: vendor_attributes }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        body = JSON.parse(response.body, symbolize_names: true)
      end
    end
  end

  describe 'patch /api/v0/vendors/#{vendor.id}' do
    describe 'update vendor happy path' do
      it 'can update a vendor' do
        vendor = create(:vendor)
        vendor_attributes = {
          name: 'Bostons',
          description: 'Good place for good food',
          contact_name: 'Boston Lowrey',
          contact_phone: '1231231250',
          credit_accepted: false
        }

        patch "/api/v0/vendors/#{vendor.id}", params: { vendor: vendor_attributes }

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(Vendor.last.name).to eq(vendor_attributes[:name])
        expect(Vendor.last.description).to eq(vendor_attributes[:description])
        expect(Vendor.last.contact_name).to eq(vendor_attributes[:contact_name])
        expect(Vendor.last.contact_phone).to eq(vendor_attributes[:contact_phone])
        expect(Vendor.last.credit_accepted).to eq(vendor_attributes[:credit_accepted])
      end
    end

    describe 'update vendor sad path' do
      it 'returns an error if vendor does not exist' do
        patch "/api/v0/vendors/0"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end

      it 'returns an error if an attribute is missing' do
        vendor = create(:vendor)
        vendor_attributes = {
          name: 'Bostons',
          description: 'Good place for good food',
          contact_name: '',
          contact_phone: '1231231250',
          credit_accepted: false
        }

        patch "/api/v0/vendors/#{vendor.id}", params: { vendor: vendor_attributes }
        body = JSON.parse(response.body, symbolize_names: true)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(body).to have_key(:errors)
        expect(body[:errors].first[:detail]).to eq("Fill in all fields")
      end
    end
  end

  describe 'delete /api/v0/vendors/#{vendor_id}' do
    describe 'delete a vendor happy path' do
      it 'deletes a vendor' do
        vendor = create(:vendor)

        delete "/api/v0/vendors/#{vendor.id}"

        expect(response).to be_successful
        expect(response.status).to eq(204)

        expect(Vendor.where(id: vendor.id)).to eq([])
      end
    end

    describe 'delete a vendor sad path' do
      it 'returns an error if vendor does not exist' do
        delete "/api/v0/vendors/0"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)
      end
    end
  end
end