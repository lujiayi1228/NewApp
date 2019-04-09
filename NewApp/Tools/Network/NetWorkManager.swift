//
//  NetWorkManager.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/22.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import Moya

let networkManager = MoyaProvider<NetworkManager>()

let HostIP = "http://192.168.1.120:8001"

let deviceId = UIDevice.current.identifierForVendor!.uuidString

fileprivate enum Method: String {
    
    case regForm            = "Api/User/regForm"                //会员注册
    case loginCheck         = "Api/User/loginCheck"             //用户登录
    case userInfoForm       = "Api/User/userInfoForm"           //会员信息修改
    case userInfo           = "Api/User/userinfo"               //会员信息
    case paylist            = "Api/Paylist/paylist"             //提现充值记录 & 用户收益明细
    case infoCheck          = "Api/User/infoCheck"              //用户信息验证
    case lastlottery        = "Api/Index/lastlottery"           //最近一期开奖
    case lottery            = "Api/Index/lottery"               //开奖记录
    case goodslist          = "Api/Index/goodslist"             //商品列表
    case addorder           = "Api/Order/addorder"              //创建订单
    case payvalue           = "Api/Paylist/payvalue"            //支付面值
    case addpay             = "Api/Paylist/addpay"              //创建支付 & 提现申请
    case getPayurl          = "Api/Paylist/getPayurl"           //获取支付路径
    case addmyorder         = "Api/Order/addmyorder"            //订单列表
    case myordercount       = "Api/Order/myordercount"          //订单列表
    case topOrder           = "Api/Index/top"                   //订单列表
    case addorderlist       = "Api/Order/addorderlist"          //首页订单列表
    case goodsdetail        = "Api/Index/goodsdetail"           //下单信息
    case exchange           = "Api/Order/exchange"              //兑换操作
    case exchangelog        = "Api/Order/exchangelog"           //兑换记录
    case orderdetail        = "Api/order/orderdetail"           //订单详情
    case qrcodeInvite       = "Api/Ad/qrcodeInvite"             //二维码图片
    case userProtocol       = "Home/Shopconfig/protocol"        //用户协议
    case userRules          = "Home/Shopconfig/rules/type/1"    //用户规则
    case userQuestion       = "Home/Shopconfig/rules/type/2"    //常见问题
    case bonusRules         = "Home/Shopconfig/bonusRules"      //红包规则
    case startAppNotice     = "Api/Shopconfig/startAppNotice"   //启动app通知
    case updateVersion      = "Api/Shopconfig/updateVersion"    //检查版本
    case userPassForm       = "Api/User/userPassForm"           //修改密码
    case userFindPass       = "Api/User/userFindPass"           //找回密码时修改密码
    case headimgSave        = "Api/User/headimgSave"            //头像上传保存
    case tixianlist         = "Api/Paylist/tixianlist"          //提现列表
    case checkUserStatus    = "Api/User/checkUserStatus"        //检查帐号异常
    case sendmsg            = "Api/Shopconfig/sendmsg"          //发送短信验证码
    case checkmsg           = "Api/Shopconfig/checkmsg"         //短信验证码验证
    case aboutUs            = "Home/ShopConfig/aboutUs"         //关于我们页面
    case apprenticeList     = "Api/User/apprenticeList"         //会员徒弟列表
    case qiang              = "api/bonus/qiang"                 //抢红包
    case tousu              = "Api/Shopconfig/tousu"            //投诉代理
    case feedback           = "Api/Shopconfig/feedback"         //反馈
    case feedbackList       = "Api/Shopconfig/feedbackList"     //反馈列表

}

enum NetworkManager {

