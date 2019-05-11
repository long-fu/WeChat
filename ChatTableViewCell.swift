//
//  ChatTableViewCell.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit
import YYText
// 都是相对于左边
struct ChatCellLayout {
    
    static let top: CGFloat = 0.0
    static let bottom: CGFloat = 14.0
    
    static let avatarSize:CGSize = CGSize.init(width: 40, height: 40)
    static let avatarLeft: CGFloat = 10.0
    
    static let messageBGDefineHeight: CGFloat = 40.0
    static let messageBgTop: CGFloat = 0
    static let messageBgLeft: CGFloat = 55.0
    static let messageBgRight: CGFloat = 44.0
    
    // 消息实体部分 - 相对于POP
    static let messageLeft: CGFloat = 15.5 // left部分
    // 和字体的大小相关 进行调整
    static let messageMargins: CGFloat = 7.0
    
    // 消息实际相对于cell contentview
    static let messageLL: CGFloat = 72.0
    static let messageRR: CGFloat = 55.0
    
    // 消息宽度
    static let messageMaxWidth: CGFloat = UIScreen.width - 127
    
    // 群聊
    static let nameLeft: CGFloat = 60.0
    static let nameTop: CGFloat = 0
    static let nameBottom: CGFloat = 4.0
    static let nameMaxWidth: CGFloat = UIScreen.width - 127
    static let nameHeight: CGFloat = 19.0
    
    // 字体
    
    static let nameFont: UIFont = UIFont.pingFangSCMedium(size: 11.5)
    
    static let messageFont: UIFont = UIFont.pingFangSCMedium(size: 15.5)
    
    
    
}

class ChatTableViewCell: JYBasicTableViewCell {
    
    lazy var nameLabel: YYLabel = {
        let label = YYLabel()
        label.font = ChatCellLayout.nameFont
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.4078431373, blue: 0.4078431373, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    lazy var bgView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return imageView
    }()
    
    var model: MessageModel?
    
    func setLayout() {
        
        guard let data = self.model else {
            return
        }

        self.bgView.image = data.bgView
        self.avatarImageView.kf.setImage(with: data.avatar)
        
        nameLabel.frame = CGRect.zero
        nameLabel.isHidden = true
        
        if data.cType == .group && data.userId != gUserPhone {
            nameLabel.isHidden = false
            nameLabel.text = data.notename ?? data.nickname ?? "此用户是BS"
        }
        

        
    }
    
    override func viewInit() {
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(bgView)
        self.contentView.addSubview(avatarImageView)
        
    }
    
    override func layoutInit() {
        
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
