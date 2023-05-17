class Api::V0::VendorsController < ApplicationController
  def index
    if Market.exists?(params[:market_id])
      @market = Market.find(params[:market_id])
      render json: VendorSerializer.new(@market.vendors)
    else
      render json: { errors: [{ detail: "Could not find Market with id of #{params[:market_id]}."}] }, status: 404
    end
  end

  def show
    if Vendor.exists?(params[:id])
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    else
      render json: { errors: [{ detail: "Could not find Vendor with id of #{params[:id]}."}] }, status: 404
    end
  end
end