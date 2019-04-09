//
//  HomeRedenvelopeVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/9.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class HomeRedenvelopeVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configView() {
        configNaviView(title: "抢红包")
        rightBtn?.setTitle("规则", for: .normal)
        rightBtn?.isHidden = false
        rightBtn?.right = naviView!.width - leftBtn!.left
    }

}
