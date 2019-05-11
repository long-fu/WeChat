//
//  ChatVoiceAnimation.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/12.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import Foundation

struct ChatVoiceAnimationViewLayout {
    
    static let titleFont: UIFont = UIFont.pingFangSCMedium(size: 13)
    static let titleLabelSize = CGSize(width: 135, height: 25)
    static let titleLabeBottom: CGFloat = 7.0

    
    static let voiceHeight: CGFloat = 3.0
    static let voiceValueLeft: CGFloat = 9.0
    static let voiceInterval: CGFloat = 3.5
    static let voiceDefaultWidth: CGFloat = 10.0
    static let voiceIncrement: CGFloat = 1.0
    
    static let voiceSize: CGSize = CGSize(width: 38.5, height: 64.5)
    static let voiceTop: CGFloat = 32.0
    static let voiceLeft: CGFloat = 41.0
}

class ChatVoiceAnimationView: UIView {
    private lazy var rootWindow: UIWindow? = {
        return UIApplication.shared.keyWindow
    }()
    
    private lazy var blackOverlay: UIControl = {
        
        let overlay = UIControl()
        overlay.backgroundColor = UIColor.clear
        return UIControl()
    }()
    
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "chat_misc")
        return imageView
    }()
    
    private lazy var cancelImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var amUIimageViews: [UIImageView] = {
        var imageViews = [UIImageView]()
        for i in 0...9 {
            let iv = UIImageView()
            let index: CGFloat = CGFloat(i)
            let sw = (index * ChatVoiceAnimationViewLayout.voiceIncrement) + ChatVoiceAnimationViewLayout.voiceDefaultWidth
            let sh = ChatVoiceAnimationViewLayout.voiceHeight
            iv.size = CGSize(width: sw, height: sh)
            iv.tag = i
            iv.image = voiceImage
            imageViews.append(iv)
        }
        return imageViews
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = ChatVoiceAnimationViewLayout.titleFont
        label.size = ChatVoiceAnimationViewLayout.titleLabelSize
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.layer.cornerRadius = 3.0
        label.clipsToBounds = true
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    private lazy var voiceImage: UIImage = {
        let image = #imageLiteral(resourceName: "chat_voice_value").resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 5), resizingMode: UIImageResizingMode.stretch)
        return image
    }()
    
    private var containerView: UIView!
    
    override init(frame: CGRect) {
        let ts = CGSize(width: 150, height: 150)
        var tf = frame
        tf.size = ts
        super.init(frame: tf)
        self.size = ts
        backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.673052226)
        
        self.addSubview(titleImageView)
        self.addSubview(titleLabel)

        titleImageView.size = ChatVoiceAnimationViewLayout.voiceSize
        titleImageView.left = ChatVoiceAnimationViewLayout.voiceLeft
        titleImageView.top = ChatVoiceAnimationViewLayout.voiceTop
        
        
        
        
        for (i, item) in self.amUIimageViews.enumerated() {
            self.addSubview(item)
            let h = ChatVoiceAnimationViewLayout.voiceHeight
            let w = ChatVoiceAnimationViewLayout.voiceDefaultWidth + CGFloat(i) * ChatVoiceAnimationViewLayout.voiceIncrement
            item.size = CGSize(width: w, height: h)
            
            item.left = titleImageView.right + ChatVoiceAnimationViewLayout.voiceValueLeft
            item.bottom = titleImageView.bottom - CGFloat(i) * (ChatVoiceAnimationViewLayout.voiceHeight + ChatVoiceAnimationViewLayout.voiceInterval)
            item.isHidden = true
        }
        
        
        self.titleLabel.size = ChatVoiceAnimationViewLayout.titleLabelSize
        self.titleLabel.bottom = self.bottom - ChatVoiceAnimationViewLayout.titleLabeBottom
        self.titleLabel.centerX = self.centerY
    }
    
    func creat() {
        
        guard let rootWindow = self.rootWindow else {
            return
        }
        
        rootWindow.addSubview(self.blackOverlay)
        self.blackOverlay.frame = UIScreen.main.bounds
        containerView = rootWindow
        self.containerView.addSubview(self)
        
        
    }
    
    func dismiss() {
//        debugLog(#function)
        showSend()
        self.removeFromSuperview()
        self.blackOverlay.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func showVocie(value: Int) {
        
        for item in self.amUIimageViews {
            item.isHidden = true
        }
        
        let index = (value - 1) > self.amUIimageViews.count ? self.amUIimageViews.count : value
        
        for i in 0 ..< (index) {
            let item = self.amUIimageViews[i]
            item.isHidden = false
        }
    }
    
    func show(peakPower: Double ) {
        if !isShowCancel {
            let value = lround(peakPower * 10.0)
            showVocie(value: value)
            titleImageView.isHidden = false
            titleLabel.backgroundColor = UIColor.clear
            titleLabel.text = "手指上滑，取消发送"
        }
    }
    
    private var isShowCancel = false
    
    func showCancel() {
        isShowCancel = true
        titleLabel.backgroundColor = #colorLiteral(red: 0.5647058824, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        titleImageView.isHidden = true
        titleLabel.text = "松开手指，取消发送"
        for item in amUIimageViews {
            item.isHidden = true
        }
        
    }
    
    func showSend() {
        isShowCancel = false
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = "手指上滑，取消发送"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        debugLog(#function)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugLog(#function)
    }
    
    
}
