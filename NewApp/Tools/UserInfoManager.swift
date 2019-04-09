//
//  UserInfoManager.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/9.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class UserInfoManager: NSObject {
    
    static func shared() -> UserInfoManager {
        return sharedManager
    }
    
    private static let sharedManager: UserInfoManager = {
        let shared = UserInfoManager()
        return shared
    }()
    
    var userInfo : LoginModel? {
        didSet {
            isLogin = userInfo != nil
        }
    }
    
    var isLogin = false
}
