//
//  StoFormatsPositions.swift
//  StoretailSDK
//
//  Created by Mikhail POGORELOV on 15/02/2018.
//  Copyright © 2018 Mikhail POGORELOV. All rights reserved.
//

import Foundation


public class StoFormatsPositions {
    
    private let TAG: String = "StoFormatsPositions"
    
    private var finalPositionsList : [Int]
    private var fixedPositionsList : [Int]
    private var repeatingPosition : Int
    
    public init() {
        finalPositionsList = [Int]()
        fixedPositionsList = [Int]()
        repeatingPosition = 0
    }
    
    /// Add multiples positions
    ///
    /// - Parameter positions: List of positions between [1; n]
    public func addFixedPositions(positions: Int...) -> StoFormatsPositions {
        for position in positions {
            _ = self.addFixedPosition(position: position)
        }
        return self
    }
    
    /// Add single position
    ///
    /// - Parameter position: Position between [1; n]
    public func addFixedPosition(position: Int) -> StoFormatsPositions{
        if !fixedPositionsList.contains(position - 1) {
            fixedPositionsList.append(position - 1)
            fixedPositionsList = fixedPositionsList.sorted()
        }
        return self
    }
    
    /// Enable repeating position starting at the last position with a specific interval
    ///
    /// - Parameter interval: Interval between [1; n]
    public func enableRepeatingPositions(interval: Int) -> StoFormatsPositions{
        repeatingPosition = interval
        return self
    }
    
    public func generatePositions(stoFormats : inout [StoFormat], dataCount : Int) {
        finalPositionsList.removeAll()
        finalPositionsList.append(contentsOf: fixedPositionsList)
        
        var fixedPositionsSize = finalPositionsList.count
        let nbFormats = stoFormats.count
        
        if fixedPositionsSize > nbFormats {
            while finalPositionsList.count > nbFormats {
                finalPositionsList.removeLast()
            }
        } else if (repeatingPosition > 0 && fixedPositionsSize > 0 && nbFormats > fixedPositionsSize) {
            while (nbFormats > fixedPositionsSize) {
                let lastPosition = finalPositionsList.last! + repeatingPosition
                
                if (!finalPositionsList.contains(lastPosition)) {
                    finalPositionsList.append(lastPosition)
                }
                fixedPositionsSize += 1
            }
        }
        finalPositionsList = finalPositionsList.sorted()
        
        // Update format positions
        var i = 0
        while i < nbFormats {
            if dataCount >= finalPositionsList[i] {
                stoFormats[i].position = finalPositionsList[i]
            } else {
                break
            }
            i += 1
        }
        
        // Remove all formats that can't be shown
        while stoFormats.last?.position == -1 {
            finalPositionsList.removeLast()
            stoFormats.removeLast()
        }
    }
    
    public func generatePositionsInCollection(stoFormats: inout [StoFormat], dataCount: Int, maxCellPerRow: Int) {
        finalPositionsList.removeAll()
        finalPositionsList.append(contentsOf: fixedPositionsList)
        
        var fixedPositionsSize = finalPositionsList.count
        let nbFormats = stoFormats.count
        
        if fixedPositionsSize > nbFormats {
            while finalPositionsList.count > nbFormats {
                finalPositionsList.removeLast()
            }
        } else if (repeatingPosition > 0 && fixedPositionsSize > 0 && nbFormats > fixedPositionsSize) {
            while (nbFormats > fixedPositionsSize) {
                let lastPosition = finalPositionsList.last! + repeatingPosition
                
                if (!finalPositionsList.contains(lastPosition)) {
                    finalPositionsList.append(lastPosition)
                }
                fixedPositionsSize += 1
            }
        }
        finalPositionsList = finalPositionsList.sorted()
        
        let retainedSizeByFormat = [
            StoFormatType.stoBanner : maxCellPerRow - 1,
            StoFormatType.stoButterfly : 1,
            StoFormatType.stoVignette : 0
        ]
        var retainedSize = 0
        
        // Update format positions
        var i = 0
        while i < nbFormats {
            NSLog("generatePositionsInCollection Format N°\(i) maxCellPerRow \(maxCellPerRow)")
            let position = finalPositionsList[i]
            let finalPosition = (maxCellPerRow * position) - retainedSize
            
            if finalPosition < dataCount {
                stoFormats[i].position = finalPosition
            } else {
                break
            }
            
            NSLog("generatePositionsInCollection position \(position) finalPosition \(finalPosition) retainedSize \(retainedSize)")
            retainedSize += retainedSizeByFormat[stoFormats[i].getFormatType()] ?? 0
            i += 1
        }
        
        // Remove all formats that can't be shown
        while stoFormats.last?.position == -1 {
            finalPositionsList.removeLast()
            stoFormats.removeLast()
        }
    }
    
    public func getFormatsCount(before currentPosition: Int, nbFormats : Int) -> Int{
        var countFormat = 0
        
        for position in finalPositionsList {
            if currentPosition > position && countFormat < nbFormats {
                countFormat += 1
            } else {
                return countFormat
            }
        }
        return countFormat
    }
    
    public static func defaultPositions() -> StoFormatsPositions {
        return StoFormatsPositions()
            .addFixedPositions(positions: 3, 9, 23)
            .enableRepeatingPositions(interval: 10)
    }
}


