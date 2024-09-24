def stock_picker(arr)
  if arr.length < 2 
    return []
  end 
  
  max_profit = 0
  selected_days = [0,0]
  min = arr[0]

  arr.each_with_index do | price_of_day, day |
    if price_of_day < min 
      min = price_of_day 
    end 

    profit = price_of_day - min 

    if ( profit > max_profit )
      max_profit = profit 
      selected_days = [arr.index(min), day]
    end 
  end 
  selected_days
end 
