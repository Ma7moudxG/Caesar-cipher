def bubble_sort(arr)
  swapped = false 

  loop do 
    arr.each_with_index do |num, i|
      if arr[i+1] && num > arr[i+1]
        arr[i], arr[i+1] = arr[i+1], arr[i]
        swapped = true
        break
      end
      if i == arr.length - 2
        swapped = false
        break
      end
    end
    
    if swapped == false
      break
    end
    
  end
  arr
end 
