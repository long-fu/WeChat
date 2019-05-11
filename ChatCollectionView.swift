//
//  ChatCollectionView.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/10.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import Foundation
import YYText

struct ChatCollectionLayout {
    static let buttonTop: CGFloat = 20.5
    static let horizontalInterval: CGFloat = 16.0
    //UIScreen.width - 5 * 16.0 / 5
    static let width = (UIScreen.width - 90.0) / 4
    static let button: CGSize = CGSize(width: width, height: width)
    static let labelTop: CGFloat = 12.5
    static let label: CGSize = CGSize(width: width, height: 16)
    static let font: UIFont = UIFont.pingFangSCMedium(size: 12)
    static let cornerRadius: CGFloat = 10.0
}

class ChatCollectionView: JYBasicView {
    
    lazy var button: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.imageEdgeInsets = UIEdgeInsets(top: 18.5, left: 14.5, bottom: 18.5, right: 14.5)
        button.size = ChatCollectionLayout.button
        button.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9882352941, alpha: 1)
        button.layer.cornerRadius = ChatCollectionLayout.cornerRadius
        button.layer.borderColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8470588235, alpha: 1)
        button.layer.borderWidth = 1.0
        return button
    }()
    
    lazy var titleLabel: YYLabel = {
        let label = YYLabel()
        label.size = ChatCollectionLayout.label
        label.font = ChatCollectionLayout.font
        label.textColor = #colorLiteral(red: 0.4901960784, green: 0.4901960784, blue: 0.4901960784, alpha: 1)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        return label
    }()
    
    override func viewInit() {
        super.viewInit()
        self.addSubview(button)
        self.addSubview(titleLabel)
    }
    
    override func layoutInit() {
        super.layoutInit()
        
        button.left = 0
        button.top = 0
        titleLabel.left = 0
        titleLabel.top = button.bottom + ChatCollectionLayout.labelTop
        
    }
}
