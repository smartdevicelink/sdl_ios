//
//  ConnectionTabBarController.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Joel Fischer on 9/23/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

import UIKit

class ConnectionTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        selectedIndex = AppUserDefaults.shared.lastUsedSegment
    }
}

extension ConnectionTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items?.firstIndex(where: {$0 == item}) {
            AppUserDefaults.shared.lastUsedSegment = index
        }
    }
}
