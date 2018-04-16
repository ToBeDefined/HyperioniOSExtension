//
//  ViewController.swift
//  Example
//
//  Created by TBD on 2018/4/12.
//  Copyright © 2018年 TBD. All rights reserved.
//

import UIKit
import HYPEnviromentSelector
import HYPFPSMonitor

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showEnvSelector(_ sender: Any) {
        HYPEnvironmentSelectorPlugin.showEnvironmentSelectorWindow(animated: true, completionBlock: nil)
    }
    
    @IBAction func showFPSMonitor(_ sender: Any) {
        HYPFPSMonitorPlugin.isCanTouchFPSView = false;
        HYPFPSMonitorPlugin.showFPSMonitor()
    }
    
    @IBAction func hideFPSMonitor(_ sender: Any) {
        HYPFPSMonitorPlugin.hideFPSMonitor()
    }
}

