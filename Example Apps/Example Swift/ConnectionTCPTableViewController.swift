//
//  ConnectionTCPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//
import UIKit

class ConnectionTCPTableViewController: UITableViewController, UINavigationControllerDelegate {
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var table: UITableView!

    var proxyState = ProxyState.stopped

    override func viewDidLoad() {
        super.viewDidLoad()
        ProxyManager.sharedManager.delegate = self
        title = "TCP"
        table.keyboardDismissMode = .onDrag
        table.isScrollEnabled = false
        ipAddressTextField.text = AppUserDefaults.shared.ipAddress
        portTextField.text = AppUserDefaults.shared.port
        configureConnectButton()
    }

    private func configureConnectButton() {
        self.connectTableViewCell.backgroundColor = UIColor.systemRed
        self.connectButton.setTitle("Connect", for: .normal)
        self.connectButton.setTitleColor(.white, for: .normal)
    }
}

// MARK: - Delegate Functions
extension ConnectionTCPTableViewController: ProxyManagerDelegate {
    func didChangeProxyState(_ newState: ProxyState) {
        proxyState = newState
        var newColor: UIColor? = nil
        var newTitle: String? = nil

        switch newState {
        case .stopped:
            newColor = UIColor.systemRed
            newTitle = "Connect"
        case .searching:
            newColor = UIColor.systemOrange
            newTitle = "Stop Searching"
        case .connected:
            newColor = UIColor.systemGreen
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

// MARK: - IBActions
extension ConnectionTCPTableViewController {
    @IBAction func connectButtonWasPressed(_ sender: UIButton) {
        let ipAddress = ipAddressTextField.text
        let port = portTextField.text

        if ipAddress != "" || port != "" {
            AppUserDefaults.shared.ipAddress = ipAddress
            AppUserDefaults.shared.port = port

            switch proxyState {
            case .stopped:
                ProxyManager.sharedManager.start(with: .tcp)
            case .searching:
                ProxyManager.sharedManager.stopConnection()
            case .connected:
                ProxyManager.sharedManager.stopConnection()
            }
        } else {
            let alertMessage = UIAlertController(title: "Missing Info!", message: "Make sure to set your IP Address and Port", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
}
