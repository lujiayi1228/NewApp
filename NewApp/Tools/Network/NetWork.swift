//
//  NetWork.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/3.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SVProgressHUD

struct Response : Codable {
    let error : Int
    let msg : String
    let mbstr : Mbstr
    
    struct Mbstr : Codable {
        let str : String
        let time : Int
    }
}

//登录
func net_loginAction(phone:String, password:String, handle:@escaping ((LoginModel?,Response?)->())) {
    networkManager.request(.loginCheck(phone:phone,password:password)) { (result) in
        switch result {
        case .success(let response):
            let data = try! response.mapJSON()
            if (data as! NSDictionary)["error"] as! Int != 0 {
                let error = try? JSONDecoder().decode(Response.self, from: response.data)
                handle(nil,error)
            }else {
                let model = try? JSONDecoder().decode(LoginModel.self, from: response.data)
                handle(model,nil)
            }
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}

//注册_发送短信验证码
func net_sendmsgAction(phone:String, handle:@escaping ((Response?)->()), netError:@escaping (()->())) {
    networkManager.request(.sendmsg(phone:phone,type:1)) { (result) in
        switch result {
        case .success(let response):
            let data = try? JSONDecoder().decode(Response.self, from: response.data)
            handle(data)
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
            netError()
        }
    }
}

//注册_注册
func net_registerAction(mobile:String,password:String,password_two:String,code:String, handle:@escaping ((LoginModel?,Response?)->())) {
    networkManager.request(.regForm(mobile:mobile,password:password,password_two:password_two,code:code)) { (result) in
        switch result {
        case .success(let response):
            let data = try! response.mapJSON()
            if (data as! NSDictionary)["error"] as! Int != 0 {
                let error = try? JSONDecoder().decode(Response.self, from: response.data)
                handle(nil,error)
            }else {
                let model = try? JSONDecoder().decode(LoginModel.self, from: response.data)
                handle(model,nil)
            }
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}

/*
 首页
 */
//首页_获取最后一次开奖
func net_getLastlottery(handle:@escaping ((HomeLastlotteryModel?,Response?)->())) {
    networkManager.request(.lastlottery()) { (result) in
        switch result {
        case .success(let response):
            let data = try! response.mapJSON()
            if (data as! NSDictionary)["error"] as! Int != 0 {
                let error = try? JSONDecoder().decode(Response.self, from: response.data)
                handle(nil,error)
            }else {
                let model = try? JSONDecoder().decode(HomeLastlotteryModel.self, from: response.data)
                handle(model,nil)
            }
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}

//首页_开奖(获取最后一次开奖的倒计时结束时获取的数据，用来做滚动动画)
func net_getLottery(handle:@escaping ((HomeLotteryModel?,Response?)->())) {
    networkManager.request(.lastlottery()) { (result) in
        switch result {
        case .success(let response):
            let data = try! response.mapJSON()
            if (data as! NSDictionary)["error"] as! Int != 0 {
                let error = try? JSONDecoder().decode(Response.self, from: response.data)
                handle(nil,error)
            }else {
                let model = try? JSONDecoder().decode(HomeLotteryModel.self, from: response.data)
                handle(model,nil)
            }
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}

//获取首页游戏规则
func net_getUserRules(handle:@escaping ((String?)->())) {
    networkManager.request(.userRules()) { (result) in
        switch result {
        case .success(let response):
            let content = String(data: response.data, encoding: String.Encoding.utf8)
            handle(content)
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}

//获取充值页面的微信代理模式下的数据
func net_getPaylist(handle:@escaping ((PaylistModel?,Response?)->())) {
    networkManager.request(.paylist()) { (result) in
        switch result {
        case .success(let response):
            let data = try! response.mapJSON()
            if (data as! NSDictionary)["error"] as! Int != 0 {
                let error = try? JSONDecoder().decode(Response.self, from: response.data)
                handle(nil,error)
            }else {
                let model = try? JSONDecoder().decode(PaylistModel.self, from: response.data)
                handle(model,nil)
            }
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}

//获取支付路径
func net_getPayurl(price:Int,handle:@escaping (()->())) {
    networkManager.request(.getPayurl(price:price)) { (result) in
        switch result {
        case .success(let response):
            let data = try! response.mapJSON()
//            if (data as! NSDictionary)["error"] as! Int != 0 {
//                let error = try? JSONDecoder().decode(Response.self, from: response.data)
//                handle(nil,error)
//            }else {
//                let model = try? JSONDecoder().decode(PaylistModel.self, from: response.data)
//                handle(model,nil)
//            }
        case .failure(let error):
            SVProgressHUD.showError(withStatus: "网络异常:\(error)")
        }
    }
}
