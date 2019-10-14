//
//  StoTracker.swift
//  StoRetailerApp
//
//  Created by Mikhail on 30/06/2017.
//  Copyright © 2017 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


public class StoTracker{
    
    private let TAG: String = "StoTracker"
    
    private var stoTrackerHelper: StoTrackerHelper
    private var stoRequestHandler: StoRequestHandler
    private var stoErrorHandler: StoErrorHandler
    
    private var retailName : String
    private var retailPage : String
    private var retailShop : String
    private var forcedCity : String
    private var forcedLatitude : String
    private var forcedLongitude : String
    private var appVersion : String
    private var enableGDPR : Bool
    private(set) var isImpressionEqualToView : Bool
    
    // Singleton pattern
    public static let sharedInstance = StoTracker()
    
    private var serveur_url:String = "https://tk.storetail.io/x?"
    
    public init(){
        self.stoTrackerHelper = StoTrackerHelper()
        self.stoRequestHandler = StoRequestHandler(stoTrackerHelper: self.stoTrackerHelper)
        self.stoErrorHandler = StoErrorHandler(stoRequestHandler: self.stoRequestHandler)
        retailName = ""
        retailPage = ""
        retailShop = ""
        forcedCity = ""
        forcedLatitude = ""
        forcedLongitude = ""
        appVersion = ""
        enableGDPR = false
        isImpressionEqualToView = false
    }
    
    public func initialize(retailName: String, retailShop: String, forcedCity: String, forcedLatitude: String, forcedLongitude: String) {
        self.retailName = retailName
        self.retailShop = retailShop
        self.forcedCity = forcedCity
        self.forcedLatitude = forcedLatitude
        self.forcedLongitude = forcedLongitude
        StoLog.i(message: "StoTracker initialized")
    }
    
    public func setApplicationVersion(appVersion: String) { self.appVersion = appVersion }
    public func enabledGDPR(isEnabled: Bool) { self.enableGDPR = isEnabled }
    public func enableLogs(isEnabled: Bool) { isEnabled ? StoLog.enableLogs() : StoLog.disableLogs() }
    public func setImpressionEqualToView(isEqual: Bool) { self.isImpressionEqualToView = isEqual }
    
    ///  Called when the home page loads
    public func lodHomePage(availableProductsCount : Int = 0) {
        if (!enableGDPR) {
            StoLog.i(message: "lodHomePage call...")
            
            retailPage = "home"
            
            stoTrackerHelper.setStoPageType(stoPageType: .StoHomePage)
            
            let stoQueryString = newStoQueryString()
            
            stoTrackerHelper.removeFormats()
            
            StoCrawl.sharedInstance.clear()
            
            stoTrackerHelper.startTimeTrack()
            
            stoQueryString.qspRetailSearch.value = ""
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspTrackAction.value = StoTrackActionValue.lod.description
            stoQueryString.qspAvailableProducts.value = "\(availableProductsCount)"
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }

    /// Called when category or products list pages loads
    public func lod(formattedRetailPage: String, stoPageType: StoPageType, availableProductsCount : Int = 0, identifier: String? = nil) {
        if (!enableGDPR) {
            StoLog.i(message: "lod call... \(stoPageType.description)")
            
            retailPage = "home/\(formattedRetailPage)"
            stoTrackerHelper.setStoPageType(stoPageType: stoPageType)
            
            let stoQueryString = newStoQueryString()
            
            stoTrackerHelper.removeFormats()
            
            StoCrawl.sharedInstance.clear()
            
            stoTrackerHelper.startTimeTrack()
            
            stoQueryString.qspRetailSearch.value = ""
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspTrackAction.value = StoTrackActionValue.lod.description
            stoQueryString.qspAvailableProducts.value = "\(availableProductsCount)"
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString(), identifier: identifier)
        }
    }
    
