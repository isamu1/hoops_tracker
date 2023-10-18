require_relative 'parse_files'

players = ParseFiles.parse

puts "Wins leaderboard"
sorted_winners = players.map do |_, player|
  [player, player.get_wins.count]
end.sort do |a, b|
  b.last <=> a.last
end.each_with_index do |player_wins, i|
  player = player_wins.first
  wins = player_wins.last
  puts "#{i+1}) #{player.name}: #{wins} (#{wins}-#{player.get_losses.count})"
end