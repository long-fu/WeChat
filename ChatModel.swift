//
//  ChatModel.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import Foundation
import YYText
import HandyJSON


enum ChatType: Int, HandyJSONEnum {
    /// 群组聊天
    case group
    /// 单人聊天
    case single
}

enum MessageType: Int, HandyJSONEnum{
    /// 文字
    case text
    /// 图像
    case image
    /// 视频 -  暂时不实现
    case video
    /// 声音
    case audio
    /// 位置
    case locate
    /// 提示
    case tips
    /// 时间
    case ctime
}

protocol MessageHeightLayout {
    /// cell 高度
    var height: CGFloat {get set}
}

protocol MessageCellLayout: MessageHeightLayout {
    

    /// 群聊的时候显示 - 来自对方
    var name: CGRect {get set}
    /// 名字布局
    var nameTextLayout: YYTextLayout? {get set}
    // 头像
    var avatar: CGRect {get set}
    // POP框
    var messageBG: CGRect {get set}
    // 消息提示
    var mTips: CGRect {get set}
}

struct MessageTextCellLayout: MessageCellLayout {
    
    var height: CGFloat = 0.0
    
    var name: CGRect = CGRect.zero
    
    var nameTextLayout: YYTextLayout?
    
    var avatar: CGRect = CGRect.zero
    
    var messageBG: CGRect = CGRect.zero
    
    var mTips: CGRect = CGRect.zero
    
    // 消息实际
    var text: CGRect = CGRect.zero
    
    var textLayout: YYTextLayout?
}

struct MessageAudioCellLayout: MessageCellLayout {
    
    var height: CGFloat = 0.0
    
    var name: CGRect = CGRect.zero
    
    var nameTextLayout: YYTextLayout?
    
    var avatar: CGRect = CGRect.zero
    
    var messageBG: CGRect = CGRect.zero
    
    var mTips: CGRect = CGRect.zero
    
    /// 语音图标显示位置
    var audio: CGRect = CGRect.zero
    
    /// 显示消息长度
    var length: CGRect = CGRect.zero
    
    /// 未读提示
    var rTips: CGRect = CGRect.zero
}

struct MessageImageCellLayout: MessageCellLayout {
    var height: CGFloat = 0.0
    
    var name: CGRect = CGRect.zero
    
    var nameTextLayout: YYTextLayout?
    
    var avatar: CGRect = CGRect.zero
    
    var messageBG: CGRect = CGRect.zero
    
    var mTips: CGRect = CGRect.zero
    
    /// 图片显示位置
    var image: CGRect = CGRect.zero
}

struct MessageLocateCellLayout: MessageCellLayout {
    
    var height: CGFloat = 0.0
    
    var name: CGRect = CGRect.zero
    
    var nameTextLayout: YYTextLayout?
    
    var avatar: CGRect = CGRect.zero
    
    var messageBG: CGRect = CGRect.zero
    
    var mTips: CGRect = CGRect.zero
    
    var title: CGRect = CGRect.zero
    
    var titleTextLayout: YYTextLayout?
    
    var details: CGRect = CGRect.zero
    
    var detailsTextLayout: YYTextLayout?
    
    var locateImage: CGRect = CGRect.zero
}


struct MessageTimeCellLayout: MessageHeightLayout {
    var height: CGFloat = 0.0
    var time: CGRect = CGRect.zero
    var timeTextLayout: YYTextLayout?
}

struct MessageTipsCellLayout: MessageHeightLayout {
    var height: CGFloat = 0.0
    var tips: CGRect = CGRect.zero
    var tipsTextLayout: YYTextLayout?
}

class ChatMessageModel: HandyJSON {
    var id: Int?
    var userId: String = ""
    var isRead = false
    var mType: MessageType = .text
    var isss = true
    /// 消息内容 - 更具消息类型 解析出实际的数据类型
    var content: String = ""
    /// 时间
    var time: Date = Date()
    required init() { }
}


class MessageModel: ChatMessageModel {
    
    // 本地id
//    var id: Int?
    
    /// 聊天 泡泡框
    var bgView: UIImage?
    
    /// 用户id
//    var userId: String = ""
    
    /// 头像
    var avatar: URL?
    
    /// 昵称
    var nickname: String?
    
    /// 备注名称
    var notename: String?
    
    /// 消息类容长度 - 语音长度 视频长度
    var duration: Double = 0.0
    
