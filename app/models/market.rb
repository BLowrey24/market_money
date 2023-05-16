class Market < ApplicationRecord
  before_save { |market| market.vendor_count = count_of_vendors}
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  private

  def count_of_vendors
    vendors.count
  end
end