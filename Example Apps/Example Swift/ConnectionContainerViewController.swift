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

        let defaultSegment = AppUserDefaults.shared.lastUsedSegment!
        segmentedControl.selectedSegmentIndex = defaultSegment
        loadChildViewController(index: defaultSegment)

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
        let vc = self.children.last
        vc?.view.removeFromSuperview()
        vc?.removeFromParent()
    }

    func loadChildViewController(index: Int?) {
        AppUserDefaults.shared.lastUsedSegment = index
        let initialViewController: UIViewController = viewControllers[index!]
        self.addChild(initialViewController)
        view.addSubview(initialViewController.view)
        initialViewController.didMove(toParent: self)
    }
}
