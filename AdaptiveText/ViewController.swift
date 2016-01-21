//
//  ViewController.swift
//  AdaptiveText
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 只需要设置键盘弹出\消失时需要跟随键盘一起动画的视图即可。
        textField.animationView = UIApplication.sharedApplication().windows.last
        textField2.animationView = view
        textView.animationView = view
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
        textView.resignFirstResponder()
    }
  
    
    @IBOutlet weak var textField: AdaptiveTextField!
    @IBOutlet weak var textField2: AdaptiveTextField!
    @IBOutlet weak var textView: AdaptiveTextView!

}

