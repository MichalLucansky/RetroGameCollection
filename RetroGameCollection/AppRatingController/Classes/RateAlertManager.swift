//
//  RateAlertManager.swift
//  AppRatingController
//
//  Created by ljanosova on 24.10.18.
//

import Foundation
import MessageUI
import FirebaseAnalytics

public struct AlertStyle {
    var backgroundColor: UIColor
    
    public init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}

public struct AlertConfiguration {
    var email: String
    var subject: String
    var appStoreUrl: String
    var initialTimeInDays: Int
    var nextTimeInDays: [AlertButtonType: Int]
    var maxLaunchNumber: Int
    
    public init(email: String, subject: String, appStoreUrl: String, initialTimeInDays: Int, nextTimeInDays: [AlertButtonType: Int], maxLaunchNumber: Int) {
        self.email = email
        self.subject = subject
        self.appStoreUrl = appStoreUrl
        self.initialTimeInDays = initialTimeInDays
        self.nextTimeInDays = nextTimeInDays
        self.maxLaunchNumber = maxLaunchNumber
    }
}

public class RateAlertManager: NSObject {
    
    private let day = 24.0 * 60.0 * 60.0
    
    public static let shared = RateAlertManager()
    
    var configuration: AlertConfiguration!
    
    var style: AlertStyle!
    
    public func configure(with data: AlertConfiguration) {
        configuration = data
        setInitialNextTime()
        setInitialAction()
    }
    
    public func setStyle(with data: AlertStyle) {
        style = data
    }
    
    public func checkIfShowAlertNow() {
        let launchNumber = UserDefaults.standard.value(forKey: DefaultsConstants.launchNumber) as! Int?
        let nextTime = UserDefaults.standard.value(forKey: DefaultsConstants.rateAlertNextTime) as! Double?
        let action = getAction()
        
        if (launchNumber ?? 0 >= configuration.maxLaunchNumber
            || nextTime ?? Double.infinity <= Date().timeIntervalSince1970
            || action ?? ActionState.initial.rawValue == ActionState.happened.rawValue) {
            presentAlert()
        }
    }
    
    func presentAlert() {
        if let vc = rootViewController() {
            let podBundle = Bundle(for: RateAlertViewController.self)
            
            let bundleURL = podBundle.resourceURL?.appendingPathComponent("AppRatingController.bundle")
            let bundle = Bundle(url: bundleURL!)
            let alertStoryboard = UIStoryboard(name: "RateAlert", bundle: bundle)
            let customAlert = alertStoryboard.instantiateViewController(withIdentifier: "RateAlert") as! RateAlertViewController
            customAlert.providesPresentationContextTransitionStyle = true
            customAlert.definesPresentationContext = true
            customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlert.delegate = self
            Analytics.logEvent("Rating view showed", parameters: nil)
            vc.present(customAlert, animated: true, completion: nil)
//            customAlert.setAlert(with: style)
        }
    }
    
    func setNextTime(if clicked: AlertButtonType) {
        guard let time = configuration.nextTimeInDays[clicked] else {
            fatalError("Configuration data for time are missing")
        }
        UserDefaults.standard.set(Date().timeIntervalSince1970 + (Double(time) * day), forKey: DefaultsConstants.rateAlertNextTime)
    }
    
    func setInitialNextTime() {
        if UserDefaults.standard.value(forKey: DefaultsConstants.rateAlertNextTime) as! Double? == nil {
            UserDefaults.standard.set(Date().timeIntervalSince1970 + (Double(configuration.initialTimeInDays) * day), forKey: DefaultsConstants.rateAlertNextTime)
        }
    }
    
    func resetNextTime() {
        UserDefaults.standard.set(Double.infinity, forKey: DefaultsConstants.rateAlertNextTime)
    }
    
    func resetLaunchNumber() {
        UserDefaults.standard.set(0, forKey: DefaultsConstants.launchNumber)
    }
    
    func resetAction() {
        UserDefaults.standard.set(ActionState.reset.rawValue, forKey: DefaultsConstants.significantAction)
    }
    
    public func setAction() {
        if let action = getAction() {
            if action == ActionState.initial.rawValue {
                UserDefaults.standard.set(ActionState.happened.rawValue, forKey: DefaultsConstants.significantAction)
            }
        } else {
            UserDefaults.standard.set(ActionState.happened.rawValue, forKey: DefaultsConstants.significantAction)
        }
    }
    
    func setInitialAction() {
        if getAction() == nil {
            UserDefaults.standard.set(ActionState.initial.rawValue, forKey: DefaultsConstants.significantAction)
        }
    }
    
    private func getAction() -> String? {
        return UserDefaults.standard.value(forKey: DefaultsConstants.significantAction) as! String?
    }
    
    public func increaseLaunchNumber() {
        let number = UserDefaults.standard.value(forKey: DefaultsConstants.launchNumber) as! Int?
        if let unwrappedNumber = number {
            if unwrappedNumber != 0 {
                UserDefaults.standard.set(unwrappedNumber + 1, forKey: DefaultsConstants.launchNumber)
            }
        } else {
            UserDefaults.standard.set(1, forKey: DefaultsConstants.launchNumber)
        }
    }
    
    public func resetLaunchCountForTesting() -> UIAlertAction {
        let resetLaunchCountAction = UIAlertAction(title: "Reset count of launch" , style: .default , handler: { _ in
            UserDefaults.standard.set(1, forKey: DefaultsConstants.launchNumber)
        })
        return resetLaunchCountAction
    }
    
    func sendFeedback(recipientEmail: String, subject:String, messageBody: String?, presentIn:UIViewController) {
        let mailComposer = MFMailComposeViewController()
        let recipient : [String] = [recipientEmail]
        mailComposer.setToRecipients(recipient)
        mailComposer.setSubject(subject)
        mailComposer.mailComposeDelegate = self
        mailComposer.setMessageBody(messageBody ?? "", isHTML: false)
        presentIn.present(mailComposer, animated: true, completion: nil)
    }
    
    func rootViewController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
}

extension RateAlertManager: RateAlertViewDelegate {
    
    func rateAlertClicked(_ controller: RateAlertViewController, didClick button: AlertButtonType) {
        switch button {
        case .rate:
            resetNextTime()
            resetLaunchNumber()
            resetAction()
            UIApplication.shared.openURL(URL(string: configuration.appStoreUrl)!)
            controller.dismiss(animated: true, completion: nil)
        case .feedback:
            controller.dismiss(animated: false, completion: { [weak self] in
                self?.setNextTime(if: .feedback)
                self?.resetLaunchNumber()
                self?.resetAction()
                if let vc = self?.rootViewController() {
                    self?.sendFeedback(recipientEmail: (self?.configuration.email)!, subject: (self?.configuration.subject)!, messageBody: nil, presentIn: vc)
                }
            })
        case .close:
            setNextTime(if: .close)
            resetLaunchNumber()
            resetAction()
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension RateAlertManager: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

public enum ActionState: String {
    case initial
    case happened
    case reset
}

public struct DefaultsConstants {
    static let launchNumber = "launchNumber"
    static let rateAlertNextTime = "rateAlertNextTime"
    static let significantAction = "significantAction"
}

