require 'optparse'
require_relative 'parse_files'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("--min-games=GAMES", "Minimum Games Played") do |v|
    options[:min_games] = v.to_i
  end
  opts.on("--player=PLAYER", "Specific Player") do |v|
    options[:player] = v.to_s
  end
end.parse!

players = ParseFiles.parse

puts "Most Wins with Teammate"
player_pool = players.keys.sort
player_pool.each do |name|
  if options[:player] && name != options[:player]
    next
  end
  teammates = {}
  player = players[name]
  player_pool.each do |teammate_name|
    if name == teammate_name
      next
    end
    teammate = players[teammate_name]
    player.games.each do |game|
      if game.teammates?(name, teammate_name)
        if teammates[teammate_name].nil?
            teammates[teammate_name] = {
                wins: 0,
                losses: 0
            }
        end
        if game.won?(name)
          teammates[teammate_name][:wins] += 1
        elsif game.lost?(name)
          teammates[teammate_name][:losses] += 1
        end
      end
    end
  end
  winning_teammate = teammates.map do |teammate_name, stats|
    [teammate_name, stats[:wins]]
  end.sort do |a, b|
    b.last <=> a.last
  end.first 
  teammate_name = winning_teammate.first
  puts "#{name}: #{teammate_name} (#{teammates[teammate_name][:wins]}-#{teammates[teammate_name][:losses]})"
end
