FactoryBot.define do
    factory :user do
      email { 'test@test.com' }
      password { 'password' }
      confirmed_at { DateTime.now }
      status { true }
      association :role
    end

     
    factory :role do
        name { 'Trader' }
    end
    
  
    factory :stock do
      ticker { 'AAPL' }
      name { 'Apple' }
      last_price { 200 }
    end
  
    factory :trade do
      user_stock_id { 1 }
      quantity { 10 }
      trade_type { 'buy' }
      total_price { 2000 }
      association :user
      association :user_stock
    end
  
    factory :user_stock do
      user_id { 1 }
      stock_id { 1 }
      stock_quantity { 10 }
      association :user
      association :stock
    end
  end