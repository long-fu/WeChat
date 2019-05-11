//
//  ChatViewController.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/3/29.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit
import JYAMR

/// 聊天界面
class ChatViewController: BasicTableViewController {
    
    var dataSource: [MessageModel] = []
    
    private let textReuseIdentifier = "textReuseIdentifier"
    
    private let timeTipsReuseIdentifier = "timeTipsReuseIdentifier"
    
    private let tipsReuseIdentifier = "tipsReuseIdentifier"
    
    private let audioReuseIdentifier = "audioReuseIdentifier"
    
    private let videoReuseIdentifier = "videoReuseIdentifier"
    
    private let imageReuseIdentifier = "imageReuseIdentifier"
    
    private let locateReuseIdentifier = "locateReuseIdentifier"
    
    // MARK: 键盘管理
    
    private lazy var leftButton: UIButton = { [unowned self] in
        let button = buildButton(normalImage: #imageLiteral(resourceName: "chat_voice"), selectedImage: #imageLiteral(resourceName: "chat_kb"), highlightedImage: nil)
        return button
    }()
    
    
    private lazy var rightButton: UIButton = { [unowned self] in
        let button = buildButton(normalImage: #imageLiteral(resourceName: "chat_more"), selectedImage: #imageLiteral(resourceName: "chat_more"), highlightedImage: nil)
        return button
    }()
    
    private lazy var recordAudio: JYAMRRecordAudio = {
        let r = JYAMRRecordAudio()
        return r
    }()
    
    private lazy var playAudio: JYAMRPlayAudio = {
        let p = JYAMRPlayAudio()
        return p
    }()
    
    private lazy var recordVoiceButton: UIButton = { [unowned self] in
        let button = UIButton(type: UIButtonType.custom)
        // 只进行设置初始 状态值
        button.setTitle("按住 说话", for: UIControlState.normal)
        button.setTitleColor(#colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.2980392157, alpha: 1), for: UIControlState.normal)
        button.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        button.layer.cornerRadius = InputBarLayout.inputCornerRadius
        button.layer.borderWidth = 1.0
        button.layer.borderColor = #colorLiteral(red: 0.7215686275, green: 0.7294117647, blue: 0.7490196078, alpha: 1)
        return button
    }()
    
    private lazy var moreToolView: CharMoreToolView = {
        let view = CharMoreToolView()
        view.size = (UserDefaults.keyboardBounds?.size)!
        view.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return view
    }()
    
    private lazy var recordVoiceAnimationView: ChatVoiceAnimationView = {
        let view = ChatVoiceAnimationView()
        view.size = CGSize(width: 150, height: 150)
        view.center = self.view.center
        view.layer.cornerRadius = 7.0
        return view
    }()
    
    
    private func buildButton(normalImage: UIImage?, selectedImage: UIImage?, highlightedImage: UIImage?, title: String? = nil) -> UIButton {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(normalImage, for: UIControlState.normal)
        button.setImage(selectedImage, for: UIControlState.selected)
        button.setImage(highlightedImage, for: UIControlState.highlighted)
        
        button.setTitle(title, for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        return button
    }
    
    override func buttonClicked(_ sender: UIButton?) {
        
        guard let button = sender else {
            return
        }
        
        if button == self.leftButton {
            leftButtonClicked(button)
        } else if button == self.rightButton {
            // TODO: 显示more菜单
            rightButtonClicked(button)
        }
    }
    
    lazy var inputTextView: HPGrowingTextView  = {
        
        let textView = HPGrowingTextView()
        textView.isScrollable = false;
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 6;
        // you can also set the maximum height in points with maxHeight
        textView.maxHeight = 200;
        textView.returnKeyType = .send;
        textView.font = UIFont.pingFangSCMedium(size: 15.0)
        
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
        textView.layer.cornerRadius = InputBarLayout.inputCornerRadius
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        return textView
    }()
    
    
    private lazy var inputToolView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9568627451, alpha: 1)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        return view
    }()
    
    
    private var inputText: String?
    private var isShowKeyboard = false
    
    
    private var showKeyboardinputToolViewFrame: CGRect = CGRect.zero
    
    private var hiddenKeyboardinputToolViewFrame: CGRect = CGRect.zero
    
    /// 这是显示录音button的时候的
    private var showRecordVoiceToolViewFrame: CGRect = CGRect.zero
    
    private func buildInputView() {
        
        self.inputToolView.addSubview(leftButton)
        
        self.inputToolView.addSubview(inputTextView)
        
        self.inputToolView.addSubview(rightButton)
        
        self.inputToolView.addSubview(recordVoiceButton)
        
        self.view.addSubview(inputToolView)
        self.view.addSubview(moreToolView)
        
        inputToolView.size = CGSize(width: UIScreen.width, height: InputBarLayout.height)
        inputToolView.bottom = self.view.bottom
        inputToolView.left = self.view.left
        
        leftButton.size = InputBarLayout.button
        rightButton.size = InputBarLayout.button
        
        rightButton.right = inputToolView.right - InputBarLayout.interval
        leftButton.left = InputBarLayout.interval
        
        let inw = inputToolView.width - ( 2 * InputBarLayout.button.width + 4 * InputBarLayout.interval)
        let inh = InputBarLayout.inputHeight
        inputTextView.size = CGSize(width: inw, height: inh)
        inputTextView.left = leftButton.right + InputBarLayout.interval
        
        
        leftButton.centerY = (inputToolView.height / 2.0)
        rightButton.centerY = (inputToolView.height / 2.0)
        inputTextView.centerY = (inputToolView.height / 2.0)
        
        leftButton.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        
        rightButton.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        
        inputTextView.autoresizingMask = [.flexibleWidth]
        
        inputToolView.autoresizingMask = [.flexibleWidth,.flexibleTopMargin]
        
        recordVoiceButton.frame = inputTextView.frame
        
        hiddenKeyboardinputToolViewFrame = inputToolView.frame
        
        showRecordVoiceToolViewFrame = inputToolView.frame
        
        moreToolView.top = self.view.bottom
        moreToolView.left = self.view.left
        
        recordVoiceButton.isHidden = true
        moreToolView.isHidden = true
    }
    
    
    private var isShowMoreToolView = false
    
    private func rightButtonClicked(_ sender: UIButton) {
        
        // 这里是键盘的切换
        guard let keyboardBounds = UserDefaults.keyboardBounds else {
            return
        }
        if isShowMoreToolView {
            // 显示自带键盘
            self.inputTextView.becomeFirstResponder()
            self.moreToolView.isHidden = true
        } else {
            // 隐藏自带键盘 - 显示more - 文字输入框 需要显示之前的
            self.inputTextView.resignFirstResponder()
            
            self.moreToolView.isHidden = false
            self.recordVoiceButton.isHidden = true
            self.inputTextView.isHidden = false
            self.inputTextView.text = inputText
            
            let kbBounds = self.view.convert(keyboardBounds, to: nil)
            
            var containerFrame = inputToolView.frame
            containerFrame.origin.y = self.view.bounds.size.height - (kbBounds.size.height + containerFrame.size.height);
            
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: 7)!)
            
//            inputToolView.frame = containerFrame
            moreToolView.left = kbBounds.origin.x
            moreToolView.top = kbBounds.origin.y
            
            if showKeyboardinputToolViewFrame.size == CGSize.zero {
                inputToolView.frame = containerFrame
            } else {
                inputToolView.frame = showKeyboardinputToolViewFrame
            }
            inputToolView.bottom = moreToolView.top
            UIView.commitAnimations()
            
        }
        
        isShowMoreToolView = !isShowMoreToolView
        
    }
    
