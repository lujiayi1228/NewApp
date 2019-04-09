//
//  ResultMainVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/3.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class ResultMainVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configView() {
        configNewNaviView()
    }
    
    private func configNewNaviView() {
        configNaviView(title: "开奖")
        leftBtn?.isHidden = true
    }

}
