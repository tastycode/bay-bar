class Stop
  attr_accessor :title, :direction, :lat, :lon, :tag, :stopId

  def initialize(stopData)
    @lat = stopData["lat"]
    @lon = stopData["lon"]
    @stopId = stopData["stopId"]
    @tag = stopData["tag"]
    @title = stopData["title"]
    @direction = stopData["direction"]
    @route = stopData["forRoute"]
  end

  def route
    @route
  end

  def menuTitle
    "#{shortDirection} - #{title}"
  end

  def shortDirection
    direction["name"][/^(?:out|in)/i].capitalize
  end

  def toolTipTitle
    "#{direction["name"]} - #{title}"
  end
end