require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ("A".."Z").to_a.shuffle.take(10)
  end

  def score
    @guess = params[:guess]
    @letters = params[:letters]

    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    response = open(url).read
    data = JSON.parse(response)

    in_the_grid = word_include_other?(@letters, @guess)

    if data['found'] == true && in_the_grid
      @newScore = "Congratulations! #{@guess} is a valid English word! "
    elsif !in_the_grid
      @newScore = "Sorry, #{@guess} can't be built out of #{@letters} "
    else
      @newScore = "Sorry, #{@guess} does not seem to be a valid English word..."
    end
  end

  def word_include_other?(grid, word)
    word_count = word.downcase.chars.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    grid_count = grid.downcase.chars.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
    sum = 0
    word_count.each do |my_key, my_value|
      if grid_count.key?(my_key) && grid_count[my_key] >= my_value
        sum += 0
      else
        sum += 1
      end
    end
    p sum
    return true if sum.zero?
  end
end
