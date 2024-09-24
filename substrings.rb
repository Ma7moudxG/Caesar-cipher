def substrings(string, dictionary)
  result = Hash.new(0)
  dictionary.each do |word|
    string.downcase.split.each do |word_in_string|
      result[word] += 1 if word_in_string.include?(word)
    end
  end 
  result
end 
