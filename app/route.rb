class Route
  attr_accessor :tag, :title

  def initialize(routeData)
    @tag = routeData["tag"]
    @title = routeData["title"]
    @indexedStops = {}
  end

  def stops(&block)
    BW::HTTP.get("http://bay-bar.herokuapp.com/?command=routeConfig&a=sf-muni&r=#{tag}") do |response|
      if response.ok?
        json = BW::JSON.parse(response.body)
        indexedStops = {}
        stops = json["body"]["route"]["stop"]
        stops.each do |stop|
          indexedStops[stop["tag"]] = stop
        end

        p indexedStops.keys
        # parse directions
        json["body"]["route"]["direction"].each do |direction|
          tags = direction["stop"].collect {|s| s["tag"]}
          tags.each do |tag|
            indexedStops[tag]["direction"] = {
              "name" => direction["name"],
              "title" => direction["title"]
            }
          end
        end
         
        indexedStops.each do |key, stop|
          indexedStops[key] = Stop.new(stop)
        end

        p indexedStops.values.first

        @indexedStops = indexedStops

        block.call(indexedStops)
      else
        puts "Response not okay"
      end
    end
  end

  
end
