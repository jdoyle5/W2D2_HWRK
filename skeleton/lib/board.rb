class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) {Array.new}
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, idx|
      if idx != 6 && idx != 13
        4.times do
          cup << :stone
        end
      end
    end
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" if start_pos < 0 || start_pos > 12
    raise "Invalid starting cup" if @cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    rocks = @cups[start_pos]
    @cups[start_pos] = []

    cup_idx = start_pos

    until rocks.empty?
      cup_idx += 1
      cup_idx = 0 if cup_idx > 13

      @cups[6] << rocks.pop if (current_player_name == @name1 && cup_idx == 6)
      @cups[13] << rocks.pop if (current_player_name == @name2 && cup_idx == 13)
      @cups[cup_idx] << rocks.pop if (cup_idx != 6 && cup_idx != 13)
    end

    render
    next_turn(cup_idx)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].length == 1
      :switch
    else
    ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    if @cups[0..5].all? {|cup| cup.empty?}
      true
    elsif @cups[7..12].all? {|cup| cup.empty?}
      true
    else
      false
    end
  end

  def winner
    player1_rocks = @cups[6].length
    player2_rocks = @cups[13].length

    if player1_rocks == player2_rocks
      :draw
    else
      player1_rocks > player2_rocks ? @name1 : @name2
    end
  end
end
