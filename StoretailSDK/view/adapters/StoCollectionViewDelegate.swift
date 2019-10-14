//
//  StoCollectionViewDelegate.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 22/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import Nuke

public class StoCollectionViewDelegate : NSObject {
    private let TAG = "StoCollectionViewDelegate"
    
    private let collectionView: UICollectionView
    private let dataSourceRef: UICollectionViewDataSource
    private let delegateRef: UICollectionViewDelegate
    
    private let imageManager: StoImageManager
    
    private var isTablet : Bool = false
    
    private var formats: [StoFormat]
    private var acceptedFormatType: [StoFormatType]
    
    private var positions: StoFormatsPositions
    private var adapterListener: StoAdapterListener?
    private var layoutCreator: StoLayoutCreator?
    
    private let viewWidth : CGFloat
    private var maxCellPerRow : Int
    private var nativeCellSize : CGSize?
    
    public init(collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        self.dataSourceRef = collectionView.dataSource!
        self.delegateRef = collectionView.delegate!
        self.imageManager = StoImageManager()
        
        isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        self.formats = []
        
        acceptedFormatType = [.stoBanner, .stoButterfly, .stoVignette]
        
        self.positions = StoFormatsPositions.defaultPositions()
        self.viewWidth = self.collectionView.frame.width
        self.maxCellPerRow = 0
        
        super.init()
        
        self.imageManager.delegate = self
        
        registerCollectionViewCells()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCollectionViewCells() {
        let butterflyTabletNib = UINib(nibName: "Frameworks/StoretailSDK.framework/StoButterflyTabletCollectionViewCell", bundle: nil)
        self.collectionView.register(butterflyTabletNib, forCellWithReuseIdentifier: "StoButterflyTabletCollectionViewCell")
        
        let butterflyPhoneNib = UINib(nibName: "Frameworks/StoretailSDK.framework/StoButterflyPhoneCollectionViewCell", bundle: nil)
        self.collectionView.register(butterflyPhoneNib, forCellWithReuseIdentifier: "StoButterflyPhoneCollectionViewCell")
        
        self.collectionView.register(StoVignetteCollectionViewCell.self, forCellWithReuseIdentifier: "StoVignetteCollectionViewCell")
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
    public func set(adapterListener: StoAdapterListener) -> StoCollectionViewDelegate {
        self.adapterListener = adapterListener
        return self
    }
    
    public func set(positions: StoFormatsPositions) -> StoCollectionViewDelegate {
        self.positions = positions
        return self
    }
    
    public func set(layoutCreator: StoLayoutCreator) -> StoCollectionViewDelegate {
        self.layoutCreator = layoutCreator
        return self
    }
    
    public func clear() {
        formats.removeAll()
        imageManager.clear()
    }
}

extension StoCollectionViewDelegate : StoFormatImageManagerProtocol {
    func reloadView() {
        self.collectionView.reloadData()
    }
}

extension StoCollectionViewDelegate : UIScrollViewDelegate {
    // MARK: UIScrollViewDelegate
    private func checkVisibilityOfItem(at indexPath: IndexPath) -> Bool {
        if let itemRect = collectionView.layoutAttributesForItem(at: indexPath)?.frame {
            return collectionView.bounds.contains(itemRect)
        }
        return false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let paths = collectionView.indexPathsForVisibleItems
        // All of the rest of the cells are visible: Loop through the 2nd through n-1 cells
        for path in paths {
            for stoFormat in self.formats {
                if stoFormat.position == path.row && checkVisibilityOfItem(at: path) {
                    if StoTracker.sharedInstance.isImpressionEqualToView {
                        StoTracker.sharedInstance.imp(stoFormat: stoFormat)
                    }
                    StoTracker.sharedInstance.view(stoFormat: stoFormat)
                }
            }
        }
    }
}

extension StoCollectionViewDelegate : UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sectionCount = dataSourceRef.numberOfSections?(in: collectionView) {
            return sectionCount
        }
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var dataCount = dataSourceRef.collectionView(collectionView, numberOfItemsInSection: section)
        dataCount += self.formats.count
        return dataCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var format : StoFormat?
        for stoFormat in self.formats {
            if stoFormat.position == indexPath.row {
                format = stoFormat
                break
            }
        }
        
        let stoViewType : StoFormatType = format?.getFormatType() ?? .none
        if stoViewType != .none && !StoTracker.sharedInstance.isImpressionEqualToView {
            StoTracker.sharedInstance.imp(stoFormat: format!)
        }
        switch stoViewType {
        case .stoBanner:
            let stoBanner = format as! StoBanner
            let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoVignetteCollectionViewCell", for: indexPath) as! StoVignetteCollectionViewCell
            //let isTablet = self.maxCellPerRow > 1
            if let backgroundImageURL = stoBanner.getBackgroundImageURL(isTablet: isTablet),
                let image = imageManager.getImage(for: backgroundImageURL) {
                bannerCell.setBannerDatas(image: image, backgroundColor: stoBanner.getBackgroundColor(), parentWidth: collectionView.frame.size.width)
            }
            
            return bannerCell
        case .stoButterfly:
            let stoButterfly = format as! StoButterfly
            let isGrid = self.maxCellPerRow > 1
            if isTablet && isGrid {
                let bfTabletCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoButterflyTabletCollectionViewCell", for: indexPath) as! StoButterflyTabletCollectionViewCell
                bfTabletCell.butterflyDelegate = self
                bfTabletCell.formatDelegate = self
                bfTabletCell.setButterflyFormat(stoButterfly: stoButterfly)
                if let productView = layoutCreator?.createLayout(listener: self, format: stoButterfly, productId: stoButterfly.getProductIdSelected()!) {
                    bfTabletCell.addProductView(view: productView)
                }
                return bfTabletCell
            } else {
                let bfPhoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoButterflyPhoneCollectionViewCell", for: indexPath) as! StoButterflyPhoneCollectionViewCell
                bfPhoneCell.butterflyDelegate = self
                bfPhoneCell.formatDelegate = self
                bfPhoneCell.setButterflyFormat(stoButterfly: stoButterfly)
                if let productView = layoutCreator?.createLayout(listener: self, format: stoButterfly, productId: stoButterfly.getProductIdSelected()!) {
                    bfPhoneCell.addProductView(view: productView)
                }
                return bfPhoneCell
            }
        case .stoFlagship:
            // TODO:
            return UICollectionViewCell()
            
        case .stoVignette:
            
            let stoVignette = format as! StoVignette
            let vignetteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoVignetteCollectionViewCell", for: indexPath) as! StoVignetteCollectionViewCell
            let isGrid = self.maxCellPerRow > 1
            if let backgroundImageURL = stoVignette.getBackgroundImageURL(isTablet: isGrid),
                let image = imageManager.getImage(for: backgroundImageURL) {
                if isGrid {
                    vignetteCell.setVignetteDatas(image: image, backgroundColor: stoVignette.getBackgroundColor(), isGrid: isGrid, size: vignetteCell.frame.size)
                    //image.resizeImage(in: vignetteCell.backgroundImage, imageViewSize: vignetteCell.frame.size, widthConstraint: vignetteCell.bgWidth!, heightConstraint: vignetteCell.bgHeight!)
                } else {
                    vignetteCell.setVignetteDatas(image: image, backgroundColor: stoVignette.getBackgroundColor(), isGrid: isGrid, size: collectionView.frame.size)
                    /*
                    let height = collectionView.frame.size.width * image.getRatio()
                    vignetteCell.backgroundImage.image = image
                    vignetteCell.bgWidth?.constant = collectionView.frame.size.width
                    vignetteCell.bgHeight?.constant = height
                    */
                }
                
            }
            
            return vignetteCell
        default:
            let nbFormatCountBefore = positions.getFormatsCount(before: indexPath.row, nbFormats: self.formats.count)
            let newIndexPath = IndexPath(row: (indexPath.row - nbFormatCountBefore), section: indexPath.section)
            return dataSourceRef.collectionView(collectionView, cellForItemAt: newIndexPath)
        }
    }
}

