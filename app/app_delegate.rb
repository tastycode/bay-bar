class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildStatus
    buildMenuItems
  end

  def buildStatus
    @statusBar = NSStatusBar.systemStatusBar
    @item = @statusBar.statusItemWithLength(NSVariableStatusItemLength)
    @item.retain
    @item.setTitle("Menubar App")
    @item.setHighlightMode(true)
    @item.setMenu(menu)
  end

  def menu
    return @menu if @menu

    @menu = NSMenu.new
    @menu.initWithTitle 'Menubar App'

    #mi = NSMenuItem.new
    #mi.title = 'Hello!'
    #mi.action = 'sayHello:'
    #menu.addItem mi
  end

  def buildMenuItems
    BW::HTTP.get("http://bay-bar.herokuapp.com/?command=routeList&a=sf-muni") do |response|
      result = BW::JSON.parse(response.body)
      @routes = result["body"]["route"].map do |routeData|
        Route.new(routeData)
      end

      @routes.each do |route|
        menu.addItem(NSMenuItem.new.tap do |i|
          i.title = route.title
          subMenu = NSMenu.new
          route.stops do |stopIndex|
            stopGroups = stopIndex.values.group_by(&:title)
            stopGroups.each do |title, stops|
              item = NSMenuItem.new.tap do |gi|
                gi.title = title
                groupSubmenu = NSMenu.new
                stops.each do |stop|
                  groupSubmenu.addItemWithTitle(stop.menuTitle, action: nil, keyEquivalent: "") if stop.direction
                end
                gi.submenu = groupSubmenu
              end
              subMenu.addItem(item)
            end

          end
          i.submenu = subMenu
        end)
      end
    end
    
  end

end
