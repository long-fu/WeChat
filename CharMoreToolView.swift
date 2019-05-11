//
//  CharMoreToolView.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/10.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import Foundation

class CharMoreToolView: JYBasicView {
    
    // 相册
    lazy var photoCl: ChatCollectionView = {
        let view = buildMoreButton(image: #imageLiteral(resourceName: "chat_photo"), title: "照片")
        return view
    }()
    
    // 相机
    lazy var cameraCl: ChatCollectionView = {
        let view = buildMoreButton(image: #imageLiteral(resourceName: "chat_camera"), title: "拍摄")
        return view
    }()
    
    private func buildMoreButton(image: UIImage?, title: String?) -> ChatCollectionView {
        let view = ChatCollectionView()
        view.button.setImage(image, for: UIControlState.normal)
        view.button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        view.titleLabel.text = title
        let vw = ChatCollectionLayout.width
        let vh = ChatCollectionLayout.width + ChatCollectionLayout.labelTop + ChatCollectionLayout.label.height
        view.size = CGSize(width: vw, height: vh)
        return view
    }
    
    @objc private func buttonClicked(_ sender: UIButton?) {
        guard sender != nil else {
            return
        }
        
    }
    
    override func viewInit() {
        super.viewInit()
        self.addSubview(photoCl)
        self.addSubview(cameraCl)
    }
    
    override func layoutInit() {
        super.layoutInit()
        photoCl.top = ChatCollectionLayout.buttonTop
        photoCl.left = ChatCollectionLayout.horizontalInterval
        
        cameraCl.top = ChatCollectionLayout.buttonTop
        cameraCl.left = photoCl.right + ChatCollectionLayout.horizontalInterval
    }
    
}


