require('colorize')
# Class Coder

# frozen_string_literal: true
class Coder
  def initialize
    @colors = %w[A B C D E F G H I J K L M]
    @code = @colors.sample(5)
  end

  def code
    "#{@code[0]}º#{@code[1]}º#{@code[2]}º#{@code[3]}º#{@code[4]}"
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

  def complete(gcode)
    @code == gcode
  end
end
# Guesser code and methods

# frozen_string_literal: true
class Guesser
  attr_reader :guess_code, :colors

  def initialize
    @colors = %w[A B C D E F G H I J K L M]
    @guess_code = @colors.sample(5)
  end

  def not_found_characters(clues)
    data = []
    clues.each_with_index do |clue, index|
      data.push(@guess_code[index]) if clue == '*'
    end
    data
  end

  def match_characters(clues)
    data = []
    clues.each_with_index do |clue, index|
      data.push(@guess_code[index]) if clue != '*' && clue != '?'
    end
    data
  end

  def match_characters_positions(clues)
    data = []
    clues.each_with_index do |clue, index|
      data.push(index) if clue != '*' && clue != '?'
    end
    data
  end

  def found_positions(clues)
    data = []
    clues.each_with_index do |clue, index|
      data.push(index) if clue == '?'
    end
    data
  end

  def found_characters(clues)
    data = []
    clues.each_with_index do |clue, index|
      data.push(@guess_code[index]) if clue == '?'
    end
    data
  end

  # some work for the not found colors (*)
  def try_guess(clues)
    @colors -= not_found_characters(clues)
    @colors -= match_characters(clues)
    @colors -= found_characters(clues)

    clues.each_with_index do |clue, index|
      next unless clue == '*'

      new_char = @colors.sample(1)
      @guess_code[index] = new_char[0]
      @colors -= new_char
    end
  end

  # some work for the found colors (?)
  def try_found(clues)
    base = [0, 1, 2, 3, 4]
    skip_match = match_characters_positions(clues)
    clues.each_with_index do |clue, index|
      next unless clue == '?'

      possible_positions = base - skip_match - [index]
      rand_position = possible_positions.sample(1)
      curr_value = @guess_code[index]
      @guess_code[index] = @guess_code[rand_position[0]]
      @guess_code[rand_position[0]] = curr_value
    end
  end
end

coder = Coder.new
guesser = Guesser.new
puts "guess_code: #{guesser.guess_code}"

tries = 1
loop do
  puts "\nTry #{tries}"
  clues = coder.get_clues(guesser.guess_code)
  puts "guess_code: #{guesser.guess_code}"
  puts "Clues:#{clues}"

  guesser.try_guess(clues)
  guesser.try_found(clues)

  puts 'Continue? (Y/N)..'
  finished = gets.chomp
  complete = coder.complete(guesser.guess_code)

  puts "Congratulation! you guessed at #{tries} attemps" if complete
  tries += 1
  break if finished.upcase == 'N' || complete
end
