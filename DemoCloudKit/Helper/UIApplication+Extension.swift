//
//  UIApplication+Extension.swift
//  DemoCloudKit
//
//  Created by Mac-0004 on 24/02/22.
//

import Foundation
import UIKit

// MARK: - Extension of UIApplication -

extension UIApplication {
    
    /// This will return the application AppDelegate instance.
    ///
    ///  This could be nil value also, while using this "appDelegate" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    static var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.delegate as? SceneDelegate
    }
    
    /// This will return the AppDelegate UIWindow instance.
    ///
    ///  This could be nil value also, while using this "appDelegateWindow" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var window: UIWindow? {
        return UIApplication.sceneDelegate?.window
    }
    
    /// This will return the AppDelegate rootViewController instance.
    ///
    ///  This could be nil value also, while using this "appDelegateWindowRootViewController" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    static var rootViewController: UIViewController? {
        return UIApplication.window?.rootViewController
    }
    
    /// This will return the application SceneDelegate instance.
    ///
    ///  This could be nil value also, while using this "sceneDelegate" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    
    /// This will return the SceneDelegate UIWindow instance.
    ///
    ///  This could be nil value also, while using this "sceneWindow" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    
    /// This will return the SceneDelegate  instance.
    ///
    ///  This could be nil value also, while using this "sceneWindowRootViewController" please use if let. If you are not using if let and if this returns nil and when you are trying to unwrapped this value then application will crash.
    //    static var sceneWindowRootVC: UIViewController? {
    //        return UIApplication.sceneWindow?.rootViewController
    //    }
    //
//    UIApplication.shared.keyWindow?
    func topMostVC(viewController: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        
        if let navigationViewController = viewController as? UINavigationController {
            return UIApplication.shared.topMostVC(viewController: navigationViewController.visibleViewController)
        }
        if let tabBarViewController = viewController as? UITabBarController {
            if let selectedViewController = tabBarViewController.selectedViewController {
                return UIApplication.shared.topMostVC(viewController: selectedViewController)
            }
        }
        if let presentedViewController = viewController?.presentedViewController {
            return UIApplication.shared.topMostVC(viewController: presentedViewController)
        }
        return viewController
    }
    
}
