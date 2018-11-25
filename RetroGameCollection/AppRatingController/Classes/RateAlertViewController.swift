//
//  RateAlertViewController.swift
//  AppRatingController
//
//  Created by ljanosova on 24.10.18.
//

import Foundation
import UIKit
import MessageUI
import FirebaseAnalytics

public enum AlertButtonType {
    case rate
    case feedback
    case close
}

protocol RateAlertViewDelegate: class {
    
    func rateAlertClicked(_ controller: RateAlertViewController, didClick button: AlertButtonType)
}


class RateAlertViewController: UIViewController {
    
    var delegate: RateAlertViewDelegate?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    
    func setAlert(with style: AlertStyle) {
        backgroundView.backgroundColor = style.backgroundColor
    }
    
    @IBAction func rateButtonClicked(_ sender: Any) {
        Analytics.logEvent("Rate Button Clicked", parameters: nil)
        delegate?.rateAlertClicked(self, didClick: .rate)
    }
    
    @IBAction func sendFeedbackClicked(_ sender: Any) {
        Analytics.logEvent("FeedBack Button Clicked", parameters: nil)
        delegate?.rateAlertClicked(self, didClick: .feedback)
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        Analytics.logEvent("Close Button Clicked", parameters: nil)
        delegate?.rateAlertClicked(self, didClick: .close)
    }
    
}
