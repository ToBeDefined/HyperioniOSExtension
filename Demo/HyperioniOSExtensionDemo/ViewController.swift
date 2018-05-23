//
//  ViewController.swift
//  HyperioniOSExtensionDemo
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

import UIKit
#if CUSTOM_DEBUG
import HyperioniOSExtension
#endif

class ViewController: UIViewController {
    var subView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
    }
    
    @IBAction func showEnvSelector(_ sender: Any) {
        #if CUSTOM_DEBUG
        HYPEnvironmentSelectorPlugin.showEnvironmentSelectorWindow(animated: true, isCanCancel: false, completionBlock: nil)
        #endif
    }
    
    @IBAction func showFPSMonitor(_ sender: Any) {
        #if CUSTOM_DEBUG
        HYPFPSMonitorPlugin.showFPSMonitor()
        #endif
    }
    
    @IBAction func hideFPSMonitor(_ sender: Any) {
        #if CUSTOM_DEBUG
        HYPFPSMonitorPlugin.hideFPSMonitor()
        #endif
    }
    
    @IBAction func openUIMainThreadCheck(_ sender: Any) {
        #if CUSTOM_DEBUG
        HYPUIMainThreadCheckerPlugin.isShouldCheckUIInMainThread = true
        #endif
    }
    
    @IBAction func closeUIMainThreadCheck(_ sender: Any) {
        #if CUSTOM_DEBUG
        HYPUIMainThreadCheckerPlugin.isShouldCheckUIInMainThread = false
        #endif
    }
    
    @IBAction func createUIInOtherThread(_ sender: Any) {
        DispatchQueue.init(label: "other thread", qos: .background).async {
            _ = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        }
    }
    
    @IBAction func addUIInOtherThread(_ sender: Any) {
        if self.subView == nil {
            self.subView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
            self.subView?.backgroundColor = .red
        }
        DispatchQueue.init(label: "other thread", qos: .background).async {
            if let subView = self.subView {
                self.view.addSubview(subView)
            }
        }
    }
    
    @IBAction func removeUIInOtherThread(_ sender: Any) {
        if self.subView == nil {
            self.subView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
            self.subView?.backgroundColor = .red
        }
        DispatchQueue.init(label: "other thread", qos: .background).async {
            self.subView?.removeFromSuperview()
        }
    }
    
    
}

