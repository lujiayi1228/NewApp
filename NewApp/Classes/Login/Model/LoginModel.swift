//
//  LoginModel.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/4.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

struct LoginModel : Codable {
    
    let error : Int
    
    let msg : Info
    
    let mbstr : Response.Mbstr
    
    struct Info : Codable{
        let user_id : String
        let openid : String?
        let nickname : String?
        let realname : String?
        let alipay : String?
        let headimgurl : String?
        let set : String?
        let mobile : String?
        let unusual : Int
    }
    
}
