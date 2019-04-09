//
//  UserProtocolVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/7.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import WebKit

class UserProtocolVC: RootVC {

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect(x: 0, y: naviView!.bottom, width: view.width, height: screenHeight - naviView!.bottom))
        webView.backgroundColor = view.backgroundColor
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        //TODO:load htmlstring from sever
        
    }
    
    override func configView() {
        configNaviView(title: "用户注册协议")
    }

}
