class StopMenu < NSMenuItem
  attr_accessor :stop
  def initialize(stop)
    @stop = stop
    self.title = stop.menuTitle
    self.toolTip = stop.toolTipTitle
  end
end