//
//  ResetPasswordVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/7.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResetPasswordVC: RootVC {

    private let spacing : CGFloat = realValue_H(value: 60)
    
    private lazy var bgView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: naviView!.bottom, width: screenWidth, height: screenHeight - naviView!.bottom))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentSize = view.size
        view.backgroundColor = whiteColor
        return view
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: realValue_W(value: 70), y: realValue_H(value: 160), width: realValue_W(value: 150), height: realValue_H(value: 80)))
        label.text = "新密码"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = blackColor
        return label
    }()
    
    private lazy var passwordTF: UITextField = {
        let tf = UITextField(frame: passwordLabel.frame)
        tf.width = screenWidth - passwordLabel.left * 2 - passwordLabel.width
        tf.left = passwordLabel.right
        tf.placeholder = "请输入密码(长度在6-12之间)"
        tf.textColor = passwordLabel.textColor
        tf.font = passwordLabel.font
        tf.backgroundColor = whiteColor
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private lazy var verifyLabel: UILabel = {
        let label = UILabel(frame: passwordLabel.frame)
        label.top = passwordLabel.bottom + spacing
        label.text = "确认密码"
        label.font = passwordLabel.font
        label.textColor = passwordLabel.textColor
        return label
    }()
    
    private lazy var verifyTF : UITextField = {
        let tf = UITextField(frame: passwordTF.frame)
        tf.top = verifyLabel.top
        tf.placeholder = "请确认新密码"
        tf.textColor = passwordTF.textColor
        tf.font = passwordTF.font
        tf.backgroundColor = passwordTF.backgroundColor
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private lazy var finishBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: verifyLabel.left, y: verifyLabel.bottom + spacing + 20, width: verifyLabel.width + verifyTF.width, height: verifyLabel.height)
        btn.height += 5
        btn.backgroundColor = themeColor
        btn.setTitle("确认", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.cornerRadius(radius: btn.height/2)
        btn.addTarget(self, action: #selector(finishAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configView() {
        configNaviView(title: "重置密码")
        view.addSubview(bgView)
        bgView.addSubview(passwordLabel)
        bgView.addSubview(passwordTF)
        bgView.addSubview(verifyLabel)
        bgView.addSubview(verifyTF)
        bgView.addSubview(finishBtn)
        configLines()
    }

    @objc private func finishAction(sender:UIButton) {
        guard !passwordTF.text!.isEmpty && (6..<13).contains(passwordTF.text!.count) else {
            SVProgressHUD.showError(withStatus: passwordTF.placeholder)
            return
        }
        
        guard !verifyTF.text!.isEmpty && (6..<13).contains(verifyTF.text!.count) && verifyTF.text! == passwordTF.text! else {
            SVProgressHUD.showError(withStatus: "请重新确认密码")
            return
        }
        //TODO:接口
        
        
    }
    
    private func configLines() {
        let bottoms = [passwordLabel.bottom,verifyLabel.bottom]
        for bottom in bottoms {
            let line = UIView(frame: CGRect(x: passwordLabel.left, y: bottom + 4, width: passwordLabel.width + passwordTF.width, height: 1))
            line.backgroundColor = colorRGBA(red: 230, green: 230, blue: 230, alpha: 1)
            bgView.addSubview(line)
        }
    }

}
