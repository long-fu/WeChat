//
//  ChatAudioTableViewCell.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit

struct AudioCellLayout {
    static let defineWidth: CGFloat = 69.0
    static let incrementWidth: CGFloat = 4.0
    static let videoLeft: CGFloat = 15.0
    static let videoImageSize:CGSize = CGSize(width: 12.0, height: 17.0)
}

class ChatAudioTableViewCell: ChatTableViewCell {
    
    lazy var audioImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: override
    override func setLayout() {
        
        super.setLayout()
        
        guard let data = model else {
            return
        }
        
        guard let layout = data.layout as?  MessageAudioCellLayout else {
            return
        }
        
//        audioImage.frame = (data.layout?.audio)!
        
        audioImage.centerY = self.centerY
        avatarImageView.frame = layout.avatar
        bgView.frame = layout.messageBG
    }
    
    override func viewInit() {
        super.viewInit()
        self.bgView.addSubview(audioImage)
    }
    
    override func layoutInit() {
        super.layoutInit()
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
