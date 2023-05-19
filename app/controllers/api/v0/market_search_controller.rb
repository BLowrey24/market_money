class Api::V0::MarketSearchController < ApplicationController
  def index
    @markets = MarketSearchFacade.search_markets(params[:name])
    render json: MarketSerializer.new(@markets)
  end
end