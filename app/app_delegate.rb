class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildStatus
    buildMenuItems
    if tag = App::Persistence['selectedStop']
      @selectedStop = Stop.new(route: {"tag" => tag})
      getPredictions
    else
      @selectedStop = nil
    end
  end

  def buildStatus
    @statusBar = NSStatusBar.systemStatusBar
    @item = @statusBar.statusItemWithLength(NSVariableStatusItemLength)
    @item.retain
    @item.setTitle("🚌 Bay Bar - Muni")
    @item.setHighlightMode(true)
    @item.setMenu(menu)
  end

  def menu
    return @menu if @menu

    @menu = NSMenu.new
  end

  def buildMenuItems
    BW::HTTP.get("http://bay-bar.herokuapp.com/?command=routeList&a=sf-muni") do |response|
      result = BW::JSON.parse(response.body)
      @routes = result["body"]["route"].map do |routeData|
        Route.new(routeData)
      end

      @routes.each do |route|
        menu.addItem RouteMenu.new(route)
      end
    end
  end

  def selectedStop(stop)
    @selectedStop = stop
    App::Persistence['selectedStop-route-tag'] = @selectedStop.route["tag"]
    setTitleMetadata("...")
    @timer.invalidate if @timer
    getPredictions
    @timer = NSTimer.scheduledTimerWithTimeInterval(45, target:self, selector:'getPredictions', userInfo:nil, repeats:true)
  end

  def setTitleMetadata(metadata)
    @item.title = "🚌 #{@selectedStop.topTitle} - #{metadata}"
    @item.toolTip = "🚌 #{@selectedStop.topToolTipTitle} - #{metadata}"
  end

  def getPredictions
    BW::HTTP.get("http://bay-bar.herokuapp.com/?command=predictions&a=sf-muni&stopId=#{@selectedStop.stopId}&routeTag=#{@selectedStop.route["tag"]}") do |response|
      result = BW::JSON.parse(response.body)
      predictions = if result["body"]["predictions"]["direction"].kind_of? Array
        rawPrediction = result["body"]["predictions"]["direction"].first do |direction|
          direction["title"] == @seleectedStop.direction["title"]
        end["prediction"]
        rawPrediction.kind_of?(Array) ? rawPrediction : [rawPrediction]
      else
        result["body"]["predictions"]["direction"]["prediction"]
      end
      times = predictions.map {|x| x["minutes"]}[0..2].join(", ")
      setTitleMetadata(times)
    end

  end

end