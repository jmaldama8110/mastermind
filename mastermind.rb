require('colorize')
# Class Coder

# frozen_string_literal: true
class Coder
  def initialize
    @colors = %w[A B C D E F G H I J K L M]
    @code = @colors.sample(5)
  end

  private

  def get_not_found_positions(harray)
    not_found = []
    harray.each_with_index do |value, index|
      data = @code.select { |item| item == value }
      not_found.push(index) if data.empty?
    end
    not_found
  end

  def get_found_positions(harray)
    found = []
    harray.each_with_index do |value, index|
      @code.each_with_index do |code, position|
        found.push(index) if code == value && position != index
      end
    end
    found
  end

  def get_match_positions(harray)
    match = []
    harray.each_with_index do |value, index|
      @code.each_with_index do |code, position|
        match.push(index) if code == value && position == index
      end
    end
    match
  end

  public

  def get_clues(harray)
    clues = ['*', '*', '*', '*', '*']
    # * the color is not found
    # ? is found but not the right position
    # LETTER when match position and color are guessed
    get_match_positions(harray).each { |match| clues[match] = harray[match] }
    get_not_found_positions(harray).each { |not_found| clues[not_found] = '*' }
    get_found_positions(harray).each { |found| clues[found] = '?' }
    clues
  end
end
# Guesser code and methods
# 
# frozen_string_literal: true
class Guesser < Coder
  def guess_code
    @colors.sample(5)
  end
end

coder = Coder.new
guesser = Guesser.new

guesser.code


# i = 1
# loop do
#   guess_code = []
#   while guess_code.length != 5
#     puts "Turn #{i} - Entre color sequence:"
#     guess_code = gets.chomp.upcase.split('')
#   end
#   clues = coder.get_clues(guess_code)
#   if clues != guess_code
#     puts "You tried:  #{guess_code} -> clue: #{clues}"
#     i += 1
#   else
#     puts "Congratulations! you guessed the code #{guess_code}"
#     i = 12
#   end
#   break if i == 12
# end
