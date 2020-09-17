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
    var remainLb: UILabel!
    
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
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        }
        let parent = self.view!
        var label = UILabel()
        parent.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "* linear animation: from 0 to 30 in 10sec"
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
        label.text = "* yoyo animation with 2 props"
        label.frame = CGRect(x: 24, y: 120, width: 100, height: 100)
        label.sizeToFit()
        parent.addSubview(rect1)
        rect1.backgroundColor = UIColor(red: 75/255.0, green: 212/255.0, blue: 248/255.0, alpha: 1.0)
        rect1.frame = CGRect(x: 24, y: 140, width: 30, height: 20)
        let controlBt = UIButton(type: .roundedRect)
        controlBt.setTitle("Pause", for: .normal)
        controlBt.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        controlBt.frame = CGRect(x: 24, y: 170, width: 100, height: 20)
        controlBt.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        controlBt.setNeedsLayout()
        controlBt.layer.borderColor = UIColor.blue.cgColor
        controlBt.layer.borderWidth = 1.0
        parent.addSubview(controlBt)
        controlBt.addTarget(self, action: #selector(onClickControl), for: .touchUpInside)
        
        label = UILabel()
        parent.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "* 5 repeated animation: from 30 to 150"
        label.frame = CGRect(x: 24, y: 200, width: 100, height: 100)
        label.sizeToFit()
        parent.addSubview(rect2)
        rect2.backgroundColor = UIColor(red: 39/255.0, green: 222/255.0, blue: 173/255.0, alpha: 1.0)
        rect2.frame = CGRect(x: 24, y: 220, width: 30, height: 20)
        rect2Lb.font = UIFont.systemFont(ofSize: 12)
        rect2Lb.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        rect2.addSubview(rect2Lb)
        
        label = UILabel()
        parent.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "* add new animator"
        label.frame = CGRect(x: 24, y: 260, width: 100, height: 100)
        label.sizeToFit()
        let newBt = UIButton(type: .system)
        parent.addSubview(newBt)
        newBt.setTitle("New Animator", for: .normal)
        newBt.frame = CGRect(x: 24, y: 280, width: 30, height: 20)
        newBt.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        newBt.sizeToFit()
        newBt.layer.borderColor = UIColor.blue.cgColor
        newBt.layer.borderWidth = 1.0
        newBt.addTarget(self, action: #selector(onClickNew), for: .touchUpInside)
        
        remainLb = UILabel()
        parent.addSubview(remainLb)
        remainLb.frame = CGRect(x: 24, y: 340, width: parent.bounds.width - 48, height: 20)
        remainLb.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        remainLb.textColor = UIColor.gray.withAlphaComponent(0.7)
        remainLb.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // linear
        let ani = ValueAnimator.animate("count", from: 0, to: 30, duration: 10, easing: EaseLinear.easeNone())
        ani.changeCallback = { p, v in
            let intValue = Int(v.value)
            let progress = ani.covered / ani.duration
            self.countLb.text = "\(intValue) / progress: \(String(format: "%.2f", progress))"
        }
        ani.endCallback = {
            self.updateRemainedCount()
        }
        ani.resume()
        // yoyo with 2 props
        yoyoAni = ValueAnimator.animate(props: ["h", "w"], from: [20, 30], to: [5, 150], duration: 1.4, easing: EaseSine.easeInOut(), onChanged: { p, v in
            if p == "h" {
                let width = self.rect1.bounds.width
                self.rect1.frame = CGRect(x: 24, y: 140, width: width, height:v.cg)
            } else {
                let height = self.rect1.bounds.height
                self.rect1.frame = CGRect(x: 24, y: 140, width:v.cg, height: height)
            }
        }, option: ValueAnimator.OptionBuilder().setYoyo(true).build())
        yoyoAni.resume()
        
        // repeat
        rect2Ani = ValueAnimator.animate("rect2", from: 30, to: 150, duration: 1.4, easing: EaseStrong.easeInOut(), onChanged: { p, v in
            self.rect2.frame.origin = CGPoint(x: v.cg, y: 220)
            self.rect2Lb.text = "\(self.rect2Ani.counted)"
        }, option: ValueAnimator.OptionBuilder().setRepeatCount(5).build())
        rect2Ani.resume()
        rect2Ani.endCallback = {
            self.updateRemainedCount()
        }
        
        self.updateRemainedCount()
    }
    
    @objc
    private func onClickControl(_ sender: UIButton) {
        if yoyoAni.isAnimating {
            yoyoAni.pause()
        } else {
            yoyoAni.resume()
        }
    }
    
    var newCount = 0
    @objc
    private func onClickNew(_ sender: UIButton) {
        newCount += 1
        let prof = "new\(newCount)"
        let ani = ValueAnimator.animate(prof, from: 0, to: 100, duration: 3.0)
        ani.endCallback = {
            print("finished \(prof)")
            self.updateRemainedCount()
        }
        ani.resume()
        updateRemainedCount()
    }
    
    private func updateRemainedCount() {
        self.remainLb.text = "Remaind Animator count: \(ValueAnimator.count)"
    }
    
}

