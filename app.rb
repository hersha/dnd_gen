require 'sinatra/base'

class App < Sinatra::Base
  CLASSES = %w(Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard)
  RACES = %w(Dwarf Elf Halfling Human Dragonborn Gnome Half-Elf Half-Orc Tiefling Goliath Genasi)
  GENDER = %w(Male Female)
  ALIGNMENT_X = ["Lawful", "Chaotic"]
  ALIGNMENT_Y = %w(Good Neutral Evil)

  def stat_roll
	rolls = 4.times.map { |r| rand(6) + 1}.sort
	sum = rolls[1..-1].reduce(:+)
  end

  def stats
	@stats ||= [0]
	until @stats.reduce(:+) > 67
	  @stats = 6.times.map { |r| stat_roll }.sort
	end
	@stats
  end

  def generate
	@stats = nil
	@klass = CLASSES.sample
	@race = RACES.sample
	@gender = GENDER.sample
	@alignment = [ALIGNMENT_X.sample, ALIGNMENT_Y.sample].compact.join(" ")
	stats
  end

  set :public_folder, 'public'

  get '/' do
	@stats = nil
	@klass = CLASSES.sample
	@race = RACES.sample
	@gender = GENDER.sample
	@alignment = [ALIGNMENT_X.sample, ALIGNMENT_Y.sample].compact.join(" ")
	stats
	erb :index
  end
end
