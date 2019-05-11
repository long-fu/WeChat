//
//  GroupCreatViewController.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/10.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit
import YYText
/// 创建队伍
class GroupCreatViewController: JYBasicViewController {
    
    
    lazy var createButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("创 建", for: UIControlState.normal)
        
        return button
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    lazy var descriptionTextView: YYTextView  = {
        let textView = YYTextView()
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
