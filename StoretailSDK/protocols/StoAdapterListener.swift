//
//  StoAdapterListener.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 12/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation

public protocol StoAdapterListener {
    func stoOpenProduct(productId: String)
    func stoOpenDeeplink(deeplink: String)
    func stoOpenVideo(videoUrl: String)
    func stoOpenPDF(pdfUrl: String)
}
