class Api::V0::MarketsController < ApplicationController
  def index
    markets = Market.all
    render json: MarketSerializer.format_markets(markets)
  end

  def show
    render json: Market.find(params[:id])
  end
end