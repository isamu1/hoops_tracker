require 'optparse'
require 'csv'
require_relative 'parse_files'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: head_to_head.rb [options]"

  opts.on("--player=PLAYER", "Player to get stats for") do |v|
    options[:player] = v.to_s
  end

  opts.on("--other-player=OTHER_PLAYER", "Other player to get stats for") do |v|
    options[:other_player] = v.to_s
  end
end.parse!

players = ParseFiles.parse

player = players[options[:player]]
other_player = players[options[:other_player]]
if player.nil? || other_player.nil?
  raise "Players not found #{options[:player]}, #{options[:other_player]}"
end

games_with = player.games.select{|game| game.teammates?(player.name, other_player.name)}
games_with_wins = games_with.select{|game| game.won?(player.name)}.count
games_with_losses = games_with.select{|game| game.lost?(player.name)}.count
with = {
  wins: games_with_wins,
  losses: games_with_losses,
  win_perc: (games_with_wins / (games_with_wins + games_with_losses + 0.0)).truncate(3)
}

games_without = player.games.select{|game| !game.teammates?(player.name, other_player.name)}
games_without_wins = games_without.select{|game| game.won?(player.name)}.count
games_without_losses = games_without.select{|game| game.lost?(player.name)}.count
without = {
  wins: games_without_wins,
  losses: games_without_losses,
  win_perc: (games_without_wins / (games_without_wins + games_without_losses + 0.0)).truncate(3)
}

games_against = player.games.select{|game| game.opponents?(player.name, other_player.name)}
games_against_wins = games_against.select{|game| game.won?(player.name)}.count
games_against_losses = games_against.select{|game| game.lost?(player.name)}.count
against = {
  wins: games_against_wins,
  losses: games_against_losses,
  win_perc: (games_against_wins / (games_against_wins + games_against_losses + 0.0)).truncate(3)
}

puts "Stats for #{player.name} with #{other_player.name}"
puts "  As teammates : #{with[:wins]}-#{with[:losses]} (#{with[:win_perc]})"
puts "  Not teammates: #{without[:wins]}-#{without[:losses]} (#{without[:win_perc]})"
puts "  As opponents : #{against[:wins]}-#{against[:losses]} (#{against[:win_perc]})"
