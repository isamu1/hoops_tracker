require 'optparse'
require 'csv'
require_relative 'parse_files'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: terrific_trios.rb [options]"

  opts.on("--min-games=NUM_GAMES", "Number of games played as a duo") do |v|
    options[:min_games] = v.to_s
  end

  opts.on("--worst", "Sort by least dynamic") do |v|
    options[:worst] = true
  end
end.parse!

players = ParseFiles.parse

def calculate_win_perc(player, other_player, third_player)
  games_with = player.games.select { |game| game.teammates?(player.name, other_player.name) && game.teammates?(player.name, third_player.name) }
  games_with_wins = games_with.select { |game| game.won?(player.name) }.count
  games_with_losses = games_with.select { |game| game.lost?(player.name) }.count
  win_perc = ((games_with_wins / (games_with_wins + games_with_losses + 0.0)) * 100).truncate(3)
  { wins: games_with_wins, losses: games_with_losses, win_perc: win_perc, games_played: games_with_wins + games_with_losses }
end

trios = []

players.keys.combination(3) do |player_name, other_player_name, third_player_name|
  player = players[player_name]
  other_player = players[other_player_name]
  third_player = players[third_player_name]

  stats = calculate_win_perc(player, other_player, third_player)
  next if stats[:games_played] < options[:min_games].to_i
  trios << { player: player_name, other_player: other_player_name, third_player: third_player_name, stats: stats }
end

trios.sort_by! { |trio| -trio[:stats][:win_perc] }

puts "Ranked list of trios by win percentage min #{options[:min_games]} games played:"
puts ["rank", "player 1", "player 2", "player 3", "win%", "W-L"].join(',')
trios.each_with_index do |trio, index|
  puts [index + 1, trio[:player], trio[:other_player], trio[:third_player], "#{trio[:stats][:win_perc]}%", "#{trio[:stats][:wins]}-#{trio[:stats][:losses]}"].join(',')
end
