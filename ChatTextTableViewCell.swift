//
//  ChatTextTableViewCell.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit
import YYText

struct ChatTextCellLayout {
    
}

class ChatTextTableViewCell: ChatTableViewCell {
    
    lazy var textView: MessagesCellTextView = {
        let view = MessagesCellTextView()
        view.font = ChatCellLayout.messageFont
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    lazy var contentLabel: YYLabel = {
        let label = YYLabel()
        label.font = ChatCellLayout.messageFont
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    // MARK: override
    override func setLayout() {
        super.setLayout()
        
        guard let data = self.model else {
            return
        }
        
        textView.text = data.content
        
        guard let layout = model?.layout as? MessageTextCellLayout else {
            return
        }
        
        if data.cType == .group && data.userId != gUserPhone {
            
//            nameLabel.isHidden = false
//            nameLabel.text = data.notename ?? data.nickname ?? "此用户是BS"

            nameLabel.frame = layout.name
            nameLabel.textLayout = layout.nameTextLayout
        }
        
        textView.frame = layout.text
        
        avatarImageView.frame = layout.avatar
        bgView.frame = layout.messageBG
    }
    
    override func viewInit() {
        super.viewInit()
        self.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        self.contentView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        self.contentView.addSubview(textView)
        
        //  TODO: 双击点击预览
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(displayTextContent(tap:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        textView.addGestureRecognizer(doubleTapGesture)
        
    }
    
    @objc private final func displayTextContent(tap: UITapGestureRecognizer) {
        debugLog("双击内容")
        // TODO: 进行展示
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
