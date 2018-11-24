//
//  GameCenterManager.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 24/11/2018.
//  Copyright © 2018 Michal Lučanský. All rights reserved.
//

import Foundation
import GameKit

enum LeaderBoardType: String {
    case blockBreaker = "BlockBreaker"
    case spaceInvaders = "spaceInvaders"
    case snake = "snake"
}

class GameCenterManager: NSObject, GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    static let instance: GameCenterManager = GameCenterManager()
    
    private override init() {
        
    }
    
    func authentificatePlayer() {
        
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController, error) in
            
            if let vc = viewController, let rootVc = UIApplication.shared.keyWindow?.rootViewController {
                rootVc.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func saveScore(score: Int, leaderBoardId: LeaderBoardType) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: leaderBoardId.rawValue)
            scoreReporter.value = Int64(score)
            GKScore.report([scoreReporter]) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func showLeaderboard(gcDelegate: GKGameCenterControllerDelegate) {
        let viewControllerVar = UIApplication.shared.keyWindow?.rootViewController 
        let gameCenterController = GKGameCenterViewController()
        gameCenterController.view.tintColor = .red
        gameCenterController.gameCenterDelegate = gcDelegate
        viewControllerVar?.present(gameCenterController, animated: true,
                                   completion: nil)
    }
    
}

