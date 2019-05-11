//
//  InputBarView.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/9.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit

struct InputBarLayout {
    static let height: CGFloat = 50.0
    static let interval: CGFloat = 9.5
    static let button: CGSize = CGSize.init(width: 28, height: 28)
    static let inputHeight: CGFloat = 37.0
    static let inputCornerRadius: CGFloat = 6.0
}

class InputBarView: JYBasicView {
    
    lazy var inputTextView: HPGrowingTextView  = {
        let textView = HPGrowingTextView()
        textView.isScrollable = false;
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        textView.returnKeyType = .send; //just as an example
        textView.font = UIFont.pingFangSCMedium(size: 15.0)
        
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return textView
    }()
    
    lazy var leftButton: UIButton = { [unowned self] in
        let button = buildButton(normalImage: #imageLiteral(resourceName: "chat_voice"), selectedImage: #imageLiteral(resourceName: "chat_voice"), highlightedImage: nil)
        return button
    }()
    
    lazy var rightButton: UIButton = { [unowned self] in
        let button = buildButton(normalImage: #imageLiteral(resourceName: "chat_more"), selectedImage: #imageLiteral(resourceName: "chat_more"), highlightedImage: nil)
        return button
    }()
    
    private func buildButton(normalImage: UIImage?, selectedImage: UIImage?, highlightedImage: UIImage? ) -> UIButton {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(normalImage, for: UIControlState.normal)
        button.setImage(selectedImage, for: UIControlState.selected)
        button.setImage(highlightedImage, for: UIControlState.highlighted)
        button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    
    @objc func buttonClicked(_ sender: UIButton?) {
        guard let button = sender else {
            return
        }
        if button == self.leftButton {
            button.isSelected = !button.isSelected
            
        } else if button == self.rightButton {
            
        }
        
    }
    override func viewInit() {
        inputTextView.delegate = self
    }
    
    override func layoutInit() {
        
    }
    
    func keyboardWillShow(note: Notification) {
        
    
        guard let userInfo = note.userInfo else {
            return
        }
        
        guard let keyboardBounds = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }
        
        debugLog(keyboardBounds, duration, curve)
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve.intValue)!)
        
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(note: Notification) {
        guard let userInfo = note.userInfo else {
            return
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve.intValue)!)
        
        UIView.commitAnimations()
    }
    
   
    
}

extension InputBarView: HPGrowingTextViewDelegate {
    
    func growingTextView(_ growingTextView: HPGrowingTextView!, willChangeHeight height: Float) {
        
    }
    
    
}

