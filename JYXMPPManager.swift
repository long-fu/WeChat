//
//  JYXMPPManager.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/26.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import Foundation
import XMPPFrameworkSwift

final class JYIMManager {
    
    enum SubjectType: String {
        case Res
    }
    
    let server = ""
    let hostName = "54.222.203.152"
    let hostPort: UInt16 = 5223
    let domain = "family"
    let resource = "iOS"
    let timeout: Double = 600
    
    static let shared = JYIMManager()
    
    private let stream: XMPPStream
    
    private var jid: XMPPJID?
    
    private var password: String?
    
    private var user: String?
    
    private let queue: DispatchQueue
    
    private var isRegister = false
    
    init() {
        stream = XMPPStream.init()
        
        stream.hostPort = hostPort
        stream.hostName = hostName
        
        queue = DispatchQueue(label: DispatchQueue.Name.IM, qos: DispatchQoS.userInitiated, attributes: DispatchQueue.Attributes.concurrent)
        
        stream.addDelegate(self, delegateQueue: queue)
    }
    
    func conntect(user: String) -> Bool {
        
        jid = XMPPJID.init(user: user, domain: domain, resource: resource)
        
        stream.myJID = jid
        
        do {
            try stream.connect(withTimeout: timeout)
        } catch let error {
            debugLog("IM链接错误", error.localizedDescription)
            return false
        }
        
        return true
    }
    
    func disConnnect() {
        if stream.isConnected {
            sendOffline()
            stream.disconnect()
        }
    }
    
    func login(user: String, password: String) -> Bool {
        
        self.user = user
        self.password = password
        isRegister = false
        if stream.isAuthenticating {
            return true
        }
        
        if stream.isConnected && !stream.isAuthenticated {
            do {
               try stream.authenticate(withPassword: password)
            } catch let error {
                debugLog("登陆错误", error.localizedDescription)
                return false
            }
        } else {
            _ = conntect(user: user)
        }
        return true
    }
    
    func register(user: String, password: String) -> Bool {
        self.user = user
        self.password = password
        
        isRegister = true
        
        if stream.isConnecting {
            return false
        }
        
        if stream.isConnected {
            do {
                try stream.register(withPassword: password)
            } catch let error {
                debugLog("注册错误",error.localizedDescription)
                return false
            }
            
        } else {
            _ = conntect(user: user)
        }
        
        return true
    }
    
    func sendOnline() {
        let p = XMPPPresence()
        stream.send(p)
    }
    
    func sendOffline() {
        let p = XMPPPresence(type: "unavailabe")
        stream.send(p)
    }
    
    
    func send(to: String, data: String , id: String, subject: String) {

        // 进行消息超时判断? 超时队列 一秒钟调用一次
        guard stream.isAuthenticated else {
            // 没有进行登陆
            return
        }
        
        let tojid = XMPPJID.init(user: to, domain: domain, resource: resource)
        let message = DDXMLElement(name: "message")
        message.addAttribute(withName: "from", stringValue: jid?.full ?? "")
        message.addAttribute(withName: "to", stringValue: tojid?.full ?? "")
        message.addAttribute(withName: "type", stringValue: "normal")
        message.addAttribute(withName: "id", stringValue: "id")
        
        let sub = DDXMLElement(name: "subject")
        sub.stringValue = subject
        message.addChild(sub)
        
        let body = DDXMLElement(name: "body")
        body.stringValue = Codec.encode(data: data) ?? ""
        message.addChild(body)
        
        stream.send(message)
    }
    
    func receiveMessage(_ data: String) {
        
        do {
            
            let message = try DDXMLElement.init(xmlString: data)
            
            // 全部返回服务器错误
            guard let id = message.attribute(forName: "id")?.stringValue  else {
                debugLog("消息ID错误")
                return
            }
            
            guard let subject = message.forName("subject")?.stringValue else {
                debugLog("消息subject错误")
                return
            }
            
            guard let body = message.forName("body")?.stringValue else {
                debugLog("消息body错误")
                return
            }
            
            guard let fromString = message.attribute(forName: "from")?.stringValue, let fromJID = XMPPJID(string: fromString), let from = fromJID.user else {
                debugLog("消息JID错误")
                return
            }
            
            let jsonMsg = Codec.decode(data: body) ?? "数据错误"
            
            // 解析出实际数据
            
            // 进行存储数据裤
            
            // 通知界面刷新
            
        } catch let error {
            debugLog("服务器消息错误",error.localizedDescription)
        }
        
    }

    
    /// 创建群组
    ///
    /// - Parameters:
    ///   - name: 群名称
    ///   - friendsId: 群成员
    ///   - id: 操作id
    func createGroup(name: String, friendsId:[String], id: String) {
        
        let ul = friendsId.map { (item) -> Dictionary<String,Any> in
            return ["u_id":item, "type":0]
        }
        
        let dic = ["act": 1,
                   "alias":name,
                   "grp_id":"xxxx",
                   "master":gUserPhone,
                   "u_list":ul
            ] as [String : Any]
        
        guard let data: String = JYJSON.init(dic).toJSON() else {
            return
        }
        
        send(to: server, data: data, id: id, subject: "grp_client_create_del")
        
    }
    
    
    /// 解散群组
    ///
    /// - Parameters:
    ///   - groupId: 群组id
    ///   - id: 消息id
    func dissolvegroup(groupId: String, id: String) {
//        let dic = ["act":2, "grp_id":groupId,"u_list":[],"master": gUserPhone] as [String : Any]
//        guard let data: String = JYJSON.init(dic).toJSON() else {
//            return
//        }
        let body = """
        {"act":2,"grp_id":"\(groupId)","u_list":[],"master":"\(gUserPhone)","alias"="xxx"}
"""

        
        send(to: server, data: body, id: id, subject: "grp_client_create_del")
        
    }
    
