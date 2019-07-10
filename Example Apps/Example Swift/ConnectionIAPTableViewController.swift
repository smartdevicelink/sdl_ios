//
//  ConnectionIAPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//
import UIKit

class ConnectionIAPTableViewController: UITableViewController, ProxyManagerDelegate {
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var connectButton: UIButton!

    var proxyState = ProxyState.stopped

    override func viewDidLoad() {
        super.viewDidLoad()
        ProxyManager.sharedManager.delegate = self
        table.keyboardDismissMode = .onDrag
        table.isScrollEnabled = false
        initButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initButton() {
        self.connectTableViewCell.backgroundColor = UIColor.red
        self.connectButton.setTitle("Connect", for: .normal)
        self.connectButton.setTitleColor(.white, for: .normal)
    }
    // MARK: - IBActions
    @IBAction func connectButtonWasPressed(_ sender: UIButton) {
        switch proxyState {
        case .stopped:
            ProxyManager.sharedManager.start(with: .iap)
        case .searching:
            ProxyManager.sharedManager.stopConnection()
        case .connected:
            ProxyManager.sharedManager.stopConnection()
        }
    }
    // MARK: - Delegate Functions
    func didChangeProxyState(_ newState: ProxyState) {
        proxyState = newState
        var newColor: UIColor? = nil
        var newTitle: String? = nil

        switch newState {
        case .stopped:
            newColor = UIColor.red
            newTitle = "Connect"
        case .searching:
            newColor = UIColor.blue
            newTitle = "Stop Searching"
        case .connected:
            newColor = UIColor.green
            newTitle = "Disconnect"
        }

        if (newColor != nil) || (newTitle != nil) {
            DispatchQueue.main.async(execute: {[weak self]() -> Void in
                self?.connectTableViewCell.backgroundColor = newColor
                self?.connectButton.setTitle(newTitle, for: .normal)
                self?.connectButton.setTitleColor(.white, for: .normal)
            })
        }
    }
}
