class Api::V0::MarketSearchController < ApplicationController
  before_action :invalid_params, only: [:index]

  def index
    @markets = MarketSearchFacade.search_markets(params[:name], params[:state], params[:city])
    render json: MarketSerializer.new(@markets)
  end

  private 

  def invalid_params
    return invalid if city_only
  end

  def city_only
    params[:city].present? && params[:name].blank? && params[:state].blank?
  end

  def invalid
    render json: { errors: [{ detail: "Invalid parameters."}] }, status: :unprocessable_entity
  end
end