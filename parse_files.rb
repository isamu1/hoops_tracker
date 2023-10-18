require 'csv'
require_relative 'player'
require_relative 'game'

class ParseFiles
 
FILE_PREFIX = "Wallingford Hoops - "
NON_PLAYERS = ["Adds up?","Winners","Losers"]

  def self.parse
    files = Dir.entries("./data").map{|f| "./data/#{f}"}.select{|f| File.file? f} 
    puts "Aggregating data from #{files.count} weeks"
    puts "Data current through: #{files.last.split.last.split(".").first}"
    
    games = {}
    players = {}
    
    files.each do |file|
      date = file.split(FILE_PREFIX).last.split(".").first
    
      week_games = []
      100.times {|i| week_games << nil}
      games[date] = week_games
    
      header_seen = false
      CSV.foreach(file, skip_blanks: true, ) do |line|
        if !header_seen
          header_seen = true
          next
        end
        player = nil
        line.each_with_index do |val, i|
          if i == 0
            name = val
            if name.nil? || NON_PLAYERS.include?(name)
             break
            end
            name = name.strip
            if players[name].nil?
              players[name] = Player.new(name)
            end
            player = players[name]
          elsif i == 1 || i == 2
            next
          else
            if !val.nil?
              game_number = i-2 # skip 3 columns for the first game
              if week_games[game_number].nil?
                week_games[game_number] = Game.new(date, game_number)
              end
    
              game = week_games[game_number]
              player.add_game(game)
    
              if val == 'W'
                game.add_winner(player.name)
              elsif val == 'L'
                game.add_loser(player.name)
              end
            end
          end
        end
      end
      week_games.compact!
    end
    players
  end
end
