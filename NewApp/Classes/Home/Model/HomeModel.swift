//
//  HomeModel.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/8.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation

struct HomeLastlotteryModel : Codable{
    let error : Int
    
    let msg : Info?
    
    let mbstr : Response.Mbstr
    
    struct Info : Codable{
        let num : Int
        let result : String?
        let iswin : Int
        let shuang : String?
        let dan : String?
        let isodd : String?
        let result_he : Int
        let targettime : Int
        let targetnum : String?
    }
}

struct HomeLotteryModel : Codable {
    let error : Int
    
    let msg : Info?
    
    let mbstr : Response.Mbstr
    
    struct Info : Codable{
        let kaijiang : Int
        let list : [Result]?
        let sec : Int
        let kaijiangnum : String?
        let targettime : Int
        let targetnum : String?
    }
    
    struct Result : Codable{
        let left : String?
        let right : String?
        let odd_name : String?
        let result_he : Int
        
        init(left:String?,right:String?,odd_name:String?,result_he:Int) {
            self.left = left
            self.right = right
            self.odd_name = odd_name
            self.result_he = result_he
        }
    }
}

struct PaylistModel : Codable {
    let error : Int
    
    let msg : Info?
    
    let mbstr : Response.Mbstr
    
    struct Info : Codable {
        let list : [proxy]
    }
    
    struct proxy : Codable {
        let name : String?
        let number : String?
        let wxnick : String?
    }
}

