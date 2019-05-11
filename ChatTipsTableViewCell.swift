//
//  ChatTipsTableViewCell.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit
import YYText

struct ChatTipsCellLayout {
    static let top: CGFloat = 0.0
    static let bottom: CGFloat = 13.0
    static let left: CGFloat = 21.5
    static let right:  CGFloat = 21.5
    static let interval: CGFloat = 10.0
    static let maxWidth: CGFloat = UIScreen.width - 43
    static let font: UIFont = UIFont.pingFangSCMedium(size: 13)
}

class ChatTipsTableViewCell: JYBasicTableViewCell {
    
    var model: MessageModel?
    
    lazy var tipsLabel: YYLabel = {
        let label = YYLabel()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = ChatTipsCellLayout.font
        label.displaysAsynchronously = true
        label.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        label.layer.cornerRadius = 4.5
        
        return label
    }()
    
    func setLayout() {
        
        guard let data = model else {
            return
        }
        
        guard let layout = model?.layout as? MessageTipsCellLayout else {
            return
        }
        
        tipsLabel.textAlignment = .center
        tipsLabel.text = data.content
//        tipsLabel.textLayout = layout.tipsTextLayout
        tipsLabel.frame = layout.tips
//        tipsLabel.textAlignment = .center
    }
    
    // MARK: override
    override func viewInit() {
//        tipsLabel.textAlignment = .center
        self.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        self.contentView.addSubview(tipsLabel)
    }
    
    override func layoutInit() {
//        tipsLabel.textAlignment = .center
//        tipsLabel.size = CGSize.zero
//        tipsLabel.height = ChatTimeCellLayout.timeHeight
        tipsLabel.centerX = self.centerX
//        tipsLabel.top = ChatTipsCellLayout.top
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
