require "json"
require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = VOWELS.sample(5)
    @letters += (("A".."Z").to_a - VOWELS).sample(5)
    @letters.shuffle!
  end

  def score
    @grid = params[:grid]
    @answer = params[:word].upcase
    grid_validation = included?(@answer, @grid)
    if grid_validation & english_word?(params[:word])
      @result = "The word is valid according to the grid and is an English word"
    elsif grid_validation & !english_word?(params[:word])
      @result = "The word is valid according to the grid, but is not a valid English word"
    else
      @result = "The word can’t be built out of the original grid"
    end
  end

  private

  def included?(word, letters)
    word.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end

end
