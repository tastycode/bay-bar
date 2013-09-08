class StopGroupMenu < NSMenuItem
  def initialize(title, stops)
    super()
    self.title = title
    @stops = stops
    self.submenu = NSMenu.new
    setupStops
  end

  def setupStops
    @stops.each do |stop|
      next unless stop.direction
      s = StopMenu.new(stop)
      s.action = "selectedItem:"
      s.target = self
      self.submenu.addItem(s)
    end
  end

  def selectedItem(e)
    App.delegate.selectedStop(e.stop)
  end

end