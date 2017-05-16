//
//  ConnectionIAPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/15/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit

class ConnectionIAPTableViewController: UITableViewController, ProxyManagerDelegate {
    
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var connectButton: UIButton!
    
    var state: ProxyState = ProxyState.ProxyStateStopped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func connectButtonWasPressed(_ sender: UIButton) {
        
        // Initialize (or reset) the SDL manager
        switch state {
        case ProxyState.ProxyStateStopped:
            ProxyManager.sharedManager.connectIAP()
        case ProxyState.ProxyStateSearchingForConnection:
            ProxyManager.sharedManager.reset()
        case ProxyState.ProxyStateConnected:
            ProxyManager.sharedManager.reset()
        }
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
