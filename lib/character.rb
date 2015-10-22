require 'json'

class Character
  CLASSES = %w(Barbarian Bard Cleric Druid Fighter Monk Paladin Ranger Rogue Sorcerer Warlock Wizard)
  RACES = %w(Dwarf Elf Halfling Human Dragonborn Gnome Half-Elf Half-Orc Tiefling Goliath Genasi)
  GENDER = %w(Male Female)
  ALIGNMENT_X = ["Lawful", "Chaotic"]
  ALIGNMENT_Y = %w(Good Neutral Evil)

  attr_reader :klass, :race, :gender, :alignment, :sanity

  def initialize
    @klass = CLASSES.sample 
    @race = RACES.sample
    @gender = GENDER.sample
    @alignment = [ALIGNMENT_X.sample, ALIGNMENT_Y.sample].compact.join(" ")
    @sanity = stat_roll
    stats
  end

  def stat_roll
    rolls = 4.times.map { |r| rand(6) + 1}.sort
    sum = rolls[1..-1].reduce(:+)
  end

  def stats
    @stats ||= 6.times.map { |r| stat_roll }.sort
  end

  def to_json
    {
      klass:     @klass,
      race:      @race,
      gender:    @gender,
      alignment: @alignment,
      sanity:    @sanity,
      stats:     @stats
    }.to_json
  end

end
