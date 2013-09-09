class Route
  attr_accessor :tag, :title

  def initialize(routeData)
    @tag = routeData["tag"]
    @title = routeData["title"]
  end

  def stops(&block)
    BW::HTTP.get("http://bay-bar.herokuapp.com/?command=routeConfig&a=sf-muni&r=#{tag}") do |response|
      if response.ok?
        @json = BW::JSON.parse(response.body)
        @indexedStops = {}
        rawStops = @json["body"]["route"]["stop"]
        rawStops.each do |stop|
          @indexedStops[stop["tag"]] = stop
        end
        buildStops
        block.call(@stops)
      else
        puts "Response not okay"
      end
    end
  end

  def buildStops
    return @stops if @stops
    @stops = []
    @json["body"]["route"]["direction"].each do |direction|
      tags = direction["stop"].collect {|s| s["tag"]}
      tags.each do |tag|
        currentStop = @indexedStops[tag]
        currentStop["direction"] = {
          "name" => direction["name"],
          "title" => direction["title"]
        }
        currentStop["forRoute"] = {
          "tag" => @tag,
          "title" => @title
        }
        @stops << Stop.new(currentStop)
      end
    end
  end  
end