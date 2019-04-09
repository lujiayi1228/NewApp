//
//  UIImage+Extension.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/3.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {
    static func svgImageNamed(name:String,size:CGSize) -> UIImage {
        let image = SVGKImage(named: name)
        image?.size = size
        return image!.uiImage
    }
}
