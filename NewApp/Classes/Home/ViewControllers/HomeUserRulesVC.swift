//
//  HomeUserRulesVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/9.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import WebKit

class HomeUserRulesVC: RootVC {

    private lazy var webView: WKWebView = {
        let webview = WKWebView(frame: CGRect(x: 0, y: naviView!.bottom, width: screenWidth, height: screenHeight - naviView!.bottom))
        webview.backgroundColor = whiteColor
        return webview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRule()
    }

    override func configView() {
        configNaviView(title: "玩法指导")
        view.backgroundColor = whiteColor
        view.addSubview(webView)
    }
    
    private func getRule() {
        net_getUserRules {[weak self] (content) in
            if content != nil {
               self!.webView.loadHTMLString(content!, baseURL: nil)
            }
        }
    }
}
