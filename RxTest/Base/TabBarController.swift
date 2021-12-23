//
//  TabBarController.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setValue(TabBar(), forKeyPath: "tabBar")
        
        tabBar.barTintColor = .white

        addChild("首页", "tabbar_home_nor", "tabbar_home", HomeViewController.self)
        addChild("", "tabbar_add_nft", "tabbar_add_nft", CenterViewController.self)
        addChild("我的", "tabbar_mine", "tabbar_mine_select", MineViewController.self)
    }

    func addChild(_ title: String,
                  _ imageName: String,
                  _ SelectImageName: String,
                  _ type: UIViewController.Type) {
        let nav = UINavigationController(rootViewController: type.init())
        nav.title = title
        nav.tabBarItem.image = UIImage(named: imageName)
        nav.tabBarItem.selectedImage = UIImage(named: SelectImageName)
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font:16,NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        addChild(nav )
    }
}
