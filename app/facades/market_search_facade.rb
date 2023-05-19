class MarketSearchFacade
  def self.search_markets(name, state)
    Market.where("name ILIKE ? AND state ILIKE ?", "%#{name}%", "%#{state}%")
  end
end