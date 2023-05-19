class MarketSearchFacade
  def self.search_markets(name, state, city)
    Market.where("name ILIKE ? AND state ILIKE ? AND city ILIKE ?", "%#{name}%", "%#{state}%", "%#{city}%")
  end
end