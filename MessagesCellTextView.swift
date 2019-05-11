//
//  MessagesCellTextView.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/8.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit
import YYText
class MessagesCellTextView: YYTextView {
    
//    override var selectedRange: NSRange {
//        set {
//            super.selectedRange = NSMakeRange(NSNotFound, 0)
//        }
//        get {
//            return NSMakeRange(NSNotFound, NSNotFound);
//        }
//    }
    
    /* 选中文字后是否能够呼出菜单 */
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    private final func commonInit() {
        self.isEditable = false
        self.isSelectable = true
        self.isUserInteractionEnabled = true
        self.isEditable = false
        self.dataDetectorTypes = .all
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        self.contentInset = UIEdgeInsets.zero
        self.contentOffset = CGPoint.zero
        self.textContainerInset = UIEdgeInsets.zero
        self.backgroundColor = UIColor.clear

    }
    
    
    /* 选中文字后的菜单响应的选项 */
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            
        } else if action == #selector(selectAll(_:)) {
            
        } else if action == #selector(select(_:)) {
            
        }
        return true
    }
    
    // 自定义
    func setupMenuItem() {

//        let s = UIMenuItem(title: "选择文字", action: <#T##Selector#>)
//        UIMenuController.shared.menuItems
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        commonInit()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}
