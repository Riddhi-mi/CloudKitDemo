//
//  UIViewController+Alert.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 24/02/22.
//

import Foundation
import UIKit

typealias alertActionHandler = ((UIAlertAction) -> ())?
typealias alertTextFieldHandler = ((UITextField) -> ())
typealias popUpCompletionHandler = (() -> ())
let CancelTitle     =   "Cancel"
let OKTitle         =   "Ok"
typealias AlertViewController = UIAlertController

struct AlertAction {
    
    var title: String = ""
    var type: UIAlertAction.Style? = .default
    var enable: Bool? = true
    var selected: Bool? = false
    
    init(title: String, type: UIAlertAction.Style? = .default, enable: Bool? = true, selected: Bool? = false) {
        self.title = title
        self.type = type
        self.enable = enable
        self.selected = selected
    }
}

public enum AAction: Equatable {
    
    case Ok
    case Yes
    case No
    case Cancel
    case Delete
    case Custom(title:String)
    
    var title: String {
        switch self {
        case .Ok:
            return "Ok"
        case .Yes:
            return "Yes"
        case .No:
            return "No"
        case .Cancel:
            return "Cancel"
        case .Delete:
            return "Delete"
        case .Custom(let title):
            return title
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .Cancel:
            return .cancel
        case .Delete, .No:
            return .destructive
        default:
            return .default
        }
    }
}

//Custom alert with cancel Button
extension UIViewController {
    
    //Biometric alert
    func showGotoSettingsAlert(message: String) {
        let settingsAction = AlertAction(title: "Go to settings")
        
        let alertController = getAlertViewController(type: .alert, with: "Error", message: message, actions: [settingsAction], showCancel: true, actionHandler: { (buttonText) in
            if buttonText == CancelTitle {return}
            
            // open settings
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:])
            }
            
        })
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // show passcode authentication

    
    
    
    // Show Alert or Action sheet
    func getAlertViewController(type: UIAlertController.Style, with title: String?, message: String?, actions:[AlertAction], showCancel: Bool , actionHandler:@escaping ((_ title: String) -> ())) -> AlertViewController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type)
        
        // items
        var actionItems: [UIAlertAction] = []
        
        // add actions
        for (index, action) in actions.enumerated() {
            
            let actionButton = UIAlertAction(title: action.title, style: action.type!, handler: { (actionButton) in
                actionHandler(actionButton.title ?? "")
            })
            
            actionButton.isEnabled = action.enable!
            if type == .actionSheet { actionButton.setValue(action.selected, forKey: "checked") }
            actionButton.setAssociated(object: index)
            
            actionItems.append(actionButton)
            alertController.addAction(actionButton)
        }
        
        // add cancel button
        if showCancel {
            let cancelAction = UIAlertAction(title: CancelTitle, style: .cancel, handler: { (action) in
                actionHandler(action.title!)
            })
            alertController.addAction(cancelAction)
        }
        return alertController
    }
    func presentAlertViewWithTwoButtons(alertTitle: String?, alertMessage: String?, btnOneTitle: String, btnOneTapped: alertActionHandler, btnTwoTitle: String, btnTwoTapped: alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func presentAlertViewWithOneButton(alertTitle: String?, alertMessage: String?, btnOneTitle: String, btnOneTapped: alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Extension of UIViewController For AlertView with Different Numbers of Buttons -

extension UIViewController {
    
    func alertView(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [AAction] = [],  handler: ((AAction) -> Void)? = nil) {
        
        var _actions = actions
        if actions.isEmpty {
            _actions.append(AAction.Ok)
        }
        var arrAction: [UIAlertAction] = []
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let onSelect: ((UIAlertAction) -> Void)? = { (alert) in
            guard let index = arrAction.index(of: alert) else {
                return
            }
            handler?(_actions[index])
        }
        for action in _actions {
            arrAction.append(UIAlertAction(title: action.title, style: action.style, handler: onSelect))
        }
        let _ = arrAction.map({alertController.addAction($0)})
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Extension of UIViewController For AlertView with Different Numbers of UITextField and with Two Buttons. -

extension UIViewController {
    
    /// This Method is used to show AlertView with one TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: TextField Handler , you can directlly get the object of UITextField.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithOneTextField(alertTitle: String?, alertMessage: String?, alertFirstTextFieldHandler: @escaping alertTextFieldHandler, btnOneTitle: String, btnOneTapped: alertActionHandler, btnTwoTitle: String, btnTwoTapped: alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alertController.addTextField { (alertTextField) in
            alertFirstTextFieldHandler(alertTextField)
        }
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// This Method is used to show AlertView with two TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: First TextField Handeler , you can directlly get the object of First UITextField.
    ///   - alertSecondTextFieldHandler: Second TextField Handeler , you can directlly get the object of Second UITextField.
    ///   - btnOneTitle: A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle: A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithTwoTextFields(alertTitle: String?, alertMessage: String?, alertFirstTextFieldHandler: @escaping alertTextFieldHandler, alertSecondTextFieldHandler: @escaping alertTextFieldHandler, btnOneTitle: String, btnOneTapped: alertActionHandler, btnTwoTitle: String, btnTwoTapped: alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        
        alertController.addTextField { (alertFirstTextField) in
            alertFirstTextFieldHandler(alertFirstTextField)
        }
        alertController.addTextField { (alertSecondTextField) in
            alertSecondTextFieldHandler(alertSecondTextField)
        }
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// This Method is used to show AlertView with three TextField and with Two Buttons.
    ///
    /// - Parameters:
    ///   - alertTitle: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want Alert Title.
    ///   - alertMessage: A String value that indicates the title of AlertView , it is Optional so you can pass nil if you don't want alert message.
    ///   - alertFirstTextFieldHandler: First TextField Handeler , you can directlly get the object of First UITextField.
    ///   - alertSecondTextFieldHandler: Second TextField Handeler , you can directlly get the object of Second UITextField.
    ///   - alertThirdTextFieldHandler: Third TextField Handeler , you can directlly get the object of Third UITextField.
    ///   - btnOneTitle:  A String value - Title of button one.
    ///   - btnOneTapped: Button One Tapped Handler (Optional - you can pass nil if you don't want any action).
    ///   - btnTwoTitle:  A String value - Title of button two.
    ///   - btnTwoTapped: Button Two Tapped Handler (Optional - you can pass nil if you don't want any action).
    func presentAlertViewWithThreeTextFields(alertTitle: String?, alertMessage: String?, alertFirstTextFieldHandler: @escaping alertTextFieldHandler, alertSecondTextFieldHandler: @escaping alertTextFieldHandler, alertThirdTextFieldHandler: @escaping alertTextFieldHandler, btnOneTitle: String, btnOneTapped: alertActionHandler, btnTwoTitle: String, btnTwoTapped: alertActionHandler) {
        
        let alertController = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alertController.addTextField { (alertFirstTextField) in
            alertFirstTextFieldHandler(alertFirstTextField)
        }
        alertController.addTextField { (alertSecondTextField) in
            alertSecondTextFieldHandler(alertSecondTextField)
        }
        alertController.addTextField { (alertThirdTextField) in
            alertThirdTextFieldHandler(alertThirdTextField)
        }
        alertController.addAction(UIAlertAction(title: btnOneTitle, style: .default, handler: btnOneTapped))
        alertController.addAction(UIAlertAction(title: btnTwoTitle, style: .default, handler: btnTwoTapped))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
