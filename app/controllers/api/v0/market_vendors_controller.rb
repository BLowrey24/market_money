class Api::V0::MarketVendorsController < ApplicationController
  def create
    market = Market.find_by(id: params[:market_id])
    vendor = Vendor.find_by(id: params[:vendor_id])
  
    if market && vendor
      if MarketVendor.exists?(vendor: vendor, market: market)
        render json: { errors: [{ detail: "Vendor already exists at this market." }] }, status: :unprocessable_entity
      else
        market_vendor = MarketVendor.create(vendor: vendor, market: market)
        render json: market_vendor, status: :created
      end
    else
      render json: { errors: [{ detail: "Could not find Market or Vendor with the specified ID." }] }, status: :not_found
    end
  end

  def destroy
    
  end
end