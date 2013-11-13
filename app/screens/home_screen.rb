class HomeScreen < PM::TableScreen
  title "Företag"

  def on_load
    fetch_from_server
  end

  def fetch_from_server
    client = HttpClient.new
    client.get_companies do |companies|
      @table_data = [{
        title: "",
        cells: companies.map do |company|
          {
            title: company.name,
            action: :tapped_company,
            arguments: { company: company }
          }
        end
      }]
      update_table_data
    end
  end

  def on_present
    @view_setup ||= self.set_up_view
  end

  def set_up_view
    set_attributes self.view, {
      background_color: UIColor.whiteColor
    }
    true
  end

  def table_data
    @table_data || {}
  end

  def tapped_company(args={})
    open CompanyScreen.new(nav_bar: true, company: args[:company])
  end

end
