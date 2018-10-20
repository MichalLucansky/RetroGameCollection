//
//  LoadingScene.swift
//  RetroGameCollection
//
//  Created by Michal Lučanský on 16.9.18.
//  Copyright © 2018 Michal Lučanský. All rights reserved.
//

import UIKit

class LoadingScene: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        loadingIndicator.stopAnimating()
    }
}
