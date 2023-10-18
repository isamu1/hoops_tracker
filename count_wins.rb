require 'optparse'
require 'csv'
require_relative 'parse_files'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("--min-weeks=WEEKS", "Minimum Weeks Played") do |v|
    options[:min_weeks] = v.to_i
  end
end.parse!

players = ParseFiles.parse

min_weeks = options[:min_weeks] || 0
if min_weeks > 0
  puts "Minimum weeks: #{min_weeks}"
end


eligible_players = players.values.select{|player| player.weeks_played.count >= min_weeks}

puts "Wins leaderboard"
sorted_winners = eligible_players.map do |player|
  [player, player.get_wins.count]
end.sort do |a, b|
  b.last <=> a.last
end.each_with_index do |player_wins, i|
  player = player_wins.first
  wins = player_wins.last
  puts "#{i+1}) #{player.name}: #{wins} (#{wins}-#{player.get_losses.count})"
end

# add a new line
puts

puts "Win % leaderboard"
sorted_winners = eligible_players.map do |player|
  [player, player.win_perc]
end.sort do |a, b|
  b.last <=> a.last
end.each_with_index do |player_win_perc, i|
  player = player_win_perc.first
  win_perc = player_win_perc.last
  puts "#{i+1}) #{player.name}: #{win_perc} (#{player.get_wins.count}-#{player.get_losses.count})"
end
