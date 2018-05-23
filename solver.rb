class Solver
  def initialize(board_string)
    @board = board_from_string(board_string.downcase)
    print_formatted_board
    @dictionaries = {}
    # @dictionaries[""] = %W[min in on no knop mini top lop tall loft].sort
    @dictionaries[""] = File.readlines('dictionary.txt').map(&:chomp) # This file taken from http://www.mieliestronk.com/corncob_lowercase.txt
  end

  def board_from_string(board_string)
    raise "Please provide 16 letters for board" unless board_string.length == 16
    return [board_string[0,4], board_string[4,4], board_string[8,4], board_string[12,4]]
  end

  def print_formatted_board
    puts "*******"
    @board.each do |line|
      puts line.upcase.split("").join(" ")
    end
    puts "*******"
  end

  def neighbor_cells(input_y, input_x)
    cells = []
    3.times do |y|
      y = input_y - 1 + y # start one smaller
      next if y < 0 || y > 3 # off board

      3.times do |x|
        x = input_x - 1 + x # start one smaller
        next if x < 0 || x > 3 # off board

        cells << [y, x] unless y == input_y && x == input_x
      end
    end
    cells
  end

  def neighbor_letters(input_y, input_x)
    neighbor_cells(input_y, input_x).map do |y, x|
      {letter: @board[y][x], position: [y, x]}
    end
  end

  def word_beginning?(string)
    result = false
    string_to_match_against = string.gsub(/q/,"qu")
    prefix = string[0, string.length - 1]
    @dictionaries[prefix].each do |word|
      if word =~ /\A#{string_to_match_against}/
        result = true
        @dictionaries[string] ||= []
        @dictionaries[string] << word
      end

      if word == string_to_match_against
        unless @solutions.include?(string_to_match_against) || word.length <= 2
          @solutions << string_to_match_against
          puts string_to_match_against
        end

        break
      end
    end

    result
  rescue => e
    puts "string: #{string}"
    raise
  end

  def solutions
    @solutions = []
    4.times do |y|
      4.times do |x|
        letter = @board[y][x]
        words(letter, [[y, x]])
      end
    end
    @solutions
  end

  def words(string, path)
    return unless word_beginning?(string)
    neighbor_letters(*path.last).each do |letter_hash|
      next if path.include?(letter_hash[:position])
      new_path = path + [letter_hash[:position]]
      words(string + letter_hash[:letter], new_path)
    end
  end
end

# s = Solver.new("ABCDEFGHIJKLMNOP")
s = Solver.new(ARGV[0])
# puts "*** s.solutions: #{s.solutions}"
s.solutions
# puts "*** s.instance_variable_get(:@dictionaries): #{s.instance_variable_get(:@dictionaries)}"
