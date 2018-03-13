//
//  ViewController.swift
//  ValueAnimator
//
//  Created by brownsoo on 03/12/2018.
//  Copyright (c) 2018 brownsoo. All rights reserved.
//

import UIKit
import ValueAnimator

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ValueAnimator.debug = true
        
        var ani = ValueAnimator.of("count", from: 0.0, to: 2, duration: 1,
                                   onChanged: { p, v in })
        ani.endFunction = { print("count finished") }
        ani.resume()
        
        ani = ValueAnimator.of("count2", from: 0.0, to: 4, duration: 10,
                               onChanged: { p, v in print("\(p):\(v)")})
        ani.endFunction = { print("count2 finished") }
        ani.resume()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
            let ani = ValueAnimator.of("count3", from: 0.0, to: 2, duration: 1,
                                       onChanged: { p, v in })
            ani.endFunction = { print("count3 finished") }
            ani.resume()
        })
    }
}

