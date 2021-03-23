class Player < Struct.new(:name, :location, :purse, :in_penalty_box)
  def initialize(name)
    super(name, 0, 0, false)
  end

  def winner?
    purse >= 6
  end
end