    /// Called when product pages loads
    ///
    /// - Parameter formattedRetailPage: formatted context
    /// - Parameter productId: Product identifier
    public func lodProductPage(formattedRetailPage: String, productId: String) {
        if (!enableGDPR) {
            StoLog.i(message: "lodProductPage call..." )
            
            retailPage = "home/product_page/\(formattedRetailPage)"
            stoTrackerHelper.setStoPageType(stoPageType: .StoProductPage)
            
            let stoQueryString = newStoQueryString()
            
            stoTrackerHelper.removeFormats()
            
            StoCrawl.sharedInstance.clear()
            
            stoTrackerHelper.startTimeTrack()
            
            stoQueryString.qspRetailSearch.value = ""
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspProductId.value = productId
            stoQueryString.qspTrackAction.value = StoTrackActionValue.lod.description
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    ///  Called when the checkout page loads
    public func lodCheckout() {
        if (!enableGDPR) {
            StoLog.i(message: "lodCheckout call...")
            
            retailPage = "home/checkout"
            
            stoTrackerHelper.setStoPageType(stoPageType: .StoCheckoutPage)
            
            let stoQueryString = newStoQueryString()
            
            stoTrackerHelper.removeFormats()
            
            StoCrawl.sharedInstance.clear()
            
            stoTrackerHelper.startTimeTrack()
            
            stoQueryString.qspRetailSearch.value = ""
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspTrackAction.value = StoTrackActionValue.lod.description
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Called when product pages loads
    ///
    /// - Parameter querySearch: user input search
    public func lodSearch(querySearch: String, availableProductsCount : Int = 0) {
        if (!enableGDPR) {
            StoLog.i(message: "lodSearch call..." )
            
            retailPage = "home/search"
            stoTrackerHelper.setStoPageType(stoPageType: .StoSearchPage)
            
            let stoQueryString = newStoQueryString()
            
            stoTrackerHelper.removeFormats()
            
            StoCrawl.sharedInstance.clear()
            
            stoTrackerHelper.startTimeTrack()
            
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspTrackAction.value = StoTrackActionValue.lod.description
            stoQueryString.qspRetailSearch.value = StoTrackerUtils.getFormattedRetailSearch(retailSearch: querySearch)
            stoQueryString.qspAvailableProducts.value = "\(availableProductsCount)"
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Called for each no-exp object received in load
    ///
    /// - Parameter list: <#list description#>
    internal func noexp(queryStringParams list: [QueryStringParam]){
        if (!enableGDPR) {
            StoLog.i(message: "noexp call..." )
            
            // Verifies if the list is not empty
            let stoQueryString = newStoQueryString()
            if list.isEmpty {
                reportError(stoQueryString: stoQueryString, message: "noexp: queryStringParams is empty")
                return
            }
            
            stoQueryString.qspTrackAction.value = StoTrackActionValue.noexp.description
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.updateByQSP(queryStringParams: list)
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Called when an object is shown
    ///
    /// - Parameter stoFormat: Received format
    public func imp(stoFormat: StoFormat) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "imp") {
                return;
            }
            
            if stoTrackerHelper.isImpressed(stoFormatId: stoFormat.uniqueID) {
                return;
            }
            
            StoLog.i(message: "imp call..." )
            
            stoTrackerHelper.addImpressedObject(stoFormatId: stoFormat.uniqueID)
            stoQueryString.qspTrackAction.value = StoTrackActionValue.imp.description
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
            stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Called when an object is shown
    ///
    /// - Parameter stoFormat: Received format
    public func view(stoFormat: StoFormat) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "view") {
                return;
            }
            
            if stoTrackerHelper.isViewed(stoFormatId: stoFormat.uniqueID) {
                return;
            }
            
            StoLog.i(message: "view call..." )
            
            stoTrackerHelper.addViewedObject(stoFormatId: stoFormat.uniqueID)
            stoQueryString.qspTrackAction.value = StoTrackActionValue.view.description
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
            stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Called on creation of the format
    /// Check availability of products, delete button if product unavailable
    /// Sends the number of available products for the format
    ///
    /// - Parameter stoFormatWithButtons: Received format with buttons
    public func isFormatAvailable(stoFormatWithButtons: StoFormatWithButtons) -> Bool {
        StoLog.i(message: "isFormatAvailable")
        
        // Retrieve list of all Products
        let products = StoCrawl.sharedInstance.requestProducts(ids: stoFormatWithButtons.getProducts())
        
        if let stoProducts = products {
            if stoProducts.isEmpty {
                
                var hasExclusive = false
                for buttonContent in stoFormatWithButtons.getButtonContentList() {
                    if buttonContent.isMandatory {
                        hasExclusive = true
                    }
                }
                
                stoFormatWithButtons.setButtonContentList(list: [])
                availability(stoFormat: stoFormatWithButtons, nbProductAvailable: 0, hasMandatoryButtonUnavailable: hasExclusive)
                
                return false;
            }
            
            var buttonContentList = stoFormatWithButtons.getButtonContentList()
            var i = 0
            var hasExclusive = false
            while i < buttonContentList.count {
                let buttonContent = buttonContentList[i]
                var buttonProductIds = buttonContent.productIds
                for buttonProductId in buttonProductIds {
                    
                    let product : StoProduct? = StoTracker.getProductInList(productList: stoProducts, productId: buttonProductId)
                    if product == nil || !(product!.isAvailable) {
                        buttonProductIds.removeAll { $0 == buttonProductId }
                    } else {
                        buttonContent.productId = buttonProductId
                    }
                }

                if buttonProductIds.isEmpty {
                    if buttonContent.isMandatory {
                        hasExclusive = true
                    }
                    buttonContentList.removeAll { $0.position == buttonContent.position && $0.buttonName == buttonContent.buttonName }
                    i -= 1
                } else if i == 0 {
                    stoFormatWithButtons.setProductIdSelected(productId: buttonProductIds[0])
                }
                i += 1
            }
            
            stoFormatWithButtons.setButtonContentList(list: buttonContentList)
            availability(stoFormat: stoFormatWithButtons, nbProductAvailable: buttonContentList.count, hasMandatoryButtonUnavailable: hasExclusive)
            
            if buttonContentList.isEmpty {
                return false
            } else if hasExclusive {
                return false
            }
            return true
        }
        
        StoLog.d(message: "checkAvailabilityProducts can't retrieve products")
        return false
    }
    
    
    /// Called on creation of the format
    /// Sends the number of available products for the format
    ///
    /// - Parameter stoFormatWithButtons: Received format
    /// - Parameter nbProductAvailable: Number of products available
    /// - Parameter hasMandatoryButtonUnavailable: if a mandatory button has no product available
    public func availability(stoFormat: StoFormat, nbProductAvailable: Int, hasMandatoryButtonUnavailable: Bool) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "availability") {
                return;
            }
            
            StoLog.i(message: "availability call... \(hasMandatoryButtonUnavailable)")
            
            if !stoTrackerHelper.isAvailProdSent(uniqueID: stoFormat.uniqueID) {
                stoTrackerHelper.addAvailProductsSent(uniqueID: stoFormat.uniqueID)
                stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                stoQueryString.qspTrackAction.value = StoTrackActionValue.avail.description
                stoQueryString.qspTrackValue.value = String(nbProductAvailable)
                if hasMandatoryButtonUnavailable {
                    stoQueryString.qspTrackLabel.value = "nodisplay"
                }
                stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
                stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
                
                stoQueryString.printQuery(detailsOn: false)
                stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
            } else {
                StoLog.i(message: "availability: the view has already been builded")
            }
        }
    }
    
    /// Called when a button in the format is clicked
    ///
    /// - Parameter stoFormat: Received format
    /// - Parameter productId: Product id
    public func browse(stoFormat: StoFormat, productId: String) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "browse") {
                return;
            }
            
            StoLog.i(message: "browse call...")
            
            if let stoProduct = StoCrawl.sharedInstance.getProduct(byId: productId) {
                stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                stoQueryString.qspTrackAction.value = StoTrackActionValue.act.description
                stoQueryString.qspTrackEvent.value = StoTrackEventValue.BrowsePdtc.description
                stoQueryString.qspProductLabel.value = StoTrackerUtils.getFormattedProductLabel(productLabel: stoProduct.name)
                stoQueryString.qspTrackLabel.value = productId
                stoQueryString.qspProductId.value = productId
                stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
                stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
                
                stoQueryString.printQuery(detailsOn: false)
                stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
            } else {
                reportError(stoQueryString: stoQueryString, message: "browse: can't retrieve StoProduct with productIdSelected")
            }
        }
    }
    
