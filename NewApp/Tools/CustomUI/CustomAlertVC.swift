//
//  CommentInputVC.swift
//  KuWen
//
//  Created by weijieMac on 2019/2/23.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

protocol AlertAnimationViewProtocol {
    func showAnimation()
    func dismissAnimation(finish:@escaping (()->()))
}

class CustomAlertVC: UIViewController {
    
    enum ContentType {
        case animation(AlertAnimationViewProtocol)
    }
    
    open var hidddenStatusBar = false
    
    open var touchEmptyNeedDismiss = true
    
    
    private lazy var window: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self
        window.isHidden = false
        return window
    }()
    
    private var type : ContentType?
    
    init(contentType:ContentType) {
        super.init(nibName: nil, bundle: nil)
        type = contentType
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView(){
        view.backgroundColor = colorRGBA(red: 0, green: 0, blue: 0, alpha: 0.3)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNoti(noti:)), name: NSNotification.Name(rawValue: "CloseCustomAlertVC"), object: nil)
        switch type! {
        case .animation(let contentV):
            view.addSubview(contentV as! UIView)
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var contentView : UIView
        switch type! {
        case .animation(let content):
            contentView = content as! UIView
        default:
            break
        }
        guard touches.first!.location(in: contentView).y < 0 else {
            return
        }
        if touchEmptyNeedDismiss {
            dismiss()
        }
    }
    
    @objc private func dismissNoti(noti:Notification) {
        dismiss()
    }
    
    func dismiss() {
        switch type! {
        case .animation(let view):
            view.dismissAnimation {[weak self] in
                self?.closeWindow()
            }
        default:
            dismissContent()
            closeWindow()
        }
    }
    
    private func closeWindow() {
        _ = view.subviews.map{ subView in subView.removeFromSuperview() }
        window.rootViewController = nil
        window.isHidden = true
        window.removeFromSuperview()
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(window)
    }
    
    func dismissContent() {
        switch type! {

        default :
            break
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch type!{
        
        case .animation(let contentV):
            contentV.showAnimation()
        default :
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override var prefersStatusBarHidden: Bool {
        return hidddenStatusBar
    }
}



