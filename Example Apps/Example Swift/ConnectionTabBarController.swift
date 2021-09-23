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

        selectedIndex = AppUserDefaults.shared.lastUsedSegment
    }
}