    /// Called when a product page in a StoFormat is clicked
    ///
    /// - Parameter stoFormat: Received format
    /// - Parameter productId: Product id
    public func openProductPage(stoFormat: StoFormat, productId: String) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "openProductPage") {
                return;
            }
            
            StoLog.i(message: "openProductPage call...")
            
            if let stoProduct = StoCrawl.sharedInstance.getProduct(byId: productId) {
                
                stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                stoQueryString.qspTrackAction.value = StoTrackActionValue.act.description
                stoQueryString.qspTrackEvent.value = StoTrackEventValue.OpenPdp.description
                stoQueryString.qspProductLabel.value = StoTrackerUtils.getFormattedProductLabel(productLabel: stoProduct.name)
                stoQueryString.qspTrackLabel.value = productId
                stoQueryString.qspProductId.value = productId
                stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
                stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
                
                stoQueryString.printQuery(detailsOn: false)
                stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
            }
        }
    }
    
    /// Called when the "add to list" button from a product page in a StoFormat is clicked
    ///
    /// - Parameter stoFormat: Received format
    /// - Parameter productId: Product id added to wish list
    public func addToList(stoFormat: StoFormat, productId: String) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "addToList") {
                return;
            }
            
            StoLog.i(message: "addToList call...")
            
            if let stoProduct = StoCrawl.sharedInstance.getProduct(byId: productId) {
                
                stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                stoQueryString.qspTrackAction.value = StoTrackActionValue.act.description
                stoQueryString.qspTrackEvent.value = StoTrackEventValue.AddToList.description
                stoQueryString.qspProductLabel.value = StoTrackerUtils.getFormattedProductLabel(productLabel: stoProduct.name)
                stoQueryString.qspTrackLabel.value = productId
                stoQueryString.qspProductId.value = productId
                stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
                stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
                
                stoQueryString.printQuery(detailsOn: false)
                stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
            }
        }
    }
    
    /// Called when the "add to shopping cart" button from a product page in a StoFormat is clicked
    ///
    /// - Parameter stoFormat: Received format
    /// - Parameter productId: Product id added to basket
    /// - Parameter eventValue: Specific event (AbkBtn | QuantityChange | QuantityMore | QuantityLess)
    public func basket(stoFormat: StoFormat, productId: String, eventValue: StoTrackEventValue) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "basket") {
                return;
            }
            
            StoLog.i(message: "basket call...")
            
            if let stoProduct = StoCrawl.sharedInstance.getProduct(byId: productId) {
                stoQueryString.qspTrackAction.value = StoTrackActionValue.abk.description
                stoQueryString.qspTrackEvent.value = eventValue.description
                stoQueryString.qspProductLabel.value = StoTrackerUtils.getFormattedProductLabel(productLabel: stoProduct.name)
                stoQueryString.qspTrackLabel.value = productId
                stoQueryString.qspProductId.value = productId
                stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
                stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
                
                if let document = StoTrackerUtils.getAEXMLDocument(product: stoProduct, trackEventValue: eventValue) {
                    stoQueryString.printQuery(detailsOn: false)
                    stoRequestHandler.requestPost(url_to_request: stoQueryString.getQueryString(), data: document)
                } else {
                    reportError(stoQueryString: stoQueryString, message: "basket: Can't create XML Document")
                }
            }
        }
    }
    
    /// Called when a CTA Option is clicked
    ///
    /// - Parameter stoFormat: Received format
    /// - Parameter optionType: Option type of format. Should be .redirection, .video or .pdf
    public func openOption(stoFormat: StoFormat, optionType: StoFormatOptionType) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkFormat(stoQueryString: stoQueryString, stoFormat: stoFormat, event: "openOption") {
                return;
            }
            
            StoLog.i(message: "openOption call...")
            
            var action : StoTrackActionValue? = nil
            var event : StoTrackEventValue? = nil
            
            switch optionType {
            case .redirection:
                action = .clk
                event = .cta
            case .video:
                action = .act
                event = .openVideo
            case .pdf:
                action = .act
                event = .openPdf
            default:
                return
            }
            
            if let action = action, let event = event {
                stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                stoQueryString.qspTrackAction.value = action.description
                stoQueryString.qspTrackEvent.value = event.description
                stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                stoQueryString.qspPositionObject.value = String(stoFormat.position + 1)
                stoQueryString.updateByQSP(queryStringParams: stoFormat.queryStringParamsList)
                
                stoQueryString.printQuery(detailsOn: false)
                stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
            }
        }
    }
    
    /// Has to be called, when the user clicks on the product
    ///
    /// - Parameter productId: Product identifier
    /// - Parameter productLabel: Product name
    public func openNativeProductPage(productId: String, productLabel: String) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkNativeProduct(stoQueryString: stoQueryString, productId: productId, productName: productLabel, event: "openNativeProductPage") {
                return;
            }
            
            StoLog.i(message: "openNativeProductPage call...")
            
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspTrackAction.value = StoTrackActionValue.fp.description
            stoQueryString.qspProductLabel.value = StoTrackerUtils.getFormattedProductLabel(productLabel: productLabel)
            stoQueryString.qspTrackLabel.value = productId
            stoQueryString.qspProductId.value = productId
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Has to be called, when the user add a native product to basket
    ///
    /// - Parameter productId: Product identifier
    /// - Parameter productLabel: Product name
    public func nativeBasket(productId: String, productLabel: String) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if checkNativeProduct(stoQueryString: stoQueryString, productId: productId, productName: productLabel, event: "nativeBasket") {
                return;
            }
            
            StoLog.i(message: "nativeBasket call...")
            
            stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
            stoQueryString.qspTrackAction.value = StoTrackActionValue.abp.description
            stoQueryString.qspProductLabel.value = StoTrackerUtils.getFormattedProductLabel(productLabel: productLabel)
            stoQueryString.qspTrackLabel.value = productId
            stoQueryString.qspProductId.value = productId
            stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
            stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
            
            stoQueryString.printQuery(detailsOn: false)
            stoRequestHandler.requestGet(stringQuery: stoQueryString.getQueryString())
        }
    }
    
    /// Has to be called, when the user pays his shopping cart
    ///
    /// - Parameter purchaseOrderNumber: Unique identifier of the checkout
    public func buy(purchaseOrderNumber: String) {
        if (!enableGDPR) {
            let stoQueryString = newStoQueryString()
            
            if purchaseOrderNumber.isEmpty {
                reportError(stoQueryString: stoQueryString, message: "buy: purchase order number is empty")
                return
            }
            
            StoLog.i(message: "buy call...")
            
            if let productBasketList = StoAppCommunicator.sharedInstance.stoGetBasketProducts(), productBasketList.count > 0 {
                if let document = StoTrackerUtils.getAEXMLDocument(stoProductBasketList: productBasketList, purchaseOrderNumber: purchaseOrderNumber) {
                    
                    stoQueryString.qspRetailPage.value = "confirmed_purchase"
                    stoQueryString.qspTrackAction.value = StoTrackActionValue.buy.description
                    stoQueryString.qspTrackTime.value = stoTrackerHelper.getTrackTime()
                    stoQueryString.qspSessionTime.value = stoTrackerHelper.getSessionTime()
                    stoQueryString.qspSessionPages.value = stoTrackerHelper.getSessionPages(retailPage: stoQueryString.qspRetailPage.value)
                    stoQueryString.qspPageType.value = ""
                    
                    stoQueryString.printQuery(detailsOn: false)
                    stoRequestHandler.requestPost(url_to_request: stoQueryString.getQueryString(), data: document)
                } else {
                    reportError(stoQueryString: stoQueryString, message: "buy: Can't create XML Document")
                }
            } else {
                reportError(stoQueryString: stoQueryString, message: "buy: Can't retrieve shopping cart products")
            }
        }
    }
    
    private func newStoQueryString() -> StoQueryString {
        let stoQueryString = StoQueryString()
        
        stoQueryString.qspRetailName.value = retailName
        stoQueryString.qspRetailPage.value = retailPage
        stoQueryString.qspRetailShop.value = retailShop
        stoQueryString.qspVerifUID.value = stoTrackerHelper.getVerifUID()
        stoQueryString.qspForcedCity.value = StoTrackerUtils.getFormattedForcedCity(forcedCity: forcedCity)
        stoQueryString.qspForcedLatitude.value = forcedLatitude
        stoQueryString.qspForcedLongitude.value = forcedLongitude
        stoQueryString.qspOptinOut.value = (enableGDPR) ? "0" : "1"
        stoQueryString.qspTechBrowserV.value = appVersion
        
        let pageType = stoTrackerHelper.getStoPageType()
        stoQueryString.qspPageType.value = (pageType.description)
        
        return stoQueryString
    }
    
    private func checkFormat(stoQueryString: StoQueryString, stoFormat: StoFormat, event: String) -> Bool {
        if stoFormat.uniqueID.isEmpty {
            reportError(stoQueryString: stoQueryString, message: "\(event): uniqueId is null or empty!")
            return true
        }
        
        if stoFormat.position == -1 {
            reportError(stoQueryString: stoQueryString, message: "\(event): position of format is not set!")
            return true
        }
        
        let params = stoFormat.queryStringParamsList
        if params.isEmpty {
            reportError(stoQueryString: stoQueryString, message: "\(event): it's not a StoView because StoQueryStringParam list is null. No request will be sent!")
            return true
        }
        
        return false;
    }
    
    private func checkNativeProduct(stoQueryString: StoQueryString, productId: String, productName: String, event: String) -> Bool {
        if productId.isEmpty {
            reportError(stoQueryString: stoQueryString, message: "\(event): productId is empty!")
            return true
        }
        if productName.isEmpty {
            reportError(stoQueryString: stoQueryString, message: "\(event): productName is empty!")
            return true
        }
        return false
    }
    
    private func reportError(stoQueryString: StoQueryString, message: String) {
        StoLog.e(message: message)
        stoErrorHandler.reportError(stoQueryStirng: stoQueryString, trackeEvent: StoTrackEventValue.onDeliver, trackLabel: message)
    }
    
    private static func getProductInList(productList: [StoProduct], productId: String) -> StoProduct? {
        for product in productList {
            if product.id.elementsEqual(productId) {
                return product
            }
        }
        return nil
    }
}

