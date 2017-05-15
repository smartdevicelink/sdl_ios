//
//  ConnectionTCPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Brett McIsaac on 5/15/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit
import SmartDeviceLink

class ConnectionTCPTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Tableview setup
        tableView.keyboardDismissMode = .onDrag
        ipAddressTextField.text = UserDefaults.standard.string(forKey: "ipAddress")
        portTextField.text = UserDefaults.standard.string(forKey: "port")
        // Connect Button setup
        connectButton.tintColor = UIColor.white
    }
    
    
}
