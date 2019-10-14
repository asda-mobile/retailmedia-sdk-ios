//
//  StoImageManager.swift
//  StoretailSDK
//
//  Created by Kevin Naudin on 25/07/2019.
//  Copyright © 2019 Mikhail POGORELOV. All rights reserved.
//

import Foundation
import Nuke

protocol StoFormatImageManagerProtocol : class {
    func reloadView()
}

public class StoImageManager: NSObject {
    private var images : [URL: UIImage]
    private let isTablet : Bool
    
    weak var delegate: StoFormatImageManagerProtocol?
    
    public override init() {
        self.images = [:]
        self.isTablet = UIDevice.current.userInterfaceIdiom == .pad
        
        super.init()
    }
    
    public func clear() {
        self.images.removeAll()
    }
    
    public func getImage(for url: URL) -> UIImage? {
        return self.images[url]
    }
    
    public func downloadImagesBeforeReload(formats: [StoFormat], isCollectionView: Bool) {
        // Download images
        var nbImagesDownloaded = 0
        var nbImagesToBeDownload = 0
        
        for format in formats {
            if format.getFormatType() == .stoVignette || format.getFormatType() == .stoBanner {
                nbImagesToBeDownload += 1
            }
        }
        
        if nbImagesToBeDownload == 0 {
            DispatchQueue.main.async {
                self.delegate?.reloadView()
            }
        } else {
            for format in formats {
                if format.getFormatType() == .stoVignette,
                    let stoVignette = format as? StoVignette,
                    let imageUrl = stoVignette.getBackgroundImageURL(isTablet: isCollectionView)
                {
                    ImagePipeline.shared.loadImage(with: imageUrl, progress: nil) { response, err in
                        nbImagesDownloaded += 1
                        if err == nil {
                            self.images[imageUrl] = response?.image
                        }
                        if nbImagesDownloaded == nbImagesToBeDownload {
                            DispatchQueue.main.async {
                                self.delegate?.reloadView()
                            }
                        }
                    }
                } else if format.getFormatType() == .stoBanner,
                    let stoBanner = format as? StoBanner,
                    let imageUrl = stoBanner.getBackgroundImageURL(isTablet: isTablet) {
                    ImagePipeline.shared.loadImage(with: imageUrl, progress: nil) { response, err in
                        nbImagesDownloaded += 1
                        if err == nil {
                            self.images[imageUrl] = response?.image
                        }
                        if nbImagesDownloaded == nbImagesToBeDownload {
                            DispatchQueue.main.async {
                                self.delegate?.reloadView()
                            }
                        }
                    }
                }
            }
        }
    }
}
