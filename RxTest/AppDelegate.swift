//
//  AppDelegate.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        /// 提示框时间设置
        SVProgressHUD.setMinimumDismissTimeInterval(2)

        IQKeyboardManager.shared.enable = true

//        let vc = ViewController.init()
//        let vc = TabBarController.init()
//        let nav = BaseNavigationController.init(rootViewController: vc)
        if UserDefault.getCurrentMnemonic() != nil {
            let vc = LoginViewController.init()
            window?.rootViewController = vc
        } else {
            let vc  = CreateViewController.init()
            window?.rootViewController = vc
        }
        window?.makeKeyAndVisible()
        
        return true
    }


}

