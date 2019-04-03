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

//TODO:需要一个接口来检测有效域名
//47.102.39.175
//wq.zhaowenxishi.cn
//wq.zhaowenxishi.com
//wq.yiwenqushi.cn
let HostIP = "http://wq.zhaowenxishi.cn"

enum NetworkManager {
    enum method: String {
        
        /*
         登录
         */
        case wxLogin = "account/wxCodeLogin"//微信登录
        case autoLogin = "account/auto" //自动登录
        
    }

    /*
     登录
     */
    case wxLogin(type: method , code: String)//微信登录
    case autoLogin(type: method)//自动登录
    
    
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
        case .wxLogin(let type,_),
             .autoLogin(let type)
             :
            return type.rawValue
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .post
    }
    
    /// The parameters to be encoded in the request.
    var parameters: [String: Any]? {
        switch self {
        case .wxLogin(_,let code):
            return ["code":code]
        
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
        return "test".data(using: .utf8)!
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



