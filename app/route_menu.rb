class RouteMenu < NSMenuItem
  attr_reader :route

  def initialize(route)
    @route = route
    super()
    self.title = route.title
    self.submenu = NSMenu.new
    fetchStops  
  end

  def fetchStops
    route.stops do  |stops|
      stopGroups = stops.group_by(&:title)
      stopGroups.each do |title, groupStops|
        self.submenu.addItem(StopGroupMenu.new(title, groupStops))
      end
    end
  end
end