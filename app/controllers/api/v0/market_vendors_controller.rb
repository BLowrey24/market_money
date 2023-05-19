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
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if market_vendor
      market_vendor.destroy
      render json:  {}, status: :no_content
    else
      render json: { errors: [{ detail: "Could not find MarketVendor with market_id of '#{params[:market_id]}' OR vendor_id of '#{params[:vendor_id]}'."}] }, status: :not_found
    end
  end
end