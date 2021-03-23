class Category < Struct.new(:name, :index)
  alias to_s name

  def initialize(name)
    super(name, -1)
  end

  def next_question
    self.index += 1
    "#{name} Question #{index}"
  end
end