extension StoCollectionViewDelegate : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var format : StoFormat?
        for stoFormat in self.formats {
            if stoFormat.position == indexPath.row {
                format = stoFormat
                break
            }
        }
        
        if let stoFormat = format {
            return getFormatSize(format: stoFormat)
        } else {
            if self.nativeCellSize == nil {
                let nbFormatCountBefore = positions.getFormatsCount(before: indexPath.row, nbFormats: self.formats.count)
                let newIndexPath = IndexPath(row: (indexPath.row - nbFormatCountBefore), section: indexPath.section)
                if let flowLayout = delegateRef as? UICollectionViewDelegateFlowLayout {
                    if let size = flowLayout.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: newIndexPath) {
                        NSLog("\(TAG) sizeForItemAt Native \(size)")
                        nativeCellSize = size
                        self.maxCellPerRow = Int(self.viewWidth / size.width)
                        return size
                    }
                }
            }
            return nativeCellSize!
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    private func getFormatSize(format: StoFormat) -> CGSize {
        let collectionViewWidth = self.collectionView.frame.width
        
        NSLog("\(TAG) getFormatSize collectionWidth : \(collectionViewWidth)")
        if let cellSize = nativeCellSize {
            var multiplier : CGFloat = 2.0
            if self.maxCellPerRow < 2 {
                multiplier = 1.0
            }
            switch format.getFormatType() {
            case .stoButterfly:
                let isGrid = maxCellPerRow > 1
                if isTablet && isGrid {
                    return CGSize(width: cellSize.width * multiplier, height: cellSize.height)
                } else {
                    let butterflyHeight = collectionViewWidth / 4.14 + cellSize.height
                    return CGSize(width: collectionViewWidth, height: butterflyHeight)
                }
            case .stoBanner:
                let stoBanner = format as! StoBanner
                if let imageURL = stoBanner.getBackgroundImageURL(isTablet: isTablet) {
                    if let image = imageManager.getImage(for: imageURL) {
                        if image.size.width < collectionViewWidth {
                            return CGSize(width: collectionViewWidth, height: image.size.height)
                        } else {
                            let height = collectionViewWidth * image.getRatio()
                            return CGSize(width: collectionViewWidth, height: height)
                        }
                    }
                }
            case .stoFlagship:
                // TODO
                return CGSize(width: 0, height: 0)
            case .stoVignette:
                let stoVignette = format as! StoVignette
                if self.maxCellPerRow > 1 {
                    return cellSize
                } else {
                    if let imageURL = stoVignette.getBackgroundImageURL(isTablet: isTablet) {
                        if let imageRatio = imageManager.getImage(for: imageURL)?.getRatio() {
                            let height = collectionViewWidth * imageRatio
                            return CGSize(width: collectionViewWidth, height: height)
                        }
                    }
                }
            default:
                return CGSize(width: 0, height: 0)
            }
        }
        return CGSize(width: 0, height: 0)
    }
}

