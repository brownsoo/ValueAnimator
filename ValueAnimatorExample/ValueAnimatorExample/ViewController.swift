//
//  ViewController.swift
//  ValueAnimatorExample
//
//  Created by hyonsoo han on 2018. 5. 3..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit
import ValueAnimator

class ViewController: UIViewController {
    
    let countLb = UILabel()
    let rect1 = UIView()
    let rect2 = UIView()
    let rect2Lb = UILabel()
    var yoyoAni: ValueAnimator!
    var rect2Ani: ValueAnimator!
    
    var compatTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.topAnchor
        } else {
            return self.view.topAnchor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ValueAnimator.debug = true
        let parent = self.view!
        
        var label = UILabel()
        parent.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "* linear animation: from 0 to 30 in 30sec"
        label.frame = CGRect(x: 24, y: 50, width: 100, height: 100)
        label.sizeToFit()
        
        countLb.font = UIFont.systemFont(ofSize: 24)
        parent.addSubview(countLb)
        countLb.textColor = UIColor.black
        countLb.text = "0"
        countLb.frame = CGRect(x: 24, y: 70, width: 200, height: 30)
        countLb.backgroundColor = UIColor.yellow
        
        label = UILabel()
        parent.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "* yoyo animation: from 30 to 150"
        label.frame = CGRect(x: 24, y: 120, width: 100, height: 100)
        label.sizeToFit()
        parent.addSubview(rect1)
        rect1.backgroundColor = UIColor(red: 75/255.0, green: 212/255.0, blue: 248/255.0, alpha: 1.0)
        rect1.frame = CGRect(x: 24, y: 140, width: 30, height: 20)
        let btnControl = UIButton(type: .roundedRect)
        btnControl.setTitle("Pause", for: .normal)
        btnControl.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnControl.frame = CGRect(x: 24, y: 170, width: 100, height: 20)
        btnControl.setNeedsLayout()
        parent.addSubview(btnControl)
        btnControl.addTarget(self, action: #selector(onClickControl), for: .touchUpInside)
        
        label = UILabel()
        parent.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "* 5 repeated animation: from 30 to 150"
        label.frame = CGRect(x: 24, y: 240, width: 100, height: 100)
        label.sizeToFit()
        parent.addSubview(rect2)
        rect2.backgroundColor = UIColor(red: 39/255.0, green: 222/255.0, blue: 173/255.0, alpha: 1.0)
        rect2.frame = CGRect(x: 24, y: 260, width: 30, height: 20)
        rect2Lb.font = UIFont.systemFont(ofSize: 12)
        rect2Lb.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        rect2.addSubview(rect2Lb)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
        ValueAnimator.animate("count", from: 0, to: 30, duration: 30, easing: EaseLinear.easeNone()) { p, v in
            let intValue = Int(v.value)
            self.countLb.text = "\(intValue)"
            }.resume()
        // yoyo
        yoyoAni = ValueAnimator.animate("rect1", from: 30, to: 150, duration: 1.4,
                              easing: EaseSine.easeInOut(),
                              onChanged: { p, v in
            self.rect1.frame = CGRect(x: 24, y: 140, width:v.cg, height:20)
        }, option: ValueAnimator.OptionBuilder().setYoyo(true).build())
        yoyoAni.resume()
        
        // repeat
        rect2Ani = ValueAnimator.animate("rect2", from: 30, to: 150, duration: 1.4,
                              easing: EaseSine.easeInOut(),
                              onChanged: { p, v in
            self.rect2.frame.origin = CGPoint(x: v.cg, y: 190)
            self.rect2Lb.text = "\(self.rect2Ani.counted)"
        }, option: ValueAnimator.OptionBuilder().setRepeatCount(5).build())
        rect2Ani.resume()
        
    }
    
    @objc
    private func onClickControl(_ sender: UIButton) {
        if yoyoAni.isAnimating {
            yoyoAni.pause()
        } else {
            yoyoAni.resume()
        }
    }
    
}

