//
//  ViewController.swift
//  XHUtilCore
//
//  Created by 梁先华 on 09/10/2022.
//  Copyright (c) 2022 梁先华. All rights reserved.
//

import UIKit
import XHUtilCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let arr = [1,2,3,4,5]
        debuglog("得到的数组是\(arr)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

