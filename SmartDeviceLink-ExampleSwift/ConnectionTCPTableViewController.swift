//
//  ConnectionTCPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/15/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit
import SmartDeviceLink

class ConnectionTCPTableViewController: UITableViewController, UINavigationControllerDelegate, ProxyManagerDelegate {
    
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var connectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate to self
        delegate = self
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
        
        let ipAddress = ipAddressTextField.text
        let port = portTextField.text
        
        if (ipAddress != "" || port != ""){
            // Save to defaults
            UserDefaults.standard.set(ipAddress, forKey: "ipAddress")
            UserDefaults.standard.set(port, forKey: "port")
            
            // Initialize the SDL manager
            _ = ProxyManager.sharedManager.connectTCP()
            
            
        }else{
            // Alert the user to put something in
            let alertMessage = UIAlertController(title: "Missing Info!", message: "Make sure to set your IP Address and Port", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    // MARK: - Delegate Functions
    func didChangeProxyState(_ newState: ProxyState){
        print("UPDATE PROXY STATE CALLED \(newState)")
    }
    
}
