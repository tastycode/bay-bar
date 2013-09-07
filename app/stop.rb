class Stop
  attr_accessor :title, :direction, :lat, :lon, :tag, :stopId

  def initialize(stopData)
    @lat = stopData["lat"]
    @lon = stopData["lon"]
    @stopId = stopData["stopId"]
    @tag = stopData["tag"]
    @title = stopData["title"]
    @direction = stopData["direction"]
  end

  def menuTitle
    "#{direction["name"]} - #{title}"
  end
end
