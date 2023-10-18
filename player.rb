class Player
  attr_accessor :name
  attr_accessor :games

  def initialize(name)
    @name = name
    @games = []
  end

  def add_game(game)
    @games << game
  end
  
  def get_wins
    @games.select{|game| game.won?(@name)}
  end

  def get_losses
    @games.select{|game| game.lost?(@name)}
  end

  def win_perc
    wins = get_wins.count
    losses = get_losses.count
    win_perc = wins / (wins + losses + 0.0)
    win_perc.truncate(3)
  end

  def weeks_played
    @games.map{|game| game.date}.uniq.sort
  end

  def to_s
    "#{@name} #{win_perc}% (#{get_wins.count}-#{get_losses.count}) - #{weeks_played.count} weeks played"
  end
end
