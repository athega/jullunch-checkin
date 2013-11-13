class Guest
  attr_reader :name, :token
  def initialize(guest)
    @guest = guest
  end

  def name
    @guest[:name]
  end

  def token
    @guest[:token]
  end

  def arrived?
    @guest[:arrived] == true
  end
end
