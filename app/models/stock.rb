class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  # has_many :transactions
  # has_many :users, through: :transactions

  validates :name, :ticker, presence: true


  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new( publishable_token: Rails.application.credentials.iex[:sandbox_key], 
                                            endpoint: 'https://sandbox.iexapis.com/v1')
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
    rescue => exception
      return nil
    end
  end

  def self.check_db(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.most_active
    client = IEX::Api::Client.new( publishable_token: Rails.application.credentials.iex[:sandbox_key], 
                                            endpoint: 'https://sandbox.iexapis.com/v1')
    Rails.cache.fetch('active_stocks', expires_in: 12.hours) do
    client.stock_market_list(:mostactive)
    end
  end

end