    /// 消息未读 - 这个属性在多媒体的时候用到 声音 视频
//    var isRead = false
    
    /// 消息类型
//    var mType: MessageType = .text
    
    var cType: ChatType = .single
    
    /*
     {
     type: "MessageType"
     data: ""
     }
     */
    
    /// 消息内容 - 更具消息类型 解析出实际的数据类型
//    var content: String = ""
    /// 时间
//    var time: Date = Date()
    
    /// 消息布局
    var layout: MessageHeightLayout?
    
    func save() {
        
        // TODO: 数据保存
        
        // TODO: 提示 时间 可以在这里直接返回 - 其实 图片 - 视频 也可以在这里返回
        
        // MARK: - 时间
        if mType == .ctime {
            
            var tiLayout = MessageTimeCellLayout()
            content = Date().chatFormat(self.time) ?? "时间计算错误"
            let text = content.attributedString(font: ChatTimeCellLayout.font, textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            // 复用
            let width = ChatCellLayout.messageMaxWidth
            let containerSize = CGSize(width: width, height: CGFloat.infinity)
            let container = YYTextContainer(size: containerSize)
            tiLayout.timeTextLayout = YYTextLayout(container: container, text: text)
            
            let ts = tiLayout.timeTextLayout?.textBoundingRect.size ?? CGSize.zero
            
            let size = CGSize(width: ts.height + 2 * ChatTimeCellLayout.interval, height: ts.height)
            let tx: CGFloat = (UIScreen.width - size.width) / 2.0
            
            let origin = CGPoint(x: tx, y: ChatTimeCellLayout.top)
            tiLayout.time = CGRect(origin: origin, size: size)
            tiLayout.height = ChatTimeCellLayout.height
            layout = tiLayout
            return
        } else if mType == .tips {
            
            var tipLayout = MessageTipsCellLayout()
            let text = content.attributedString(font: ChatTipsCellLayout.font, textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            // 复用
            let width = ChatTipsCellLayout.maxWidth
            let containerSize = CGSize(width: width, height: CGFloat.infinity)
            
            let container = YYTextContainer(size: containerSize)
            
            tipLayout.tipsTextLayout = YYTextLayout(container: container, text: text)
            
            
            let ts = tipLayout.tipsTextLayout?.textBoundingRect.size ?? CGSize.zero
            let size = CGSize(width: ts.width + 2 * ChatTipsCellLayout.interval, height: ts.height)
            
            let tx: CGFloat = (UIScreen.width - size.width) / 2.0
            
            
            let origin = CGPoint(x: tx, y: ChatTipsCellLayout.top)
            
            
            tipLayout.tips = CGRect(origin: origin, size: size)
            
            let th: CGFloat = tipLayout.tipsTextLayout?.textBoundingRect.size.height ?? 0.0
            
            tipLayout.height = th + ChatTipsCellLayout.bottom
            
            layout = tipLayout
            return
        }
        
        var tLayout: MessageCellLayout?
        
        if mType == .text {
            tLayout = MessageTextCellLayout()
        } else if mType == .audio {
            tLayout = MessageAudioCellLayout()
        } else if mType == .image {
            tLayout = MessageImageCellLayout()
        } else if mType == .locate {
            tLayout = MessageLocateCellLayout()
        }
        else if mType == .video {
            
        }
        
        
        if userId == gUserPhone {

            bgView = #imageLiteral(resourceName: "chat_right_bg").resizableImage(withCapInsets: UIEdgeInsets.init(top: 27, left: 7, bottom: 6, right: 13), resizingMode: UIImageResizingMode.stretch)

            // 头像在右边
            let ay = UIScreen.width - (ChatCellLayout.avatarLeft + ChatCellLayout.avatarSize.width)

            tLayout?.avatar  = CGRect(origin: CGPoint(x: ay, y: ChatCellLayout.top), size: ChatCellLayout.avatarSize)
            
        } else {
            
            bgView = #imageLiteral(resourceName: "chat_left_bg").resizableImage(withCapInsets: UIEdgeInsets.init(top: 27, left: 11, bottom: 6, right: 7), resizingMode: UIImageResizingMode.stretch)

            tLayout?.avatar = CGRect(origin: CGPoint.init(x: ChatCellLayout.avatarLeft, y: ChatCellLayout.top), size: ChatCellLayout.avatarSize)

            if cType == .group {
                let name = notename ?? nickname ?? "此用户是BS"
                let nameText = name.attributedString(font: ChatCellLayout.nameFont, textColor: #colorLiteral(red: 0.4078431373, green: 0.4078431373, blue: 0.4078431373, alpha: 1))
                let nameWidth = ChatCellLayout.nameMaxWidth

                let containerSize = CGSize(width: nameWidth, height: CGFloat.infinity)
                let container = YYTextContainer(size: containerSize)
                container.maximumNumberOfRows = 1
                
                
                tLayout?.nameTextLayout = YYTextLayout(container: container, text: nameText)

                let nh = tLayout?.nameTextLayout?.textBoundingSize.height ?? 0.0
                tLayout?.name = CGRect(x: ChatCellLayout.nameLeft, y: ChatCellLayout.top, width: nameWidth, height: nh)
            }
        }
        
        // MARK: - 文本消息
        if mType == .text {
            
            guard var txLayout = tLayout as? MessageTextCellLayout else {
                return
            }
            
            if userId == gUserPhone {

                let text = content.attributedString(font: ChatCellLayout.messageFont, textColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1))

                let width = ChatCellLayout.messageMaxWidth

                let containerSize = CGSize(width: width, height: CGFloat.infinity)

                let container = YYTextContainer(size: containerSize)

                txLayout.textLayout = YYTextLayout(container: container, text: text)
                
                // 消息BG pop框
                var messageBgHeight: CGFloat = (txLayout.textLayout?.textBoundingSize.height ?? 0.0) + ChatCellLayout.messageMargins * 2.0

                if messageBgHeight < ChatCellLayout.messageBGDefineHeight {
                    messageBgHeight = ChatCellLayout.messageBGDefineHeight
                }

                txLayout.height = messageBgHeight + ChatCellLayout.bottom

                if messageBgHeight > ChatCellLayout.messageBGDefineHeight {

                    let mbw = (txLayout.textLayout?.textBoundingSize.width ?? 12.0) + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins

                    let mbx = UIScreen.width - (mbw + ChatCellLayout.messageBgLeft)
                    let mby: CGFloat = ChatCellLayout.messageBgTop
                    let mbh = messageBgHeight

                    txLayout.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)

                    txLayout.text = CGRect(x: mbx + ChatCellLayout.messageMargins, y: mby + ChatCellLayout.messageMargins, width: ChatCellLayout.messageMaxWidth, height: (txLayout.textLayout?.textBoundingSize.height)!)
//                    layout = txLayout
                } else {

                    var mbw: CGFloat = 10.0
                    let mw = txLayout.textLayout?.textBoundingSize.width ?? 12.0

                    if mw > 0.0 {
                        mbw = mw + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins
                    }

                    let mbx = UIScreen.width - ChatCellLayout.messageBgLeft - mbw
                    let mby: CGFloat = ChatCellLayout.messageBgTop
                    let mbh = ChatCellLayout.messageBGDefineHeight

                    txLayout.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)
                    txLayout.text = CGRect(x: mbx + ChatCellLayout.messageMargins, y: mby + ChatCellLayout.messageMargins, width: mw, height: (txLayout.textLayout?.textBoundingSize.height ?? 0.0))
                    
//                    layout = txLayout
                }


            }
            // 对方
            else {

                let text = content.attributedString(font: ChatCellLayout.messageFont, textColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1))

                let width = ChatCellLayout.messageMaxWidth

                let containerSize = CGSize(width: width, height: CGFloat.infinity)

                let container = YYTextContainer(size: containerSize)
                // 计算位子消息高度
                txLayout.textLayout = YYTextLayout(container: container, text: text)

                // 消息BG pop框
                var messageBgHeight: CGFloat = (txLayout.textLayout?.textBoundingSize.height ?? 0.0) + ChatCellLayout.messageMargins * 2.0

                if messageBgHeight < ChatCellLayout.messageBGDefineHeight {
                    messageBgHeight = ChatCellLayout.messageBGDefineHeight
                }

                // 单人聊天
                if cType == .single {

                    txLayout.height = messageBgHeight + ChatCellLayout.bottom

                    let mbx = ChatCellLayout.messageBgLeft
                    let mby: CGFloat = ChatCellLayout.messageBgTop
                    let mbh = messageBgHeight
                    let mbw = (txLayout.textLayout?.textBoundingSize.width ?? 12.0) + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins

                    txLayout.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)

                    txLayout.text = CGRect(x: mbx + ChatCellLayout.messageLeft, y: mby + ChatCellLayout.messageMargins, width: (txLayout.textLayout?.textBoundingSize.width ?? 12.0), height: (txLayout.textLayout?.textBoundingSize.height)!)

                }
                // 群组聊天
                else {

                    txLayout.height = ChatCellLayout.nameHeight + messageBgHeight +  ChatCellLayout.bottom

                    let mbx = ChatCellLayout.messageBgLeft
                    let mby: CGFloat = ChatCellLayout.nameHeight
                    let mbh = messageBgHeight
                    let mbw = (txLayout.textLayout?.textBoundingSize.width ?? 12.0) + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins

                    txLayout.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)

                    txLayout.text = CGRect(x: mbx + ChatCellLayout.messageLeft, y: mby + ChatCellLayout.messageMargins, width: (txLayout.textLayout?.textBoundingSize.width ?? 12.0), height: (txLayout.textLayout?.textBoundingSize.height)!)
                }
            }
            self.layout = txLayout
            return
        }// .text
            //MARK: - 语音
        else if mType == .audio {
            guard var aLayout = tLayout as? MessageAudioCellLayout else {
                return
            }
            let aw = AudioCellLayout.defineWidth + CGFloat(duration - 1.0) * AudioCellLayout.incrementWidth
            let ay = ChatCellLayout.top
            let ah = ChatCellLayout.messageBGDefineHeight

            if userId == gUserPhone {
                let ax = UIScreen.width - aw - ChatCellLayout.messageBgLeft
                aLayout.messageBG = CGRect(x: ax, y: ay, width: aw, height: ah)
                aLayout.audio = CGRect(x: ax, y: ay, width: aw, height: ah)
                aLayout.height = ChatCellLayout.messageBGDefineHeight + ChatCellLayout.bottom
            } else {
                let ax = ChatCellLayout.messageBgLeft
                if cType == .single {
                    aLayout.messageBG = CGRect(x: ax, y: ay, width: aw, height: ah)
                    aLayout.audio = CGRect(x: ax, y: ay, width: aw, height: ah)
                    self.layout?.height = ChatCellLayout.messageBGDefineHeight + ChatCellLayout.bottom
                } else {
                    let ay: CGFloat = ChatCellLayout.nameHeight
                    aLayout.audio = CGRect(x: ax, y: ay, width: aw, height: ah)
                    aLayout.messageBG = CGRect(x: ax, y: ay, width: aw, height: ah)
                    aLayout.height = ChatCellLayout.messageBGDefineHeight + ChatCellLayout.nameHeight + ChatCellLayout.bottom
                }
            }
            self.layout = aLayout
            return
        }
            // MARK: - 位置
        else if mType == .locate {

            // 固定

        }
            //MARK: -  图片
        else  if mType == .image {
            // 按比例缩放
            
        }
            // MARK: - 视频
        else if mType == .video {
            
        }
        
    }
    
