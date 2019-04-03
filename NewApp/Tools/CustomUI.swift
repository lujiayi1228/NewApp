//
//  CustomUI.swift
//  KuWen
//
//  Created by weijieMac on 2019/2/13.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

class CustomButton : UIButton {
    enum ImageTitleLayout {
        case leftImageTitle(spacing:CGFloat)//横向靠左布局,image - title
        case topImageTitle(spacing:CGFloat)//垂直靠顶布局
        case bidgeType//右上角数字角标
        case leftTitleImage(spacing:CGFloat,imageSize:CGSize)//水平，title - image
        case normalTopBottom//自然上下布局,不修改imageview大小
    }
    
    var layout = ImageTitleLayout.leftImageTitle(spacing: 0)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch layout {
        case .leftImageTitle(let spacing):
            imageView?.frame = CGRect(x: 0, y: 0, width: height, height: height)
            titleLabel?.frame = CGRect(x: (imageView?.right)! + spacing + 4, y: 0, width: width - (imageView?.right)! - spacing - 4, height: height)
        case .topImageTitle(let spacing):
            imageView?.frame = CGRect(x: 0, y: 0, width: width, height: width)
            titleLabel?.frame = CGRect(x: 0, y: (imageView?.bottom)! + spacing, width: width, height: height - (imageView?.bottom)! - spacing)
            titleLabel?.textAlignment = .center
        case .bidgeType:
            imageView?.frame = CGRect(x: 0, y: 0, width: width*3/5, height: width*3/5)
            imageView?.center = CGPoint(x: width/2, y: height/2)
            
            titleLabel?.frame = CGRect(x: 0, y: 0, width: width/2, height: width/5)
            titleLabel?.sizeToFit()
            titleLabel?.right = width
            titleLabel?.textColor = whiteColor
            titleLabel?.backgroundColor = UIColor.red
            let radius = (titleLabel?.height)! <= (titleLabel?.width)! ? (titleLabel?.height)!/2 : (titleLabel?.width)!/2
            titleLabel?.layer.cornerRadius = radius
            titleLabel?.layer.masksToBounds = true
            titleLabel?.textAlignment = .center
            titleLabel?.font = UIFont.systemFont(ofSize: 12)
        case .leftTitleImage(let spacing,let imageSize):
            titleLabel?.frame = CGRect(x: 0, y: 0, width: width - imageSize.width - spacing, height: height)
            if imageSize != .zero {
                imageView?.frame = CGRect(x: (titleLabel?.right)! + spacing, y: 0, width: imageSize.width, height: imageSize.height)
                imageView?.centerY = height/2
            }
        case .normalTopBottom:
            imageView?.centerX = width / 2
            imageView?.top = (height - (imageView!.height + titleLabel!.height + 4)) / 2
            titleLabel?.centerX = imageView!.centerX
            titleLabel?.top = imageView!.bottom + 4
        }
        
    }
}
