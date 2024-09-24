def caesar_cipher (string, index)
  new_s = ""
  string.split("").map do |char|
    char = char.ord + index
    char = char - 122 if char > 122
    char  += 96 if char < 97
    char = char.chr
    new_s += char
  end 
  new_s
end
