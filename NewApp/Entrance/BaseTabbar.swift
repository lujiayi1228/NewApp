//
//  BaseTabbar.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CustomTabbarDelegate : NSObjectProtocol {
    @objc optional func tabbarDidSelectedVC(_ tabbar:CustomTabbar,with viewController:UIViewController)
}

class CustomTabbar: UIView {
    weak var barDelegate : CustomTabbarDelegate?
    var selectedVC : UIViewController?
    var selectedIndex : Int = -1
    let tabbarBackgroundColor = whiteColor
    let itemBackgroundColor = whiteColor
    
    private var itemsArr : [UIButton] = []
    private var vcDic : [Int:UIViewController] = [:]
    private var naviDic : [Int:UINavigationController] = [:]
    private static let tabbar = CustomTabbar.init(frame: CGRect.init(x: 0, y: phoneBottom-50, width: screenWidth, height: 50+phoneTop))
    private let plistData : NSDictionary = {
        let plistPath = Bundle.main.path(forResource: "TabbarInfo", ofType: "plist")
        let dic = NSDictionary.init(contentsOfFile: plistPath!)
        return dic!
    }()
    
    
    class func shared() -> CustomTabbar {
        return tabbar
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class func showTabbar(){
        let tabbar = CustomTabbar.shared()
        tabbar.gotoPageIndex(index: selectedIndex() == -1 ? 0:selectedIndex())
    }
    
    public class func hiddenTabbar() {
        self.shared().removeFromSuperview()
    }
    
    @discardableResult
    public class func gotoPageIndex(pageIndex:Int) -> UIViewController{
        return shared().gotoPageIndex(index:pageIndex)
    }
    
    public class func reloadView() {
        
    }
    
    public class func selectedController() -> UIViewController? {
        return self.shared().selectedVC
    }
    
    public class func selectedIndex() -> Int {
        return self.shared().selectedIndex;
    }
    
    private func configView() {
        self.backgroundColor = tabbarBackgroundColor
        createBtns()
        createControllers()
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
        topLine.backgroundColor = colorRGBA(red: 200, green: 200, blue: 200, alpha: 1)
        addSubview(topLine)
    }
    
    private func createBtns() {
        let btnWidth = screenWidth*1.0/CGFloat(plistData.count)
        
        for key in plistData.allKeys {
            let dic : NSDictionary = plistData[key] as! NSDictionary
            let imageNames : NSDictionary = dic.object(forKey: "imageNames") as! NSDictionary
            let normalImage = imageNames["normal"] as! String
            let selectedImage = imageNames["selected"] as! String
            let title = dic.object(forKey: "ItemName") as! String
            let normalImg = UIImage.svgImageNamed(name: normalImage, size: CGSize(width: 22, height: 22))
            let selectedImg = UIImage.svgImageNamed(name: selectedImage, size: CGSize(width: 22, height: 22))
            let btn = CustomButton(type: .custom)
            btn.layout = .normalTopBottom
            btn.addTarget(self, action: #selector(btnSelected(sender:)), for: .touchUpInside)
            btn.setImage(normalImg, for: .normal)
            btn.setImage(selectedImg, for: .selected)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.setTitleColor(colorRGBA(red: 100, green: 100, blue: 100, alpha: 1), for: .normal)
            btn.setTitleColor(colorRGBA(red: 245, green: 90, blue: 93, alpha: 1), for: .selected)
            var keyNum : Int = 0
            if let keyStr = key as? String {
                keyNum = Int(keyStr)!
            }
            btn.isSelected = keyNum == 0
            btn.tag = keyNum
            btn.frame = CGRect.init(x: btnWidth*CGFloat(btn.tag), y: 0, width: btnWidth, height: self.height)
            btn.backgroundColor = itemBackgroundColor
            self.addSubview(btn)
            itemsArr.append(btn)
            
        }
    }
    
    private func createControllers() {
        for index in 0 ..< plistData.allKeys.count {
            let dic : NSDictionary = plistData.object(forKey: NSString.init(string: String(index))) as! NSDictionary
            let className = dic.object(forKey: "ClassName") as! String
            let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
            guard let ns = nameSpace as? String else{
                continue
            }
            let myClass: AnyClass? = NSClassFromString(ns + "." + className)
            guard let viewControllerClass = myClass as? UIViewController.Type else{
                continue
            }
            
            let vc = viewControllerClass.init()
            vcDic[index] = vc
            let navi = BaseNavigationController.init(rootViewController: vc)
            navi.navigationBar.isHidden = true
            naviDic[index] = navi
            
        }
        selectedVC = vcDic[0]
        baseViewControllers = vcDic
        baseNavigationControllers = naviDic
        baseSelectedVC = selectedVC!
        baseSelectedNavi = naviDic[0]!
    }
    
    @objc func btnSelected(sender:UIButton){
        gotoPageIndex(index: sender.tag)
    }
    
    private func setCurrentSelectedIndex(index:Int) {
        for btn in itemsArr {
            btn.isSelected = btn.tag == index
        }
    }
    
    @discardableResult
    private func gotoPageIndex(index:Int) -> UIViewController{
        guard 0..<plistData.allKeys.count ~= index else {
            return selectedVC!
        }
        let window = UIApplication.shared.delegate?.window!
        baseSelectedVC = vcDic[index]!
        baseSelectedNavi = naviDic[index]!
        selectedVC = baseSelectedVC
        selectedIndex = index
        window?.rootViewController = baseSelectedNavi
        window?.makeKeyAndVisible()
        if !(baseSelectedVC.view.subviews.contains(self)) {
            baseSelectedVC.view.addSubview(self)
        }
        if barDelegate != nil  {
            barDelegate!.tabbarDidSelectedVC?(self, with: baseSelectedVC)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tabbardidselected"), object: nil)
        for btn in itemsArr {
            btn.isSelected = index == btn.tag
        }
        return baseSelectedVC
    }
}

