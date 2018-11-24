//
//  AskForRatingManager.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 24/11/2018.
//  Copyright © 2018 Michal Lučanský. All rights reserved.
//

import Foundation
import StoreKit

class AskForRatingManager {
    
    private let runIncrementerSetting = "numberOfRuns"
    private let minimumRunCount = 5
    
    static let instance = AskForRatingManager()
    
    private init(){}
    
    func incrementAppRuns() {
        let usD = UserDefaults()
        let runs = getRunCounts() + 1
        usD.setValuesForKeys([runIncrementerSetting: runs])
        usD.synchronize()
    }
    
    private func getRunCounts () -> Int {
        
        let usD = UserDefaults()
        let savedRuns = usD.value(forKey: runIncrementerSetting)
        
        var runs = 0
        if (savedRuns != nil) {
            
            runs = savedRuns as! Int
        }
        return runs
    }
    
    func showReview() {
        
        let runs = getRunCounts()
        if (runs > minimumRunCount) {
            SKStoreReviewController.requestReview()
        }
    }
}


