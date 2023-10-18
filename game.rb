class Game
  attr_accessor :date
  attr_accessor :game_number
  attr_accessor :winners
  attr_accessor :losers

  def initialize(date, game_number)
    @date = date
    @game_nubmer = game_number
    @winners = []
    @losers = []
  end

  def add_winner(player_name)
    @winners << player_name
  end

  def add_loser(player_name)
    @losers << player_name
  end

  def is_valid?
    errors = []
    if @winners.count != 5 
      errors << "Wrong number of winners (#{@winners.count})"
    end
    if @losers.count != 5 
      errors << "Wrong number of winners (#{@losers.count})"
    end

    overlap = ((@winners - @losers) + (@losers - @winners)).uniq
    if overlap.count > 0
      errors << "Overlap in winners and losers: #{overlap}"
    end
    errors.count == 0
  end

  def played?(player)
    @winners.include?(player) || @losers.include?(player)
  end

  def won?(player)
    @winners.include?(player)
  end

  def lost?(player)
    @losers.include?(player)
  end

  def teammates?(player_a, player_b)
    (won?(player_a) && won?(player_b)) || 
      (lost?(player_a) && lost?(player_b))
  end

  def opponents?(player_a, player_b)
    (won?(player_a) && lost?(player_b)) || 
      (lost?(player_a) && won?(player_b))
  end

  def to_s
    "Week: #{@date} Game: #{@game_nubmer}\n" \
    "  Winners: #{@winners.join(", ")}\n" \
    "  Losers: #{@losers.join(", ")}"
  end
end