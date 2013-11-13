class Company

  attr_reader :name, :guests

  def initialize(name, guests)
    @name = name
    @guests = guests
  end

  def guests_not_arrived_yet
    guests.select{|guest| !guest.arrived?}
  end

  def guests_arrived
    guests.select{|guest| guest.arrived?}
  end
end