extension StoCollectionViewDelegate : UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        StoLog.d(message:"\(self.TAG): tableView: didSelectRowAt: \(indexPath)")
        
        var format : StoFormat?
        for stoFormat in self.formats {
            if stoFormat.position == indexPath.row {
                format = stoFormat
                break
            }
        }
        
        if let format = format {
            if format.getFormatType() == .stoButterfly, let stoButterfly = format as? StoFormatWithButtons, let productId = stoButterfly.getProductIdSelected() {
                StoTracker.sharedInstance.openProductPage(stoFormat: format, productId: productId)
                adapterListener?.stoOpenProduct(productId: productId)
            } else if format.getFormatType() == .stoBanner || format.getFormatType() == .stoVignette {
                buttonOptionClicked(format: format)
            }
        } else {
            let nbFormatCountBefore = positions.getFormatsCount(before: indexPath.row, nbFormats: self.formats.count)
            let newIndexPath = IndexPath(row: (indexPath.row - nbFormatCountBefore), section: indexPath.section)
            delegateRef.collectionView?(collectionView, didSelectItemAt: newIndexPath)
        }
    }
}

extension StoCollectionViewDelegate : StoButterflyViewProtocol {
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

extension StoCollectionViewDelegate : StoFormatViewProtocol {
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

extension StoCollectionViewDelegate : StoFormatListener {
    // MARK: StoFormatListener
    public func onStoFormatsReceived(formatsList: [StoFormat], identifier: String?) {
        StoLog.e(message: "\(TAG) onStoFormatsReceived: \(formatsList.count)")
        self.formats.removeAll()
        
        for stoFormat in formatsList {
            if acceptedFormatType.contains(stoFormat.getFormatType()) {
                self.formats.append(stoFormat)
            }
        }
        
        let dataCount = dataSourceRef.collectionView(self.collectionView, numberOfItemsInSection: 0)
        
        if self.maxCellPerRow > 1 {
            positions.generatePositionsInCollection(stoFormats: &self.formats, dataCount: dataCount, maxCellPerRow: Int(self.viewWidth / nativeCellSize!.width))
        } else {
            positions.generatePositions(stoFormats: &self.formats, dataCount: dataCount)
        }
        
        var hasRemovedFormat = false
        var i = 0
        while i < self.formats.count {
            if self.formats[i].getFormatType() == .stoButterfly {
                if !StoTracker.sharedInstance.isFormatAvailable(stoFormatWithButtons: (self.formats[i] as! StoButterfly)) {
                    self.formats.remove(at: i)
                    hasRemovedFormat = true
                    i -= 1
                }
            }
            i += 1
        }
        
        if hasRemovedFormat {
            if self.maxCellPerRow > 1 {
                positions.generatePositionsInCollection(stoFormats: &self.formats, dataCount: dataCount, maxCellPerRow: Int(self.viewWidth / nativeCellSize!.width))
            } else {
                positions.generatePositions(stoFormats: &self.formats, dataCount: dataCount)
            }
        }
        
        // TODO DownloadImage
        let isTablet = self.maxCellPerRow > 1
        imageManager.downloadImagesBeforeReload(formats: self.formats, isCollectionView: isTablet)
    }
    
    public func onStoFailure(message: String, identifier: String?) {
        StoLog.e(message: "\(TAG) onStoFailure: \(message)")
    }
}

/// User's interactions between native view created by LayoutCreator
extension StoCollectionViewDelegate : StoAdapterTrackEvents {
    // MARK: StoAdapterTrackEvents
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
