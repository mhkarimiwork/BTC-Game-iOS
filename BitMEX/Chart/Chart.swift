//
//  Chart.swift
//  BitMEX
//
//  Created by Behnam Karimi on 7/1/1398 AP.
//  Copyright © 1398 AP Behnam Karimi. All rights reserved.
//

import UIKit

class Chart: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Properties
    var candles = [Candle]()
    var valueBarWidth: CGFloat {
        get {
            return valueBarWidthConstraint.constant
        }
        set {
            valueBarWidthConstraint.constant = ((newValue >= 40 ) ? newValue : 40.0)
        }
    }
    var visibleCandles = [Candle]()
    
    
    var priceView: PriceView?
    var bottomViews: UIView?
    var timeView: TimeView?
    var valueBars: UIView?
    var gridView: GridView?
    var indicatorViews = [IndicatorView]()
    var drawerBar: DrawerBar!
    weak var valueBarWidthConstraint: NSLayoutConstraint!
    weak var priceViewHeightConstraint: NSLayoutConstraint!
    weak var drawerBarHeightConstraint: NSLayoutConstraint!
    weak var priceTracker: PriceTracker?
    weak var crosshair: Crosshair?
    weak var settingsView: ChartSettings!
    
    var app: App!
    
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            app = delegate.app
        }
        webSocket = RealTime.startWebSocket()
        backgroundColor = app.settings.chartBackgroundColor
    }
    
    
    
    
    
    //MARK: - Public Methods
    func setupChart() {
        webSocket?.open()
        RealTime.unscubscribeAll()
        priceTracker?.isEnabled = false
        newestCandleX = bounds.width * 0.75
        if drawerBar.isMainMenuShowing {
            let saved = drawerBar.animationDuration
            drawerBar.animationDuration = 0.01
            drawerBar.toggleMenu()
            drawerBar.animationDuration = saved
        } else if drawerBar.isSubMenuShowing {
            let saved = drawerBar.animationDuration
            drawerBar.animationDuration = 0.01
            drawerBar.toggleSubmenu()
            drawerBar.animationDuration = saved
        }
        
        self.isUserInteractionEnabled = false
        self.alpha = 0.2
        
        
        if let instrument = instrument {
            Candle.downloadFor(timeframe: timeframe!, instrument: instrument, partialCandle: true, reverse: true, count: 750) { (opCandles, opResponse, opError) in
                guard opError == nil else {
                    print("ERROR!")
                    return
                }
                guard opResponse != nil else {
                    print("No Response!")
                    return
                }
                if let response = opResponse as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let c = opCandles {
                            self.candles = c
                            DispatchQueue.main.async {

                                self.setupSubViews()
                                self.redraw()


                            }
                        } else {
                            print("BAD Data from server!")
                            return
                        }
                    } else {
                        print("\n\n")
                        print(response.statusCode)
                        print("\n\n")
                        print(response.description)
                        return
                    }
                } else {
                    print("BAD Response!")
                    return
                }
                
            }
        }
        
    }
    
    
    private func setupSubViews() {
        //MARK: CleanUp:
        priceTracker?.isEnabled = false
        isDownloadingOlderCandles = false
        CHARTSHOULDNOTBEREDRAWN = false
        for iv in indicatorViews {
            if iv.indicator.getRow() > 0 {
                iv.valueBar.removeFromSuperview()
            }
            iv.removeFromSuperview()
        }
        priceView?.valueBar?.removeFromSuperview()
        for indicator in indicators {
            indicator.computeValue(candles: candles)
        }
        valueBarWidth = 40
        indicatorViews.removeAll()
        priceViewHeightConstraint.constant = self.bounds.height - timeView!.bounds.height
        self.alpha = 1.0
        
        priceView?.valueBar = ValueBar(chart: self, highestValue: Decimal(candles[0].high), lowestValue: Decimal(candles[0].low), tickSize: Decimal(instrument!.tickSize!), topMargin: self.topMargin, bottomMargin: self.bottomMargin, logScale: logScale)
        
        var frameHeights = [CGFloat]()
        for indicator in indicators {
            if indicator.getRow() > 0 {
                frameHeights.append(CGFloat(indicator.getHeight()) * (self.bounds.height - timeView!.bounds.height) / 100.0)
            } else {
                frameHeights.append(0.0)
            }
        }
        var sum: CGFloat = 0
        for h in frameHeights {
            sum += h
        }
        let priceViewHeight = (self.bounds.height - timeView!.bounds.height) - sum
        priceViewHeightConstraint.constant = priceViewHeight
        
        valueBars!.addSubview(self.priceView!.valueBar!)
        priceView!.valueBar!.translatesAutoresizingMaskIntoConstraints = false
        priceView!.valueBar!.topAnchor.constraint(equalTo: valueBars!.topAnchor).isActive = true
        priceView!.valueBar!.leadingAnchor.constraint(equalTo: valueBars!.leadingAnchor).isActive = true
        priceView!.valueBar!.trailingAnchor.constraint(equalTo: valueBars!.trailingAnchor).isActive = true
        priceView!.valueBar!.heightAnchor.constraint(equalToConstant: priceViewHeight).isActive = true
        
        
        for i in 0 ..< indicators.count {
            let indicator = indicators[i]
            let indicatorView = IndicatorView(chart: self, indicator: indicator)
            
            
            if indicator.getRow() == 0 {
                insertSubview(indicatorView, at: 0)
                indicatorView.translatesAutoresizingMaskIntoConstraints = false
                indicatorView.trailingAnchor.constraint(equalTo: priceView!.trailingAnchor).isActive = true
                indicatorView.leadingAnchor.constraint(equalTo: priceView!.leadingAnchor).isActive = true
                if indicator.isSystemIndicator() && indicator.name.lowercased() == Indicator.SystemName.volume.rawValue.lowercased() {
                    indicatorView.heightAnchor.constraint(equalTo: priceView!.heightAnchor, multiplier: 0.2).isActive = true
                } else {
                    indicatorView.topAnchor.constraint(equalTo: priceView!.topAnchor).isActive = true
                }
                indicatorView.bottomAnchor.constraint(equalTo: priceView!.bottomAnchor).isActive = true
            } else {
                bottomViews!.addSubview(indicatorView)
                
                indicatorView.translatesAutoresizingMaskIntoConstraints = false
                indicatorView.trailingAnchor.constraint(equalTo: bottomViews!.trailingAnchor).isActive = true
                indicatorView.leadingAnchor.constraint(equalTo: bottomViews!.leadingAnchor).isActive = true
                if indicator.getRow() == 1 {
                    indicatorView.topAnchor.constraint(equalTo: bottomViews!.topAnchor).isActive = true
                } else {
                    indicatorView.topAnchor.constraint(equalTo: indicatorViews.last!.bottomAnchor).isActive = true
                }
                indicatorView.heightAnchor.constraint(equalToConstant: frameHeights[i]).isActive = true
                
                valueBars!.addSubview(indicatorView.valueBar)

                indicatorView.valueBar.translatesAutoresizingMaskIntoConstraints = false
                if indicator.getRow() == 1 {
                    indicatorView.valueBar.topAnchor.constraint(equalTo: priceView!.valueBar!.bottomAnchor).isActive = true
                } else {
                    indicatorView.valueBar.topAnchor.constraint(equalTo: indicatorViews.last!.valueBar.bottomAnchor).isActive = true
                }
                indicatorView.valueBar.leadingAnchor.constraint(equalTo: valueBars!.leadingAnchor).isActive = true
                indicatorView.valueBar.trailingAnchor.constraint(equalTo: valueBars!.trailingAnchor).isActive = true
                indicatorView.valueBar.heightAnchor.constraint(equalToConstant: frameHeights[i]).isActive = true

            }
            indicatorViews.append(indicatorView)
            
        }
        
        
        drawerBar.isHidden = false
        self.isUserInteractionEnabled = true

        priceTracker?.isEnabled = true
        startTradeWebsocket()
        redraw()
    }
    
    
    
    func redraw() {
        if CHARTSHOULDNOTBEREDRAWN { return }
        self.priceView?.processVisibleCandles()
        self.priceView?.redraw()
        self.timeView?.redraw()
        self.priceView?.valueBar?.redraw(newhighestValue: Decimal(self.highestPrice), newLowestValue: Decimal(self.lowestPrice), logScale: self.logScale)
        self.indicatorViews.forEach { (iv) in
            iv.redraw()
        }
        self.gridView?.redraw()
        self.crosshair?.redraw()
        self.priceTracker?.redraw()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
    
    //MARK: Download Older Candles
    var isDownloadingOlderCandles = false
    var CHARTSHOULDNOTBEREDRAWN = false
    func downloadOlderCandles() {
        if isDownloadingOlderCandles {
            return
        }
        isDownloadingOlderCandles = true
        
        if let instrument = instrument {
            Candle.downloadFor(timeframe: timeframe!, instrument: instrument, partialCandle: true, reverse: true, count: 750, endTime: candles.last!.openTime.bitMEXString()) { (opCandles, opResponse, opError) in
                guard opError == nil else {
                    print("ERROR!")
                    return
                }
                guard opResponse != nil else {
                    print("No Response!")
                    return
                }
                if let response = opResponse as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let c = opCandles {
                            DispatchQueue.main.async {
                                if c.isEmpty { return }
                                self.CHARTSHOULDNOTBEREDRAWN = true
                                
                                self.candles.append(contentsOf: c)
                                for indicator in self.indicators {
                                    indicator.computeValue(candles: self.candles.reversed())
                                }
                                self.isDownloadingOlderCandles = false
                                self.CHARTSHOULDNOTBEREDRAWN = false
                                self.redraw()
                                
                                

                            }
                        } else {
                            print("BAD Data from server!")
                            return
                        }
                    } else {
                        print("\n\n")
                        print(response.statusCode)
                        print("\n\n")
                        print(response.description)
                        return
                    }
                } else {
                    print("BAD Response!")
                    return
                }
                
            }
        }
    }
    
    
    
    //MARK: - Websocket
    var webSocket: WebSocket?
    
    func startTradeWebsocket() {
        let  _ = RealTime.subscribe(subscription: RealTime.Subscriptions.trade, symbol: instrument?.symbol)
        webSocket?.event.message = { msg in
            guard let message = msg as? String  else {
                return
            }
            guard let data = message.data(using: .utf8) else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let table = json["table"] as? String {
                        switch table {
                        case "trade":
                            if let tradeData = json["data"] as? [[String: Any]] {
                                let trades = Trade.processJSONString(tradeData)
                                var volume: Double = 0
                                var high: Double = -Double.greatestFiniteMagnitude
                                var low: Double = Double.greatestFiniteMagnitude
                                var close: Double = 0
                                var _closeTime: Date?
                                for i in 0 ..< trades.count {
                                    let trade = trades[i]
                                    if trade.symbol != self.instrument!.symbol { continue }
                                    
                                    if let v = trade.size {
                                        volume += v
                                    }
                                    if let c = trade.price {
                                        close = c
                                    }
                                    if close > high {
                                        high = close
                                    }
                                    if close < low {
                                        low = close
                                    }
                                    if let ct = Date.fromBitMEXString(str: trade.timestamp) {
                                        _closeTime = ct
                                    }
                                }
                                guard let closeTime = _closeTime else { return }
                                
                                if closeTime.toMillis() < self.candles.first!.nextCandleOpenTime().toMillis() {
                                    let candle = self.candles.first!
                                    candle.volume += volume
                                    candle.close = close
                                    if low < candle.low {
                                        candle.low = low
                                    }
                                    if high > candle.high {
                                        candle.high = high
                                    }
                                } else {
                                    let candle = Candle(open: self.candles.first!.close, close: close, high: high, low: low, volume: volume, timeframe: self.timeframe!, closeTime: self.candles.first!.nextCandleOpenTime().dateBy(adding: self.timeframe!))
                                    self.candles.insert(candle, at: 0)
                                }
                                self.indicators.forEach { (indicator) in
                                    indicator.computeValue(candles: self.candles.reversed())
                                }
                                DispatchQueue.main.async {
                                    self.redraw()
                                }
                            }
                        default:
                            break
                        }
                    }
                    
                }
            } catch {
            }
        }
    }

    
    //MARK: - Handle Touches
    
    //MARK: Tap
    @IBAction func handleTap(_ recognizer: UITapGestureRecognizer) {
        if crosshair!.isEnabled {
            let location = recognizer.location(in: crosshair!)
            if priceView!.frame.contains(location) || bottomViews!.frame.contains(location) {
                crosshair!.isEnabled = false
                redraw()
            }
        }
    }
    
    
    //MARK: Pan
    
    
    private var panBeganNewestX: CGFloat = 0
    private var panBeganHighestPrice: Double = 0
    private var panBeganLowestPrice: Double = 0
    private var pinchBeganBlockWidth: CGFloat = 4
    private var panBeganLocation: CGPoint = .zero
    
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let tr = recognizer.translation(in: self)
        let dx = tr.x
        let dy = tr.y
        
        
        switch recognizer.state {
        case .began:
            panBeganLocation = recognizer.location(in: self)
            panBeganNewestX = newestCandleX
            panBeganLowestPrice = lowestPrice
            panBeganHighestPrice = highestPrice
            pinchBeganBlockWidth = blockWidth
            
            let loc = panBeganLocation.applying(CGAffineTransform(translationX: -valueBars!.frame.origin.x, y: -valueBars!.frame.origin.y))
            if priceView!.valueBar!.frame.contains(loc) {
                autoScale = false
                drawerBar.setButtonStyle(drawerBar.autoButton)
                redraw()
            }
        case .changed:
            if priceView!.frame.contains(panBeganLocation) || bottomViews!.frame.contains(panBeganLocation) {
                
                //Panning PriceView or IndicatorViews:
                
                
                if !crosshair!.isEnabled {
                    let newNewestCandleX = panBeganNewestX + dx
                    if !(newNewestCandleX > 0) {
                        return
                    }
                    let newOldestCandleX = newNewestCandleX - blockWidth * CGFloat(candles.count)
                    if newOldestCandleX >= priceView!.bounds.width {
                        return
                    }
                    
                    newestCandleX = newNewestCandleX
                    if !autoScale {
                        let d = Double(dy / bounds.height)
                        let priceDy = (panBeganHighestPrice - panBeganLowestPrice) * d
                        highestPrice = panBeganHighestPrice + priceDy
                        lowestPrice = panBeganLowestPrice + priceDy
                    }
                    redraw()
                } else {
                    var newY = crosshair!.initialPosition.y + dy
                    let n = Int(dx / blockWidth)
                    var newX = crosshair!.initialPosition.x + CGFloat(n) * blockWidth
                    if !(newX <= priceView!.bounds.width && newX >= 0) {
                        newX = crosshair!.position.x
                    }
                    if !(newY >= 0 && newY < timeView!.frame.origin.y) {
                        newY = crosshair!.position.y
                    }
                    crosshair!.position = CGPoint(x: newX, y: newY)
                    redraw()
                }
            } else if timeView!.frame.contains(panBeganLocation) {
                
                //Panning TimeView
                
                let scale = 1 - 2 * dx / timeView!.bounds.width
                if pinchBeganBlockWidth * scale < 0.2 { blockWidth = 0.2; return }
                blockWidth = pinchBeganBlockWidth * scale
                
                redraw()
            } else if valueBars!.frame.contains(panBeganLocation) {
                
                
                //Panning ValueBars
                
                let locationInDrawerBar = panBeganLocation.applying(CGAffineTransform(translationX: -drawerBar.frame.origin.x, y: -drawerBar!.frame.origin.y))
                
                if drawerBar.contentView.frame.contains(locationInDrawerBar) || (drawerBar.isSubMenuShowing && drawerBar.submenuButtonContainer.frame.contains(locationInDrawerBar)) {
                    return
                }
                
                
                let loc = panBeganLocation.applying(CGAffineTransform(translationX: -valueBars!.frame.origin.x, y: -valueBars!.frame.origin.y))
                if priceView!.valueBar!.frame.contains(loc) {

                    let d = Double(dy / UIScreen.main.bounds.height)
                    
                    let delta = panBeganHighestPrice - panBeganLowestPrice
                    
                    
                    
                    let newHighestPrice = panBeganHighestPrice + delta * d
                    let newLowestPrice = panBeganLowestPrice - delta * d
                    
                    guard newHighestPrice - newLowestPrice < 8 * (Util.highestPriceOf(visibleCandles) - Util.lowestPriceOf(visibleCandles)) else { return }
                    
                    guard newHighestPrice - newLowestPrice > 0.125 * (Util.highestPriceOf(visibleCandles) - Util.lowestPriceOf(visibleCandles)) else { return }
                    
                    
                    highestPrice = newHighestPrice
                    lowestPrice = newLowestPrice
                    
                    
                    redraw()
                }
            }
        case .ended:
            if crosshair!.isEnabled {
                crosshair!.initialPosition = crosshair!.position
            }
            break
        case .failed, .cancelled:
            if !crosshair!.isEnabled {
                crosshair!.isEnabled = false
            }
        default:
            break
        }
    }
    
    
    //MARK: Pinch
    @IBAction func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        
        let scale = recognizer.scale
        
        
        switch recognizer.state {
        case .began:
            pinchBeganBlockWidth = blockWidth
            panBeganNewestX = newestCandleX
        case .changed:
            if pinchBeganBlockWidth * scale < 0.2 { blockWidth = 0.2; return }
            blockWidth = pinchBeganBlockWidth * scale
            let newLatestCandleX = panBeganNewestX * (1 + scale) / 2
            if !(newLatestCandleX > 0) {
                return
            }
            newestCandleX = newLatestCandleX
            redraw()
        case .ended, .failed, .cancelled:
            break
        default:
            break
        }
    }
    
    //MARK: Long Press
    @IBAction func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        
        guard let crosshair = self.crosshair else { return }
        switch recognizer.state {
        case .began:
            let l = recognizer.location(in: crosshair)
            if priceView!.frame.contains(l) || bottomViews!.frame.contains(l) {
                
                let index = Int((l.x - oldestCandleX) / blockWidth)
                let candle: Candle = candles.reversed()[index]
                crosshair.initialPosition = CGPoint(x: candle.x, y: l.y)
                crosshair.isEnabled = true
                
                redraw()
            }
            
        case .changed:
            break
        case .ended, .cancelled, .failed:
            break
        default:
            break
        }
    }
    
    
    
    
    
    //MARK: - Manual Context Menu
    var buttonContainer: UIView!
    var innerButtonContainer: UIView!
    private var selectedTitle = ""
    private var buttonHeight: CGFloat = 30.0
    private var buttonWidth: CGFloat = 10.0
    private var buttonCount: CGFloat {
        return menuTitles.count.cgFloat
    }
    private var menuTitles = [String]()
    private var menuItemSelectedCompletion: ((String) -> Void)?
    private var animationDuration = 0.3
    
    func showContextMenu(at location: CGPoint, withTitles: [String], selectedTitle: String, andCompletion: @escaping (String) -> Void) {
        buttonHeight = 30.0
        buttonWidth = 10.0
        self.selectedTitle = selectedTitle
        menuTitles = withTitles
        menuItemSelectedCompletion = andCompletion
        
        for title in menuTitles {
            let str = title.asAttributedString(color: .black, font: UIFont.systemFont(ofSize: 15.0))
            if str.size().width > buttonWidth {
                buttonWidth = str.size().width
            }
            if str.size().height > buttonHeight {
                buttonHeight = str.size().height
            }
        }
        
        buttonWidth += 20.0
        buttonHeight += 15.0
        
        let menuHeight = buttonCount * buttonHeight
        var y = location.y
        let x = location.x
        
        
        
        if menuHeight + y > bounds.height {
            y = bounds.height - menuHeight
            if y < 0 {
                y = 0
            }
            buttonContainer = UIView(frame: CGRect(x: x, y: y, width: buttonWidth, height: 0))
        } else {
            buttonContainer = UIView(frame: CGRect(x: x, y: y, width: buttonWidth, height: 0))
        }
        
        innerButtonContainer = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: buttonWidth, height: 0)), style: .plain)
        (innerButtonContainer as! UITableView).delegate = self
        (innerButtonContainer as! UITableView).dataSource = self
        (innerButtonContainer as! UITableView).contentInset = .zero
        (innerButtonContainer as! UITableView).separatorInset = .zero
        (innerButtonContainer as! UITableView).register(UINib(nibName: "SimpleTVCell", bundle: nil), forCellReuseIdentifier: "SimpleTVCell")
        buttonContainer.addSubview(innerButtonContainer)
        
        
        innerButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        innerButtonContainer.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor).isActive = true
        innerButtonContainer.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true
        innerButtonContainer.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        innerButtonContainer.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
        
        
        innerButtonContainer.backgroundColor = .white
        
        
        addSubview(buttonContainer)
        buttonContainer.addShadow(color: .lightGray, opacity: 1.0, shadowRadius: 3.0, offset: CGSize(width: -3.0, height: 3.0))
        
        buttonContainer.alpha = 0.0
        
        toggleContextMenu()
        
    }
    
    func hideContextMenu(completion: @escaping () -> Void = {}) {
        toggleContextMenu(completion: completion)
    }
    
    
    var isContextMenuShowing = false
    private func toggleContextMenu(completion: @escaping (() -> Void) = {}) {
        if !isContextMenuShowing {
            
            UIView.animate(withDuration: animationDuration, animations: {
                let f = self.buttonContainer.frame
                var menuHeight = self.buttonCount * self.buttonHeight
                if menuHeight + f.origin.y > self.bounds.height {
                    menuHeight = self.bounds.height - f.origin.y
                }
                self.buttonContainer.frame = CGRect(x: f.origin.x, y: f.origin.y, width: self.buttonWidth, height: menuHeight)
                self.buttonContainer.alpha = 1.0
                self.layoutIfNeeded()
            }) { (_) in
                completion()
            }
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                let f = self.buttonContainer.frame
                self.buttonContainer.frame = CGRect(x: f.origin.x, y: f.origin.y, width: self.buttonWidth, height: 0)
                self.buttonContainer.alpha = 0.0
                self.layoutIfNeeded()
            }) { (_) in
                self.buttonContainer.removeFromSuperview()
                completion()
            }
        }
        
        isContextMenuShowing = !isContextMenuShowing
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleTVCell", for: indexPath) as! SimpleTVCell
        cell.lbl.text = menuTitles[indexPath.row]
        if menuTitles[indexPath.row] == selectedTitle {
            cell.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return buttonHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleContextMenu {
            self.menuItemSelectedCompletion?(self.menuTitles[indexPath.row])
        }
    }
    
    
    
    //MARK: - Private Methods
    private func sort(indicators: [Indicator]) -> [Indicator] {
        var result = [Indicator]()
        var frameRow = 0
        while result.count < indicators.count {
            let indicatorsInThisFrameRow = indicators.filter { (ind) -> Bool in
                return ind.getRow() == frameRow
            }
            //Find BiggestLayerIndex
            var smallestLayerIndex: Double = 0.0
            indicatorsInThisFrameRow.forEach { (indicator) in
                if let index = indicator.style[Indicator.StyleKey.zIndex] as? Double {
                    if index < smallestLayerIndex {
                        smallestLayerIndex = index
                    }
                }
            }
            indicatorsInThisFrameRow.forEach { (indicator) in
                if indicator.style[Indicator.StyleKey.zIndex] == nil {
                    indicator.style[Indicator.StyleKey.zIndex] = smallestLayerIndex - 1.0
                }
            }
            
            result.append(contentsOf: indicatorsInThisFrameRow.sorted(by: { (ind1, ind2) -> Bool in
                return (ind1.style[Indicator.StyleKey.zIndex] as! Double) >
                    (ind2.style[Indicator.StyleKey.zIndex] as! Double)
            }))
            
            frameRow += 1
        }
        return result
    }
    
    //MARK: - Convenience Properties
    var instrument: Instrument? {
        get {
            return app.getInstrument(app.settings.chartSymbol)
        }
        set {
            if let inst = newValue {
                app.settings.chartSymbol = inst.symbol
            } else {
                app.settings.chartSymbol = "XBTUSD"
            }
        }
    }
    var timeframe: Timeframe? {
        get {
            return app.settings.chartTimeframe
        }
        set {
            app.settings.chartTimeframe = newValue!
        }
    }
    var highestPrice: Double {
        get {
            return app.settings.chartHighestPrice
        }
        set {
            app.settings.chartHighestPrice = newValue
        }
    }
    var lowestPrice: Double {
        get {
            return app.settings.chartLowestPrice
        }
        set {
            app.settings.chartLowestPrice = newValue
        }
    }
    
    var spacing: CGFloat {
        if blockWidth >= 4.0 {
            return blockWidth * 0.2
        } else if blockWidth >= 0.7 {
            return blockWidth * 0.1
        } else {
            return 0.0
        }
    }
    var candleWidth: CGFloat {
        return blockWidth - spacing
    }
    var wickWidth: CGFloat {
        return blockWidth >= 2.0 ? blockWidth * 0.25 : blockWidth * 0.5
    }
    var blockWidth: CGFloat {
        get {
            return app.settings.chartBlockWidth
        }
        set {
            app.settings.chartBlockWidth = newValue
        }
    }
    
    var indicators: [Indicator] {
        get {
            return app.settings.chartIndicators
        }
        set {
            app.settings.chartIndicators = sort(indicators: newValue)
        }
    }
    
    var newestCandleX: CGFloat {
        get {
            return app.settings.chartLatestX
        }
        set {
            app.settings.chartLatestX = newValue
        }
    }
    
    var oldestCandleX: CGFloat {
        return newestCandleX - blockWidth * (candles.count - 1).cgFloat
    }
    
    var autoScale: Bool {
        get {
            return app.settings.chartAutoScale
        }
        set {
            app.settings.chartAutoScale = newValue
        }
    }
    var topMargin: Double {
        get {
            return app.settings.chartTopMargin
        }
        set {
            app.settings.chartTopMargin = newValue
            priceView?.valueBar?.topMargin = newValue
        }
    }
    var bottomMargin: Double {
        get {
            return app.settings.chartBottomMargin
        }
        set {
            app.settings.chartBottomMargin = newValue
            priceView?.valueBar?.bottomMargin = newValue
        }
    }
    
    var logScale: Bool {
        get {
            return app.settings.chartLogScale
        }
        set {
            app.settings.chartLogScale = newValue
            priceView?.valueBar?.logScale = newValue
        }
    }
    
    
    var chartBackgroundColor: UIColor {
        get {
            return app.settings.chartBackgroundColor
        }
        set {
            app.settings.chartBackgroundColor = newValue
//            self.backgroundColor = newValue
        }
    }
    
    var isSettingsViewShowing: Bool {
        return !settingsView.isHidden
    }
}