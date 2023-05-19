class Api::V0::MarketSearchController < ApplicationController
  def index
    @markets = MarketSearchFacade.search_markets(params[:name],  params[:state])
    render json: MarketSerializer.new(@markets)
  end
end