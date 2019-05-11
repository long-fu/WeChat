//
//  ChatTimeTableViewCell.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//


import UIKit
import YYText

struct ChatTimeCellLayout {
    static let top: CGFloat = 11.0
    static let timeHeight: CGFloat = 20.0
    static let bottom: CGFloat = 14.0
    static let height: CGFloat = 45.0
    static let interval: CGFloat = 10.0
    static let font: UIFont = UIFont.pingFangSCMedium(size: 11.5)
}

class ChatTimeTableViewCell: JYBasicTableViewCell {
    
    var model: MessageModel?
    
    lazy var timeLabel: YYLabel = {
        let label = YYLabel()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = ChatTimeCellLayout.font
        label.displaysAsynchronously = true
        label.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1)
        label.layer.cornerRadius = 4.5
        return label
    }()
    
    func setLayout() {
       
        guard let data = model else {
            return
        }
        
        guard let layout = model?.layout as? MessageTimeCellLayout else {
            return
        }
        
        timeLabel.textAlignment = .center
        timeLabel.text = data.content
//        timeLabel.textLayout = layout.timeTextLayout
        timeLabel.frame = layout.time
        
    }
    
    
    // MARK: - override
    override func viewInit() {
        self.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        self.contentView.addSubview(timeLabel)
    }
    
    override func layoutInit() {
//        timeLabel.size = CGSize.zero
        timeLabel.height = ChatTimeCellLayout.timeHeight
        timeLabel.centerX = self.centerX
//        timeLabel.top = ChatTimeCellLayout.top
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
