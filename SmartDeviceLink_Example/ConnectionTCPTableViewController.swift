//
//  ConnectionTCPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//
import UIKit

class ConnectionTCPTableViewController: UITableViewController, UINavigationControllerDelegate, ProxyManagerDelegate {

    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var table: UITableView!

    var state: SDLProxyState = .stopped

    override func viewDidLoad() {
        super.viewDidLoad()
        ProxyManager.sharedManager.delegate = self
        table.keyboardDismissMode = .onDrag
        table.isScrollEnabled = false
        ipAddressTextField.text = AppUserDefaults.shared.ipAddress
        portTextField.text = AppUserDefaults.shared.port
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

        let ipAddress = ipAddressTextField.text
        let port = portTextField.text

        if ipAddress != "" || port != "" {
            AppUserDefaults.shared.ipAddress = ipAddress
            AppUserDefaults.shared.port = port

            switch state {
            case .stopped:
                ProxyManager.sharedManager.start(with: .TCP)
            case .searching:
                ProxyManager.sharedManager.resetConnection()
            case .connected:
                ProxyManager.sharedManager.resetConnection()
            }
        } else {
            let alertMessage = UIAlertController(title: "Missing Info!", message: "Make sure to set your IP Address and Port", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    // MARK: - Delegate Functions
    func didChangeProxyState(_ newState: SDLProxyState) {
        state = newState
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