    case regForm(mobile:String,password:String,password_two:String,code:String)                      //会员注册
    case loginCheck(phone:String,password:String)                   //用户登录
    case userInfoForm()                 //会员信息修改
    case userInfo()                     //会员信息
    case paylist()                      //提现充值记录 & 用户收益明细
    case infoCheck()                    //用户信息验证
    case lastlottery()                  //最近一期开奖
    case lottery()                      //开奖记录
    case goodslist()                    //商品列表
    case addorder()                     //创建订单
    case payvalue()                     //支付面值
    case addpay()                       //创建支付 & 提现申请
    case getPayurl(price:Int)                    //获取支付路径
    case addmyorder()                   //订单列表
    case myordercount()                 //订单列表
    case topOrder()                     //订单列表
    case addorderlist()                 //首页订单列表
    case goodsdetail()                  //下单信息
    case exchange()                     //兑换操作
    case exchangelog()                  //兑换记录
    case orderdetail()                  //订单详情
    case qrcodeInvite()                 //二维码图片
    case userProtocol()                 //用户协议
    case userRules()                    //用户规则
    case userQuestion()                 //常见问题
    case bonusRules()                   //红包规则
    case startAppNotice()               //启动app通知
    case updateVersion()                //检查版本
    case userPassForm()                 //修改密码
    case userFindPass()                 //找回密码时修改密码
    case headimgSave()                  //头像上传保存
    case tixianlist()                   //提现列表
    case checkUserStatus()              //检查帐号异常
    case sendmsg(phone:String,type:Int) //发送短信验证码
    case checkmsg()                     //短信验证码验证
    case aboutUs()                      //关于我们页面
    case apprenticeList()               //会员徒弟列表
    case qiang()                        //抢红包
    case tousu()                        //投诉代理
    case feedback()                     //反馈
    case feedbackList()                 //反馈列表

}

extension NetworkManager: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: HostIP)!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        
        switch self {
        case .regForm(_,_,_,_):
            return Method.regForm.rawValue
        case .loginCheck(_,_):
            return Method.loginCheck.rawValue
        case .userInfoForm():
            return Method.userInfoForm.rawValue
        case .userInfo():
            return Method.userInfo.rawValue
        case .paylist():
            return Method.paylist.rawValue
        case .infoCheck():
            return Method.infoCheck.rawValue
        case .lastlottery():
            return Method.lastlottery.rawValue
        case .lottery():
            return Method.lottery.rawValue
        case .goodslist():
            return Method.goodslist.rawValue
        case .addorder():
            return Method.addorder.rawValue
        case .payvalue():
            return Method.payvalue.rawValue
        case .addpay():
            return Method.addpay.rawValue
        case .getPayurl(_):
            return Method.getPayurl.rawValue
        case .addmyorder():
            return Method.addmyorder.rawValue
        case .myordercount():
            return Method.myordercount.rawValue
        case .topOrder():
            return Method.topOrder.rawValue
        case .addorderlist():
            return Method.addorderlist.rawValue
        case .goodsdetail():
            return Method.goodsdetail.rawValue
        case .exchange():
            return Method.exchange.rawValue
        case .exchangelog():
            return Method.exchangelog.rawValue
        case .orderdetail():
            return Method.orderdetail.rawValue
        case .qrcodeInvite():
            return Method.qrcodeInvite.rawValue
        case .userProtocol():
            return Method.userProtocol.rawValue
        case .userRules():
            return Method.userRules.rawValue
        case .userQuestion():
            return Method.userQuestion.rawValue
        case .bonusRules():
            return Method.bonusRules.rawValue
        case .startAppNotice():
            return Method.startAppNotice.rawValue
        case .updateVersion():
            return Method.updateVersion.rawValue
        case .userPassForm():
            return Method.userPassForm.rawValue
        case .userFindPass():
            return Method.userFindPass.rawValue
        case .headimgSave():
            return Method.headimgSave.rawValue
        case .tixianlist():
            return Method.tixianlist.rawValue
        case .checkUserStatus():
            return Method.checkUserStatus.rawValue
        case .sendmsg(_):
            return Method.sendmsg.rawValue
        case .checkmsg():
            return Method.checkmsg.rawValue
        case .aboutUs():
            return Method.aboutUs.rawValue
        case .apprenticeList():
            return Method.apprenticeList.rawValue
        case .qiang():
            return Method.qiang.rawValue
        case .tousu():
            return Method.tousu.rawValue
        case .feedback():
            return Method.feedback.rawValue
        case .feedbackList():
            return Method.feedbackList.rawValue
            
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .post
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        switch self {
        case .loginCheck(let phone,let password):
            return ["mobile":phone,"password":password,"u_deviceId":deviceId]
        case .sendmsg(let phone,let type):
            return ["mobile":phone,"type":type,"u_deviceId":deviceId]
        case .regForm(let mobile, let password, let password_two, let code):
            return ["tidcodes":"BJSC:LP0CFY2YCF2B9C70775093NLKE" , "mobile":mobile,"password":password,"password_two" : password_two, "code":code ,"u_deviceId":deviceId]
        case .getPayurl(let price):
            return ["u_uid":UserInfoManager.shared().userInfo!.msg.user_id,"payaccount":price]
        default:
            break
        }
        return nil
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        if parameters != nil {
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.default)
        }else {
            return .requestPlain
        }
    }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    
    var validationType: ValidationType {
        return .none
    }

}