    /// 添加群成员
    ///
    /// - Parameters:
    ///   - groupId: 群组ID
    ///   - friendId: 好友ID
    ///   - id: 消息id
    func inviteFriends(groupId: String, friendId: String, id: String) {
        
        let body = """
        {"act":1,"grp_id":"\(groupId)","u_id": "\(friendId)","master":"\(gUserPhone)"}
"""
        send(to: server, data: body, id: id, subject: "grp_client_kick")
        
    }
    
    
    /// 移除群成员
    ///
    /// - Parameters:
    ///   - groupId: 群组ID
    ///   - friendId: 好友ID
    ///   - id: 消息id
    func kickOutFriend(groupId: String, friendId: String, id: String) {
        let body = """
        {"act":2,"grp_id":"\(groupId)","u_id": "\(friendId)","master":"\(gUserPhone)"}
        """
        send(to: server, data: body, id: id, subject: "grp_client_kick")
    }
    
    enum GRType: Int {
        case join = 1
        case leave = 2
    }
    
    /// 群组出席
    func groupPresence(act: GRType, groupId: String,id: String ) {
        let body = """
        {"act":\(act.rawValue),"grp_id":"\(groupId)","u_id": "\(gUserPhone)"}
        """
        send(to: server, data: body, id: id, subject: "grp_client_kick")
    }
    
    
    enum ChatType: Int {
        case group = 1
        case sig = 2
    }
    
    enum MessageType: Int {
        case text = 1
        case image = 2
        case audio = 3
        case other = 4
    }
    
    /// 发送消息
    func sendMessage( cType: ChatType,mType: MessageType, mid: String, uid: String, data: String) {
        var msg = ""
        switch mType {
        case .audio:
            let url = URL(fileURLWithPath: data)
            let data = FFManager().read(at: url)
            if let bs = data?.base64EncodedString() {
                msg = bs
            }
            break
        case .image:
            let semaphore = DispatchSemaphore(value: 0)
            let url = URL(fileURLWithPath: data)
            UploadResourcesManager.shared.uploadVideo(url: url) { (resoure) in
                semaphore.signal()
                guard let bs = resoure?.resource.url?.absoluteString else{
                    return
                }
                msg = bs
            }
            semaphore.wait()
            break
        case .text:
            if let bs = data.base64Encode {
                msg = bs
            }
            break
        default:
            return
        }
        let body = """
        {"act":\(cType.rawValue),"from": "\(gUserPhone)","type":\(mType.rawValue),"grp_id":"\(uid)","u_id":"\(uid)","msg":"\(msg)"}
        """
        send(to: uid, data: body, id: mid, subject: "grp_client_msg")
        
    }
    
    
    func sendMessgae(uid: String, id: String, data: Data) {
        
    }
    
    
    
}

// MARK: XMPPStreamDelegate
extension JYIMManager: XMPPStreamDelegate {
    
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream) {
        // MARK: - 链接超时
    }
    
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        // MARK: - 链接服务器成功 后 进行 密码验证 或者是注册

        guard let user = self.user, let password = self.password else {
            return
        }
        
        if self.isRegister {
            register(user: user, password: password)
        }
        else {
            login(user: user, password: password)
        }
        
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        // MARK: - 登陆失败
        debugLog(error.description)
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        //MARK: -  表示当前账号登陆成功 发送出席消息
        debugLog("登陆成功")
        sendOnline()
    }
    
    func xmppStream(_ sender: XMPPStream, didNotRegister error: DDXMLElement) {
        // MARK: - 注册失败
        isRegister = true
    }
    
    func xmppStreamDidRegister(_ sender: XMPPStream) {
        // MARK: - 注册成功
        guard let user = self.user, let password = self.password else {
            return
        }
        isRegister = false
        login(user: user, password: password)
    }
    
    func xmppStream(_ sender: XMPPStream, didFailToSend message: XMPPMessage, error: Error) {
        debugLog("发送消息错误 失败 ",error.localizedDescription)
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        debugLog("接收message ", message.xmlString)
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        debugLog("接收presence ", presence.xmlString)
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        debugLog("接收iq ", iq.xmlString)
        return true
    }
}

