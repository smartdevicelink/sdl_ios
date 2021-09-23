//
//  ConnectionIAPTableViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//
import UIKit

class ConnectionIAPTableViewController: UITableViewController {
    @IBOutlet weak var connectTableViewCell: UITableViewCell!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var connectButton: UIButton!

    var proxyState = ProxyState.stopped

    override func viewDidLoad() {
        super.viewDidLoad()
        ProxyManager.sharedManager.delegate = self
        title = "iAP"
        table.keyboardDismissMode = .onDrag
        table.isScrollEnabled = false
        configureConnectButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        AppUserDefaults.shared.lastUsedSegment = 1
    }

    private func configureConnectButton() {
        self.connectTableViewCell.backgroundColor = UIColor.systemRed
        self.connectButton.setTitle("Connect", for: .normal)
        self.connectButton.setTitleColor(.white, for: .normal)
    }
}

extension ConnectionIAPTableViewController: ProxyManagerDelegate {
    func didChangeProxyState(_ newState: ProxyState) {
        proxyState = newState
        var newColor: UIColor? = nil
        var newTitle: String? = nil

        switch newState {
        case .stopped:
            newColor = .systemRed
            newTitle = "Connect"
        case .searching:
            newColor = .systemOrange
            newTitle = "Stop Searching"
        case .connected:
            newColor = .systemGreen
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
extension ConnectionIAPTableViewController {
    @IBAction private func connectButtonWasPressed(_ sender: UIButton) {
        switch proxyState {
        case .stopped:
            ProxyManager.sharedManager.start(with: .iap)
        case .searching:
            ProxyManager.sharedManager.stopConnection()
        case .connected:
            ProxyManager.sharedManager.stopConnection()
        }
    }
}
