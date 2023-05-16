require 'rails_helper'

RSpec.describe 'Markets API' do
  describe 'api/v0/markets' do
    it 'this endpoint works' do
      create_list(:market, 5)

      get '/api/v0/markets'

      expect(response).to be_successful
    end
  end
end