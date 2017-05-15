//
//  ConnectionContainerViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit

class ConnectionContainerViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var viewControllers:NSMutableArray = []
    var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.isTranslucent = false
        // Create object of storyboards
        let tcpControllerStoryboard = UIStoryboard(name: "ConnectionTCPTableViewController", bundle: nil)
        let iapControllerStoryboard = UIStoryboard(name: "ConnectionIAPTableViewController", bundle: nil)
        // Create object of viewController
        let tcpController = tcpControllerStoryboard.instantiateViewController(withIdentifier :"ConnectionTCPTableViewController")
        let iapController = iapControllerStoryboard.instantiateViewController(withIdentifier :"ConnectionIAPTableViewController")
        // Add view controllers to array
        viewControllers.add(tcpController)
        viewControllers.add(iapController)
        // set segmentedControl to left value (TCP)
        segmentedControl.selectedSegmentIndex = 0
        // Call the to add initial VC as SubView
        loadChildViewController(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Listen for changes in segmentedControl
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            // Remove other VC from view
            removeFromView()
            // Load up the VC we want
            loadChildViewController(index: 0)
        case 1:
            // Remove other VC from view
            removeFromView()
            // Load up the VC we want
            loadChildViewController(index: 1)
        default:
            break
        }
    }
    
    func removeFromView(){
        let vc = self.childViewControllers.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
    }
    
    func loadChildViewController(index: Int?) {
        let initialViewController: UIViewController = viewControllers[index!] as! UIViewController
        self.addChildViewController(initialViewController)
        view.addSubview(initialViewController.view)
        initialViewController.didMove(toParentViewController: self)
    }

}

