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
    
    var state: ProxyState = ProxyState.ProxyStateStopped

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegate to self
        delegate = self
        // Tableview setup
        tableView.keyboardDismissMode = .onDrag
        ipAddressTextField.text = UserDefaults.standard.string(forKey: "ipAddress")
        portTextField.text = UserDefaults.standard.string(forKey: "port")
        // Button setup
        initButton()
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
            
            // Initialize (or reset) the SDL manager
            switch state {
            case ProxyState.ProxyStateStopped:
                ProxyManager.sharedManager.connectTCP()
            case ProxyState.ProxyStateSearchingForConnection:
                ProxyManager.sharedManager.reset()
            case ProxyState.ProxyStateConnected:
                ProxyManager.sharedManager.reset()
            }
        }else{
            // Alert the user to put something in
            let alertMessage = UIAlertController(title: "Missing Info!", message: "Make sure to set your IP Address and Port", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    func initButton(){
        self.connectTableViewCell.backgroundColor = UIColor.red
        self.connectButton.setTitle("Connect", for: .normal)
        self.connectButton.setTitleColor(.white, for: .normal)
    }
    // MARK: - Delegate Functions
    func didChangeProxyState(_ newState: ProxyState){
        // Updates state from ProxyManager
        state = newState
        var newColor: UIColor? = nil
        var newTitle: String? = nil

        switch newState {
        case .ProxyStateStopped:
            newColor = UIColor.red
            newTitle = "Connect"
        case .ProxyStateSearchingForConnection:
            newColor = UIColor.blue
            newTitle = "Stop Searching"
        case .ProxyStateConnected:
            newColor = UIColor.green
            newTitle = "Disconnect"
        }
        
        if (newColor != nil) || (newTitle != nil) {
            DispatchQueue.main.async(execute: {() -> Void in
                self.connectTableViewCell.backgroundColor = newColor
                self.connectButton.setTitle(newTitle, for: .normal)
                self.connectButton.setTitleColor(.white, for: .normal)
            })
        }
    }
    
}
