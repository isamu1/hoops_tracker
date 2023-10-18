require 'optparse'
require_relative 'parse_files'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("--min-games=GAMES", "Minimum Games Played") do |v|
    options[:min_games] = v.to_i
  end
end.parse!

players = ParseFiles.parse

puts "Win % leaderboard"
sorted_winners = players.map do |_, player|
  wins = player.get_wins.count
  losses = player.get_losses.count
  total = wins + losses
  win_perc = wins / (total + 0.0)
  [player, win_perc.truncate(3)]
end.select do |player, win_perc|
  !(options[:min_games] && player.games.count < options[:min_games])
end.sort do |a, b|
  b.last <=> a.last
end.each_with_index do |player_win_perc, i|
  player = player_win_perc.first
  win_perc = player_win_perc.last
  puts "#{i+1}) #{player.name}: #{win_perc} (#{player.get_wins.count}-#{player.get_losses.count})"
end
