//
//  ViewController.swift
//  MonitorKit
//
//  Created by chenshuangma@foxmail.com on 07/10/2023.
//  Copyright (c) 2023 chenshuangma@foxmail.com. All rights reserved.
//

import UIKit
import MonitorKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CatonMonitor.shared.startMonitor()
        CatonMonitor.shared.catonStackCallback = { res in
            print(res)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickCaton(_ sender: UIButton) {
        sleep(15)
    }
}

