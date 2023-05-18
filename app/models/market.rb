class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates_presence_of :name, :street, :city, :county, :state, :zip, :lat, :lon
  validates_numericality_of :zip
end