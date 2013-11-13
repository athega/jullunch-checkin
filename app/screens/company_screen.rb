class CompanyScreen < PM::TableScreen
  attr_accessor :company

  def on_load
    self.title = @company.name
  end

  def table_data
    [{
      title: "",
      cells: @company.guests_not_arrived_yet.map do |guest|
          {
            title: guest.name,
            action: :check_in,
            arguments: {guest: guest}
          }
        end
    },
      {
      title: "Redan incheckade",
      cells: @company.guests_arrived.map do |guest|
          {
            title: guest.name
          }
      end
      }
    ]
  end

  def check_in(args ={})
    open CheckInScreen.new(nav_bar: true, guest: args[:guest])
  end
end
