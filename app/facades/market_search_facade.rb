class MarketSearchFacade
  def self.search_markets(name)
    Market.where("name ILIKE ?", "%#{name}%")
  end
end