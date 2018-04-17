//
//  ViewController.swift
//  Example
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

import UIKit
import HYPEnvironmentSelector
import HYPFPSMonitor
import HYPUIMainThreadChecker

class ViewController: UIViewController {
    var subView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
    }

    @IBAction func showEnvSelector(_ sender: Any) {
        HYPEnvironmentSelectorPlugin.showEnvironmentSelectorWindow(animated: true, completionBlock: nil)
    }
    
    @IBAction func showFPSMonitor(_ sender: Any) {
        HYPFPSMonitorPlugin.showFPSMonitor()
    }
    
    @IBAction func hideFPSMonitor(_ sender: Any) {
        HYPFPSMonitorPlugin.hideFPSMonitor()
    }
    
    @IBAction func openUIMainThreadCheck(_ sender: Any) {
        HYPUIMainThreadCheckerPlugin.isShouldCheckUIInMainThread = true
    }
    
    @IBAction func closeUIMainThreadCheck(_ sender: Any) {
        HYPUIMainThreadCheckerPlugin.isShouldCheckUIInMainThread = false
    }
    
    @IBAction func createUIInOtherThread(_ sender: Any) {
        DispatchQueue.init(label: "other thread", qos: .background).async {
            _ = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        }
    }
    
    @IBAction func addUIInOtherThread(_ sender: Any) {
        self.subView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        self.subView?.backgroundColor = .red
        DispatchQueue.init(label: "other thread", qos: .background).async {
            if let subView = self.subView {
                self.view.addSubview(subView)
            }
        }
    }
    
    @IBAction func removeUIInOtherThread(_ sender: Any) {
        DispatchQueue.init(label: "other thread", qos: .background).async {
            self.subView?.removeFromSuperview()
        }
    }
    
    
}

