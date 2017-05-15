//
//  ConnectionContainerViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Brett McIsaac on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit

class ConnectionContainerViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var viewControllers = [Any]()
    var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.isTranslucent = false
        // Setup the child VCs
        let tcpControllerStoryboard = UIStoryboard(name: "ConnectionTCPTableViewController", bundle: nil)
        let iapControllerStoryboard = UIStoryboard(name: "ConnectionIAPTableViewController", bundle: nil)
        let tcpController = tcpControllerStoryboard.instantiateViewController(withIdentifier :"ConnectionTCPTableViewController")
        let iapController = iapControllerStoryboard.instantiateViewController(withIdentifier :"ConnectionIAPTableViewController")
        var viewControllers = [tcpController, iapController]

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            print("Case 0")
        case 1:
            print("Case 1")
        default:
            break
        }
    }
    
    func loadInitialChildViewController() {
        // On the initial load, we just add the new child VC with no animation
        let initialViewController: UIViewController? = viewControllers[0] as! UIViewController
        addChildViewController(initialViewController!)
        view.addSubview((initialViewController?.view)!)
        initialViewController?.didMove(toParentViewController: self)
        currentViewController = initialViewController
    }


}

