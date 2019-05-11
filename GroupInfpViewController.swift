//
//  GroupInfpViewController.swift
//  DuDuLuYou
//
//  Created by LongJunYan on 2018/4/10.
//  Copyright © 2018年 onelcat. All rights reserved.
//

import UIKit

/// 队伍信息
class GroupInfpViewController: BasicTableViewController {
    
    private let cellHeight:[CGFloat] = [0.0]
    private let cellTitle = ["", "队长", "队员", "我的昵称", "队伍描述", "加载", "共享位置", "消息免打扰", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