    private func hideMoreToolView() {
        
        self.inputTextView.resignFirstResponder()
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.init(rawValue: 7), animations: {
            self.moreToolView.top = self.view.bottom
        }) { (_) in
            self.moreToolView.isHidden = true
            self.isShowMoreToolView = false
        }
    }
    
    private func leftButtonClicked(_ sender: UIButton) {
//        debugLog(sender.isSelected)
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if !isShowKeyboard {
                // 进行录音button 显示
                inputTextView.isHidden = true
                recordVoiceButton.isHidden = false
                if isShowMoreToolView {
                    
                    hideMoreToolView()
                }
                
                inputToolView.frame = hiddenKeyboardinputToolViewFrame
                
            } else {
                // 收起键盘 - 显示录音按钮
                self.inputTextView.resignFirstResponder()
            }
        } else {
            // 显示出入框 - 弹出键盘
            self.inputTextView.becomeFirstResponder()
        }
    }
    
    // 键盘显示
    @objc func keyboardWillShow(note: Notification) {
        debugLog(#function)
        guard let userInfo = note.userInfo else {
            return
        }
        
        guard let keyboardBounds = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }
        moreToolView.isHidden = true
        inputTextView.isHidden = false
        recordVoiceButton.isHidden = true
        // 历史记录
        inputTextView.text = inputText
        
        let kbBounds = self.view.convert(keyboardBounds, to: nil)
        
        var containerFrame = inputToolView.frame
        
        containerFrame.origin.y = self.view.bounds.size.height - (kbBounds.size.height + containerFrame.size.height);
        
        debugLog(keyboardBounds, duration, curve)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve.intValue)!)
        
        if !isShowKeyboard {
            // 显示记录值
            if showKeyboardinputToolViewFrame.size == CGSize.zero {
                inputToolView.frame = containerFrame
            } else {
                inputToolView.frame = showKeyboardinputToolViewFrame
            }
        } else {
            // 直接加载
            inputToolView.frame = containerFrame
        }
    
        isShowKeyboard = true
        UIView.commitAnimations()
    }
    
    // 隐藏键盘
    @objc func keyboardWillHide(note: Notification) {
        debugLog(#function)
        
        guard let userInfo = note.userInfo else {
            return
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        guard let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }
        
        var containerFrame = inputToolView.frame;
        
        inputText = inputTextView.text
        
        // 保存显示键盘的的文字输入框
        showKeyboardinputToolViewFrame = containerFrame;
//        debugLog(leftButton.isSelected)
        if leftButton.isSelected {
            // 需要显示 语音 输入
            self.inputTextView.isHidden = true
            self.recordVoiceButton.isHidden = false
        }
        
        containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
        
        UIView.beginAnimations(nil, context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve.intValue)!)
        
//        debugLog(leftButton.isSelected)
        if leftButton.isSelected {
            // 显示录音button
            inputToolView.frame = showRecordVoiceToolViewFrame
        } else {
            // 还是显示文本
            inputToolView.frame = containerFrame;
        }
        
        isShowKeyboard = false
        UIView.commitAnimations()
    }
    
    
    
    // MARK: NotificationCenter
    private final func addObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationData), name: NSNotification.Name.Task.NewMessage, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private final func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private final func notificationData(notification: Notification) {
        if let data = notification.object {
            // 获取到通知到的数据
        }
    }
    
    // MARK: 重载
    override func viewInit() {
        super.viewInit()
        self.tableView?.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        tableView?.tableFooterView = view
        
        buildInputView()
    }
    
    override func layoutInit() {
        super.layoutInit()
        self.tableView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    override func commonInit() {
        super.commonInit()
        self.tableView?.register(ChatTextTableViewCell.self, forCellReuseIdentifier: self.textReuseIdentifier)
        self.tableView?.register(ChatTimeTableViewCell.self, forCellReuseIdentifier: self.timeTipsReuseIdentifier)
        self.tableView?.register(ChatTipsTableViewCell.self, forCellReuseIdentifier: self.tipsReuseIdentifier)
        self.tableView?.register(ChatImageTableViewCell.self, forCellReuseIdentifier: self.imageReuseIdentifier)
        self.tableView?.register(ChatAudioTableViewCell.self, forCellReuseIdentifier: self.audioReuseIdentifier)
        self.tableView?.register(ChatVideoTableViewCell.self, forCellReuseIdentifier: self.videoReuseIdentifier)
        self.tableView?.register(ChatLocateTableViewCell.self, forCellReuseIdentifier: self.locateReuseIdentifier)
        
        self.tableView?.separatorStyle = .none
        addObserver()
        
        initHeaderRefresh()
        
        inputTextView.delegate = self
        
        self.inputToolView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: &context)
        

        self.recordVoiceButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchDragInside)
        
        self.recordVoiceButton.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControlEvents.touchDragOutside)

        // 开始
        self.recordVoiceButton.addTarget(self, action: #selector(self.touchDown), for: UIControlEvents.touchDown)
        
        // 动画栏文字判断
        self.recordVoiceButton.addTarget(self, action: #selector(self.touchDragEnter), for: UIControlEvents.touchDragEnter)
        
        self.recordVoiceButton.addTarget(self, action: #selector(self.touchDragExit), for: UIControlEvents.touchDragExit)
        
        // 结束判断
        self.recordVoiceButton.addTarget(self, action: #selector(self.touchUpInside), for: UIControlEvents.touchUpInside)
        
        self.recordVoiceButton.addTarget(self, action: #selector(self.touchUpOutside), for: UIControlEvents.touchUpOutside)
        
        recordAudio.delegat = self
    }
    
    @objc func touchDragExit() {
        debugLog("松开手指 取消发送")
        recordVoiceAnimationView.showCancel()
    }
    
    @objc func touchDragEnter() {
        debugLog("手指上滑 取消发送")
        recordVoiceAnimationView.showSend()
    }
    
    @objc func touchUpOutside() {
        _ = recordAudio.stop()
        // 取消发送语音
        debugLog("取消发送语音")
        
        recordVoiceButton.setTitle("按住 说话", for: UIControlState.normal)
        recordVoiceButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        recordVoiceAnimationView.dismiss()
    }
    
    @objc func touchUpInside() {
        _ = recordAudio.stop()
        // 发送语音
        debugLog("发送语音")
        recordVoiceButton.setTitle("按住 说话", for: UIControlState.normal)
        recordVoiceButton.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
        recordVoiceAnimationView.dismiss()
    }
    

    @objc func touchDown() {
        debugLog("开始录音")
        _ = recordAudio.begin()
        recordVoiceAnimationView.creat()
        recordVoiceAnimationView.show(peakPower: 1.0)
        recordVoiceButton.setTitle("松开 结束", for: UIControlState.normal)
        recordVoiceButton.backgroundColor = #colorLiteral(red: 0.7490196078, green: 0.7529411765, blue: 0.7647058824, alpha: 1)
        // 按钮选中进行录音
    }

    private var context = 1
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &self.context {
//            print(inputToolView.origin.y)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.25)
            UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: 7)!)
            
//            self.tableView?.frame.origin.y =
            self.tableView?.bottom = self.inputToolView.top
            
            UIView.commitAnimations()
        }
    }
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        debugLog(dataSource[indexPath.row].layout?.height ?? "高度错误")
        return dataSource[indexPath.row].layout?.height ?? 58.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.dataSource[indexPath.row]
        
        if data.mType == .text {
            // 这里是文字消息
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.textReuseIdentifier, for: indexPath) as? ChatTextTableViewCell {
                cell.model = data
                
                cell.selectionStyle = .none
                cell.setLayout()
                
                return cell
            }
        } else if data.mType == .audio {
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.audioReuseIdentifier, for: indexPath) as? ChatAudioTableViewCell {
                cell.model = data
                cell.selectionStyle = .none
                cell.setLayout()
                return cell
            }
        } else if data.mType == .tips {
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.tipsReuseIdentifier, for: indexPath) as? ChatTipsTableViewCell {
                cell.model = data
                cell.selectionStyle = .none
                cell.setLayout()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
//        debugLog("xxx",#function)
        // 开始滑动
    }
    
    // 下啦 - 加载
    override func loadNewData() {
        
    }
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        removeObserver()
    }
    
}

extension ChatViewController: HPGrowingTextViewDelegate {
    
    func growingTextViewDidChange(_ growingTextView: HPGrowingTextView!) {
        self.inputText = growingTextView.text
    }
    
    func growingTextView(_ growingTextView: HPGrowingTextView!, willChangeHeight height: Float) {
        let diff = (growingTextView.frame.size.height - CGFloat(height));
        var r = inputToolView.frame;
        r.size.height -= diff;
        r.origin.y += diff;
        inputToolView.frame = r;
    }
}

extension ChatViewController: JYAMRRecordAudioDelegate {
    func audioData(_ data: Data?) {
        // 存储
        debugLog("存储录音", data?.count)
    }
    
    func peakPowerSoundRecorded(peakPower: Double) {
        recordVoiceAnimationView.show(peakPower: peakPower)
    }
    
    
}
