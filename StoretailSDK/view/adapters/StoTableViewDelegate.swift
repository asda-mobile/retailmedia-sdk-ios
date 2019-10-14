//
//  StoTableViewDelegate.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 16/07/2019.
//  Copyright © 2019 Kevin Naudin. All rights reserved.
//

import Foundation
import Nuke

public class StoTableViewDelegate : NSObject,
    UITableViewDataSource,
    UITableViewDelegate {
    private let TAG = "StoTableViewDelegate"
    
    private let tableView: UITableView
    private let dataSourceRef: UITableViewDataSource
    private let delegateRef: UITableViewDelegate
    
    private let imageManager: StoImageManager
    
    private var isTablet : Bool = false
    
    private var formats: [StoFormat]
    private var acceptedFormatType: [StoFormatType]
    
    private var positions: StoFormatsPositions
    private var adapterListener: StoAdapterListener?
    private var layoutCreator: StoLayoutCreator?
    
    public init(tableView: UITableView) {
        
        self.tableView = tableView
        self.dataSourceRef = tableView.dataSource!
        self.delegateRef = tableView.delegate!
        
        self.imageManager = StoImageManager()
        
        isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        self.formats = []
       
        acceptedFormatType = [.stoBanner, .stoButterfly, .stoVignette]
        
        self.positions = StoFormatsPositions.defaultPositions()
        
        super.init()
        
        self.imageManager.delegate = self
        
        registerTableViewCells()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerTableViewCells() {
        let butterflyPhoneNib = UINib(nibName: "Frameworks/StoretailSDK.framework/StoButterflyPhoneTableViewCell", bundle: nil)
        self.tableView.register(butterflyPhoneNib, forCellReuseIdentifier: "StoButterflyPhoneTableViewCell")
        
        self.tableView.register(StoVignetteTableViewCell.self, forCellReuseIdentifier: "StoVignetteTableViewCell")
    }
    
    private func getViewType(indexPath: IndexPath) -> StoFormatType {
        for stoFormat in self.formats {
            if stoFormat.position == indexPath.row {
                return stoFormat.getFormatType()
            }
        }
        
        return .none
    }
    
    // MARK: Public setters
    public func set(adapterListener: StoAdapterListener) -> StoTableViewDelegate {
        self.adapterListener = adapterListener
        return self
    }
    
    public func set(positions: StoFormatsPositions) -> StoTableViewDelegate {
        self.positions = positions
        return self
    }
    
    public func set(layoutCreator: StoLayoutCreator) -> StoTableViewDelegate {
        self.layoutCreator = layoutCreator
        return self
    }
    
    public func clear() {
        formats.removeAll()
        imageManager.clear()
    }
    
    private func checkVisibilityOfCell(at indexPath: IndexPath) -> Bool {
        let cellRect = tableView.rectForRow(at: indexPath)
        return tableView.bounds.contains(cellRect)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let paths = tableView.indexPathsForVisibleRows {
            // All of the rest of the cells are visible: Loop through the 2nd through n-1 cells
            for path in paths {
                for stoFormat in self.formats {
                    if stoFormat.position == path.row && checkVisibilityOfCell(at: path) {
                        if StoTracker.sharedInstance.isImpressionEqualToView {
                            StoTracker.sharedInstance.imp(stoFormat: stoFormat)
                        }
                        StoTracker.sharedInstance.view(stoFormat: stoFormat)
                    }
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let sectionCount = dataSourceRef.numberOfSections?(in: self.tableView) {
            StoLog.i(message: "\(TAG) numberOfSections: \(sectionCount)")
            return sectionCount
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var dataCount = dataSourceRef.tableView(self.tableView, numberOfRowsInSection: section)
        StoLog.i(message: "\(TAG) numberOfRowsInSection(\(section)): \(dataCount) - formatCount: \(formats.count)")
        dataCount += self.formats.count
        StoLog.i(message: "\(TAG) numberOfRowsInSection(\(section)) total: \(dataCount)")
        return dataCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var format : StoFormat?
        for stoFormat in self.formats {
            if stoFormat.position == indexPath.row {
                format = stoFormat
                break
            }
        }
        
        let stoViewType : StoFormatType = format?.getFormatType() ?? .none
        StoLog.i(message: "\(TAG) cellForRowAt(\(indexPath)): \(stoViewType)")
        if stoViewType != .none && !StoTracker.sharedInstance.isImpressionEqualToView {
            StoTracker.sharedInstance.imp(stoFormat: format!)
        }
        switch stoViewType {
        case .stoBanner:
            let stoBanner = format as! StoBanner
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: "StoVignetteTableViewCell", for: indexPath) as! StoVignetteTableViewCell
            
            if let backgroundImageURL = stoBanner.getBackgroundImageURL(isTablet: isTablet),
                let image = imageManager.getImage(for: backgroundImageURL) {
                bannerCell.setDatas(type: stoViewType, image: image, backgroundColor: stoBanner.getBackgroundColor(), parentWidth: tableView.frame.width)
            }
            return bannerCell
        case .stoVignette:
            let stoVignette = format as! StoVignette
            let vignetteCell = tableView.dequeueReusableCell(withIdentifier: "StoVignetteTableViewCell", for: indexPath) as! StoVignetteTableViewCell
            
            if let backgroundImageURL = stoVignette.getBackgroundImageURL(isTablet: false),
                let image = imageManager.getImage(for: backgroundImageURL) {
                vignetteCell.setDatas(type: stoViewType, image: image, backgroundColor: stoVignette.getBackgroundColor(), parentWidth: tableView.frame.width)
            }
            return vignetteCell
        case .stoButterfly:
            let stoButterfly = format as! StoButterfly
            
            let bfPhoneCell = tableView.dequeueReusableCell(withIdentifier: "StoButterflyPhoneTableViewCell", for: indexPath) as? StoButterflyPhoneTableViewCell
            bfPhoneCell?.butterflyDelegate = self
            bfPhoneCell?.formatDelegate = self
            bfPhoneCell?.setButterflyFormat(stoButterfly: stoButterfly)
            if let productView = layoutCreator?.createLayout(listener: self, format: stoButterfly, productId: stoButterfly.getProductIdSelected()!) {
                bfPhoneCell?.addProductView(view: productView)
            }
            return bfPhoneCell!
        case .stoFlagship:
            // TODO:
            return UITableViewCell()
        default:
            let nbFormatCountBefore = positions.getFormatsCount(before: indexPath.row, nbFormats: self.formats.count)
            let newIndexPath = IndexPath(row: (indexPath.row - nbFormatCountBefore), section: indexPath.section)
            StoLog.i(message: "\(TAG) cellForRowAt(\(newIndexPath)) Native")
            return dataSourceRef.tableView(self.tableView, cellForRowAt: newIndexPath)
        }
    }
    
    
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        StoLog.d(message:"\(self.TAG): tableView: didSelectRowAt: \(indexPath)")
        
        var format : StoFormat?
        for stoFormat in self.formats {
            if stoFormat.position == indexPath.row {
                format = stoFormat
                break
            }
        }
        
        if let format = format {
            if format.getFormatType() == .stoButterfly, let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
                StoTracker.sharedInstance.openProductPage(stoFormat: format, productId: productId)
                adapterListener?.stoOpenProduct(productId: productId)
            } else if format.getFormatType() == .stoBanner || format.getFormatType() == .stoVignette {
                buttonOptionClicked(format: format)
            }
        } else {
            let nbFormatCountBefore = positions.getFormatsCount(before: indexPath.row, nbFormats: self.formats.count)
            let newIndexPath = IndexPath(row: (indexPath.row - nbFormatCountBefore), section: indexPath.section)
            delegateRef.tableView?(tableView, didSelectRowAt: newIndexPath)
        }
    }
}

extension StoTableViewDelegate : StoFormatImageManagerProtocol {
    func reloadView() {
        self.tableView.reloadData()
    }
}

extension StoTableViewDelegate : StoFormatListener {
    // MARK: StoFormatListener
    public func onStoFormatsReceived(formatsList: [StoFormat], identifier: String?) {
        StoLog.e(message: "\(TAG) onStoFormatsReceived: \(formatsList.count)")
        self.formats.removeAll()
        
        for stoFormat in formatsList {
            if acceptedFormatType.contains(stoFormat.getFormatType()) {
                self.formats.append(stoFormat)
            }
        }
        
        let dataCount = dataSourceRef.tableView(self.tableView, numberOfRowsInSection: 0)
        
        positions.generatePositions(stoFormats: &self.formats, dataCount: dataCount)
        
        var hasRemovedFormat = false
        var i = 0
        while i < self.formats.count {
            if self.formats[i].getFormatType() == .stoButterfly {
                NSLog("CHECK BUTTERFLY \(i) \(self.formats[i])")
                if !StoTracker.sharedInstance.isFormatAvailable(stoFormatWithButtons: (self.formats[i] as! StoButterfly)) {
                    self.formats.remove(at: i)
                    hasRemovedFormat = true
                    i -= 1
                }
            }
            i += 1
        }
        
        if hasRemovedFormat {
            positions.generatePositions(stoFormats: &self.formats, dataCount: dataCount)
        }
        
        imageManager.downloadImagesBeforeReload(formats: self.formats, isCollectionView: false)
    }
    
    public func onStoFailure(message: String, identifier: String?) {
        StoLog.e(message: "\(TAG) onStoFailure: \(message)")
    }
}

extension StoTableViewDelegate : StoButterflyViewProtocol {
    // MARK: StoButterflyViewProtocol
    func buttonCliked(cell: StoButterflyCellProtocol, productId: String) {
        if let format = cell.getButterflyFormat(), let view = layoutCreator?.createLayout(listener: self, format: format, productId: productId) {
            cell.addProductView(view: view)
            if let productId = format.getProductIdSelected() {
                StoTracker.sharedInstance.browse(stoFormat: format, productId: productId)
            }
        }
    }
}

extension StoTableViewDelegate : StoFormatViewProtocol {
    func buttonOptionClicked(format: StoFormat) {
        NSLog("buttonOptionClicked")
        switch format.getFormatType() {
        case .stoBanner:
            if let stoBanner = format as? StoBanner, let deeplink = stoBanner.getDeeplink() {
                adapterListener?.stoOpenDeeplink(deeplink: deeplink)
            }
            break
        case .stoVignette:
            if let stoVignette = format as? StoVignette, let deeplink = stoVignette.getDeeplink() {
                adapterListener?.stoOpenDeeplink(deeplink: deeplink)
            }
            break
        case .stoButterfly:
            if let stoButterfly = format as? StoButterfly, let optionValue = stoButterfly.getOptionValue() {
                switch stoButterfly.getOptionType() {
                case .redirection:
                    adapterListener?.stoOpenDeeplink(deeplink: optionValue)
                    break
                case .pdf:
                    adapterListener?.stoOpenPDF(pdfUrl: optionValue)
                    break
                case .video:
                    adapterListener?.stoOpenVideo(videoUrl: optionValue)
                    break
                default:
                    break
                }
            }
            break
        default:
            break
        }
        
        StoTracker.sharedInstance.openOption(stoFormat: format, optionType: format.getOptionType())
    }
}

extension StoTableViewDelegate : StoAdapterTrackEvents {
    // MARK: StoAdapterTrackEvents delegate
    public func openProductPage(format: StoFormat) {
        StoLog.d(message:"\(self.TAG): openProductPage \(format)")
        if let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
            StoTracker.sharedInstance.openProductPage(stoFormat: format, productId: productId)
        }
    }
    
    public func addToWishList(format: StoFormat) {
        StoLog.d(message:"\(self.TAG): addToWishList \(format)")
        if let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
        StoTracker.sharedInstance.addToList(stoFormat: format, productId: productId)
        }
    }
    
    public func addToBasket(format: StoFormat) {
        StoLog.d(message:"\(self.TAG): addToBasket \(format)")
        if let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
        StoTracker.sharedInstance.basket(stoFormat: format, productId: productId, eventValue: .AbkBtn)
        }
    }
    
    public func addToBasketMore(format: StoFormat) {
        StoLog.d(message:"\(self.TAG): addToBasketMore \(format)")
        if let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
        StoTracker.sharedInstance.basket(stoFormat: format, productId: productId, eventValue: .QuantityMore)
        }
    }
    
    public func addToBasketLess(format: StoFormat) {
        StoLog.d(message:"\(self.TAG): addToBasketLess \(format)")
        if let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
        StoTracker.sharedInstance.basket(stoFormat: format, productId: productId, eventValue: .QuantityLess)
        }
    }
    
    public func basketQuantityChange(format: StoFormat) {
        StoLog.d(message:"\(self.TAG): basketQuantityChange \(format)")
        if let stoFormatWithButtons = format as? StoFormatWithButtons, let productId = stoFormatWithButtons.getProductIdSelected() {
            StoTracker.sharedInstance.basket(stoFormat: format, productId: productId, eventValue: .QuantityChange)
        }
    }
}
