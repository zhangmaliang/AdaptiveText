//
//  AdaptiveText.swift
//  AdaptiveText
//
//  Created by apple on 16/1/18.
//  Copyright © 2016年 apple. All rights reserved.
//  自动适配屏幕的textView和TextField类，解决键盘弹出时挡住输入框的问题

import UIKit

/// 键盘顶部距离输入框的间距
private let kMargin: CGFloat = 8

// MARK: - 自动适配屏幕的textField类

class AdaptiveTextField: UITextField {
    
    lazy var adaptiveText: AdaptiveText? = {
        return AdaptiveText()
    }()
    
    /// 必传参数，弹出键盘时希望移动的视图，一般是self.view
    var animationView: UIView? {
        didSet{
            adaptiveText!.animationView = animationView
            
            adaptiveText!.textField = self
        }
    }
}


// MARK: - 自动适配屏幕的textView类

class AdaptiveTextView: UITextView {
    
    lazy var adaptiveText: AdaptiveText? = {
        return AdaptiveText()
    }()
    
    /// 必传参数，弹出键盘时希望移动的视图，一般是self.view
    var animationView: UIView? {
        didSet{
            adaptiveText!.animationView = animationView
            
            adaptiveText!.textView = self
        }
    }
}


// MARK: - 内部封装视图,让textField和textView公用一份代码

class AdaptiveText: NSObject {
    
    /// 下面两个参数必须且只能赋值一个
    var textField: AdaptiveTextField?
    
    var textView: AdaptiveTextView?
    
    /// 必传参数，弹出键盘时希望移动的视图，一般是self.view
    var animationView: UIView? {
        
        didSet{
            assert(animationView != nil, "所传入的视图不能为空")
            
            NSNotificationCenter.defaultCenter().addObserver(self,selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        }
    }
    
    func keyboardWillChangeFrame(noti: NSNotification) {
        
        // 当前输入框是否为第一响应者，过滤其他输入框视图引起的键盘出现\消失事件
        var isFirstResponder = false
        
        if textField != nil {
            isFirstResponder = textField!.isFirstResponder()
        }else {
            isFirstResponder = textView!.isFirstResponder()
        }
        
        if isFirstResponder == false {
            return
        }

        // 计算移动视图的距离
        let keyboardFrame = noti.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        var textRect: CGRect?

        // 转换坐标系
        if textField != nil {
            textRect = textField!.convertRect(textField!.bounds, toView: animationView!)
        }else{
            textRect = textView!.convertRect(textView!.bounds, toView: animationView!)
        }
        
        let marginY = CGRectGetMaxY(textRect!) - keyboardFrame.origin.y + kMargin
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.animationView!.frame.origin.y = marginY > 0 ? -marginY : 0
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
