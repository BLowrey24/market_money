class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new( Market.all)
  end

  def show
    if Market.exists?(params[:id])
      render json: MarketSerializer.new(Market.find(params[:id]))
    else
      render json: { errors: [{ detail: "Could not find market with id of #{params[:id]}."}] }, status: :not_found
    end
  end
end