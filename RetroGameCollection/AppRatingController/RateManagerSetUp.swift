//
//  RateManagerSetUp.swift
//  Tap Mania
//
//  Created by Michal Lučanský on 25/11/2018.
//  Copyright © 2018 Michal Lucansky. All rights reserved.
//

import Foundation

public struct Constants {
    
    static let alertConfiguration = AlertConfiguration(email: "lucansky.michal@gmail.com",
                                                       subject: "App review RetroGames - iOS \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "") ",
        appStoreUrl: "itms-apps://itunes.apple.com/app/id\(1436408674)",
        initialTimeInDays: 14,
        nextTimeInDays: [AlertButtonType.rate: Int.max, AlertButtonType.feedback: 30, AlertButtonType.close: 14],
        maxLaunchNumber: 4)
    
}
