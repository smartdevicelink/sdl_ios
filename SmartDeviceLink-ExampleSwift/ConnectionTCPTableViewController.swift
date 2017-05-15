//
//  ConnectionTCPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/15/17.
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func connectButtonWasPressed(_ sender: UIButton) {

    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            return
        }
        switch indexPath.row {
        case 0:
            ipAddressTextField.becomeFirstResponder()
        case 1:
            portTextField.becomeFirstResponder()
        default:
            break
        }
        
    }
}