//    
//    mutating func save() {
//        
//        // 把数据保存到数据库 - 创建
//        
//        // 数据保存
//        if mType == .text {
//            layout = MessageTextCellLayout()
//        }
//        
////        layout = MessageCellLayout()
//        
//        
//        
//        if userId == gUserPhone {
//            
//            bgView = #imageLiteral(resourceName: "chat_right_bg").resizableImage(withCapInsets: UIEdgeInsets.init(top: 27, left: 7, bottom: 6, right: 13), resizingMode: UIImageResizingMode.stretch)
//            
//            // 头像在右边
//            let ay = UIScreen.width - (ChatCellLayout.avatarLeft + ChatCellLayout.avatarSize.width)
//            
////            layout?.avatar = CGRect(origin: CGPoint(x: ay, y: ChatCellLayout.top), size: ChatCellLayout.avatarSize)
//            
//        } else {
//            bgView = #imageLiteral(resourceName: "chat_left_bg").resizableImage(withCapInsets: UIEdgeInsets.init(top: 27, left: 11, bottom: 6, right: 7), resizingMode: UIImageResizingMode.stretch)
//            
////            layout?.avatar = CGRect(origin: CGPoint.init(x: ChatCellLayout.avatarLeft, y: ChatCellLayout.top), size: ChatCellLayout.avatarSize)
//            
//            if cType == .group {
//                let name = notename ?? nickname ?? "此用户是BS"
//                let nameText = name.attributedString(font: ChatCellLayout.nameFont, textColor: #colorLiteral(red: 0.4078431373, green: 0.4078431373, blue: 0.4078431373, alpha: 1))
//                let nameWidth = ChatCellLayout.nameMaxWidth
//                
//                let containerSize = CGSize(width: nameWidth, height: CGFloat.infinity)
//                let container = YYTextContainer(size: containerSize)
//                container.maximumNumberOfRows = 1
//                // 计算位子消息高度
////                self.nameTextLayout = YYTextLayout(container: container, text: nameText)
//                
////                let nh = self.nameTextLayout?.textBoundingSize.height ?? 0.0
////                layout?.name = CGRect(x: ChatCellLayout.nameLeft, y: ChatCellLayout.top, width: nameWidth, height: nh)
//            }
//            
//        }
//        
//        // MARK: - 文本消息
//        if mType == .text {
//            
//            if userId == gUserPhone {
//                
//                let text = content.attributedString(font: ChatCellLayout.messageFont, textColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1))
//                
//                let width = ChatCellLayout.messageMaxWidth
//                
//                let containerSize = CGSize(width: width, height: CGFloat.infinity)
//                
//                let container = YYTextContainer(size: containerSize)
//                
////                self.contentTextLayout = YYTextLayout(container: container, text: text)
//                
//                // 消息BG pop框
////                var messageBgHeight: CGFloat = (self.contentTextLayout?.textBoundingSize.height ?? 0.0) + ChatCellLayout.messageMargins * 2.0
//                
//                if messageBgHeight < ChatCellLayout.messageBGDefineHeight {
//                    messageBgHeight = ChatCellLayout.messageBGDefineHeight
//                }
//                
////                layout?.height = messageBgHeight + ChatCellLayout.bottom
//                
//                if messageBgHeight > ChatCellLayout.messageBGDefineHeight {
//                    
////                    let mbw = (self.contentTextLayout?.textBoundingSize.width ?? 12.0) + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins
////
////                    let mbx = UIScreen.width - (mbw + ChatCellLayout.messageBgLeft)
////                    let mby: CGFloat = ChatCellLayout.messageBgTop
////                    let mbh = messageBgHeight
////
////                    layout?.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)
////
////                    layout?.message = CGRect(x: mbx + ChatCellLayout.messageLeft, y: mby + ChatCellLayout.messageMargins, width: ChatCellLayout.messageMaxWidth, height: (self.contentTextLayout?.textBoundingSize.height)!)
////
//                } else {
//                    
////                    var mbw: CGFloat = 10.0
////                    let mw = contentTextLayout?.textBoundingSize.width ?? 12.0
////
////                    if mw > 0.0 {
////                        mbw = mw + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins
////                    }
////
////                    let mbx = UIScreen.width - ChatCellLayout.messageBgLeft - mbw
////                    let mby: CGFloat = ChatCellLayout.messageBgTop
////                    let mbh = ChatCellLayout.messageBGDefineHeight
////
////                    layout?.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)
////                    layout?.message = CGRect(x: mbx + ChatCellLayout.messageMargins, y: mby + ChatCellLayout.messageMargins, width: mw, height: (self.contentTextLayout?.textBoundingSize.height ?? 0.0))
////                }
////
//                
//            }
//                // 对方
//            else {
//                
//                let text = content.attributedString(font: ChatCellLayout.messageFont, textColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1))
//                
//                let width = ChatCellLayout.messageMaxWidth
//                
//                let containerSize = CGSize(width: width, height: CGFloat.infinity)
//                
//                let container = YYTextContainer(size: containerSize)
//                // 计算位子消息高度
//                self.contentTextLayout = YYTextLayout(container: container, text: text)
//                
//                // 消息BG pop框
//                var messageBgHeight: CGFloat = (self.contentTextLayout?.textBoundingSize.height ?? 0.0) + ChatCellLayout.messageMargins * 2.0
//                
//                if messageBgHeight < ChatCellLayout.messageBGDefineHeight {
//                    messageBgHeight = ChatCellLayout.messageBGDefineHeight
//                }
//                
//                // 单人聊天
//                if cType == .single {
//                    
//                    layout?.height = messageBgHeight + ChatCellLayout.bottom
//                    
//                    let mbx = ChatCellLayout.messageBgLeft
//                    let mby: CGFloat = ChatCellLayout.messageBgTop
//                    let mbh = messageBgHeight
//                    let mbw = (self.contentTextLayout?.textBoundingSize.width ?? 12.0) + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins
//                    
//                    layout?.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)
//                    
//                    layout?.message = CGRect(x: mbx + ChatCellLayout.messageLeft, y: mby + ChatCellLayout.messageMargins, width: (self.contentTextLayout?.textBoundingSize.width ?? 12.0), height: (self.contentTextLayout?.textBoundingSize.height)!)
//                    
//                }
//                // 群组聊天
//                else {
//                    
//                    layout?.height = ChatCellLayout.nameHeight + messageBgHeight +  ChatCellLayout.bottom
//                    
//                    let mbx = ChatCellLayout.messageBgLeft
//                    let mby: CGFloat = ChatCellLayout.nameHeight
//                    let mbh = messageBgHeight
//                    let mbw = (self.contentTextLayout?.textBoundingSize.width ?? 12.0) + ChatCellLayout.messageLeft + ChatCellLayout.messageMargins
//                    
//                    layout?.messageBG = CGRect(x: mbx, y: mby, width: mbw, height: mbh)
//                    
//                    layout?.message = CGRect(x: mbx + ChatCellLayout.messageLeft, y: mby + ChatCellLayout.messageMargins, width: (self.contentTextLayout?.textBoundingSize.width ?? 12.0), height: (self.contentTextLayout?.textBoundingSize.height)!)
//                }
//                
//            }
//        } else if mType == .audio {
//            
//            let aw = AudioCellLayout.defineWidth + CGFloat(duration - 1.0) * AudioCellLayout.incrementWidth
//            let ay = ChatCellLayout.top
//            let ah = ChatCellLayout.messageBGDefineHeight
//            
//            if userId == gUserPhone {
//                let ax = UIScreen.width - aw - ChatCellLayout.messageBgLeft
//                
//                self.layout?.messageBG = CGRect(x: ax, y: ay, width: aw, height: ah)
//                
////                self.layout?.audio = CGRect(x: ax, y: ay, width: aw, height: ah)
//                self.layout?.height = ChatCellLayout.messageBGDefineHeight + ChatCellLayout.bottom
////            } else {
////                let ax = ChatCellLayout.messageBgLeft
////                if cType == .single {
////                    self.layout?.messageBG = CGRect(x: ax, y: ay, width: aw, height: ah)
//////                    self.layout?.audio = CGRect(x: ax, y: ay, width: aw, height: ah)
////                    self.layout?.height = ChatCellLayout.messageBGDefineHeight + ChatCellLayout.bottom
////                } else {
////                    let ay: CGFloat = ChatCellLayout.nameHeight
//////                    self.layout?.audio = CGRect(x: ax, y: ay, width: aw, height: ah)
////                    self.layout?.messageBG = CGRect(x: ax, y: ay, width: aw, height: ah)
////                    self.layout?.height = ChatCellLayout.messageBGDefineHeight + ChatCellLayout.nameHeight + ChatCellLayout.bottom
////                }
////            }
//            
//        } else if mType == .image {
//            
//            // 按比例缩放
//            
//        } else if mType == .locate {
//            
//            // 固定
//            
//        } else if mType == .ctime {
//            
//            // TODO: 这部分需要计算时间
//            content = "09:00"
//            // 服用内用
////            contentTextLayout
//            layout?.height = ChatTimeCellLayout.height
//            
//        } else if mType == .tips {
//            
//            // TODO: 计算内容信息
//            content = "提示: 一个大SB加入房间"
////            contentTextLayout
////            layout?.height = ChatCellLayout.top + ChatTipsCellLayout.bottom
//        }
//        
//
//     
//        
//        
//    }
    
    func setLayout() {
        
    }
    
}



/// 好友数据模型
struct ContactsMessageModel {
    var id: Int
    /// 聊天类型
    var chatType: ChatType = .single
    
    var gender: GenderType = .unknown
    
    /// 聊天位置标示 - 和字表相关联
    var messageName: String
    /// 当前聊天别名
    var name: String
    /// 备注名称
    var notename: String?
    /// 当前头像
    var avatar: URL?
    /// 未读消息 - 和消息界面的未读无关联
    var count: Int = 0
    /// 最后一条消息ID
    var lastMessageId: Int
    /// 最后条消息时间
    var lastTime: Date
}
