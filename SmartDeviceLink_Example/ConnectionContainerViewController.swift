//
//  ConnectionContainerViewController.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//
import UIKit

class ConnectionContainerViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var viewControllers: [UIViewController] = []
    var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        let tcpControllerStoryboard = UIStoryboard(name: "ConnectionTCPTableViewController", bundle: nil)
        let iapControllerStoryboard = UIStoryboard(name: "ConnectionIAPTableViewController", bundle: nil)
        let tcpController = tcpControllerStoryboard.instantiateViewController(withIdentifier :"ConnectionTCPTableViewController")
        let iapController = iapControllerStoryboard.instantiateViewController(withIdentifier :"ConnectionIAPTableViewController")
        viewControllers.append(tcpController)
        viewControllers.append(iapController)

        segmentedControl.selectedSegmentIndex = 0
        loadChildViewController(index: 0)

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(slideToLeftWithGestureRecognizer(gestureRecognizer:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(slideToRightWithGestureRecognizer(gestureRecognizer:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slideToLeftWithGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentedControl.selectedSegmentIndex = 1
            removeFromView()
            loadChildViewController(index: 1)
        }
    }
    
    @IBAction func slideToRightWithGestureRecognizer(gestureRecognizer: UISwipeGestureRecognizer) {
        if segmentedControl.selectedSegmentIndex == 1 {
            segmentedControl.selectedSegmentIndex = 0
            removeFromView()
            loadChildViewController(index: 0)
        }
    }
    // Grab changes in segmentedControl
    @IBAction func indexChanged(_ sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            removeFromView()
            loadChildViewController(index: 0)
        case 1:
            removeFromView()
            loadChildViewController(index: 1)
        default:
            break
        }
    }
    // Mark: - View functions
    func removeFromView() {
        let vc = self.childViewControllers.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
    }

    func loadChildViewController(index: Int?) {
        let initialViewController = viewControllers[index!]
        self.addChildViewController(initialViewController)
        view.addSubview(initialViewController.view)
        initialViewController.didMove(toParentViewController: self)
    }
}
