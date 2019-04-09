//
//  AppDelegate+Category.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/9.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManager

extension AppDelegate : MainViewLogicable{
    //初始化app设置，可以在这里提前替换方法，加载组件等
    func initAppConfig(){
        UIFont.initializeMethod()
        windowShowHomeView()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

