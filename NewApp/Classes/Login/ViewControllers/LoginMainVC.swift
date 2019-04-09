//
//  LoginMainVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/4.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginMainVC: RootVC {
    
    @IBOutlet weak var bgView: UIScrollView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var phoneLine: UIView!
    @IBOutlet weak var passwordLine: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configView() {
        bgView.frame = screenFrame
        bgView.height -= 20
        bgView.contentSize = bgView.size
        
        
        closeBtn.right = screenWidth - 20
        closeBtn.top = 0
        closeBtn.setImage(UIImage.svgImageNamed(name: "关闭", size: CGSize(width: 20, height: 20)), for: .normal)
        
        imageV.frame = CGRect(x: 0, y: 70, width: 70, height: 70)
        imageV.centerX = bgView.width/2
        
        phoneLabel.frame = CGRect(x: 35, y: imageV.bottom + 50, width: 70, height: 30)
        phoneTF.frame = phoneLabel.frame
        phoneTF.width = screenWidth - phoneLabel.right - 8 - phoneLabel.left
        phoneTF.left = phoneLabel.right + 8
        phoneLine.frame = CGRect(x: phoneLabel.left, y: phoneLabel.bottom + 4, width: phoneTF.right - phoneLabel.left, height: 0.5)
        phoneLine.backgroundColor = colorRGBA(red: 220, green: 220, blue: 220, alpha: 1)
        
        passwordLabel.frame = phoneLabel.frame
        passwordLabel.top = phoneLine.bottom + 12
        passwordTF.frame = phoneTF.frame
        passwordTF.top = passwordLabel.top
        passwordLine.frame = phoneLine.frame
        passwordLine.top = passwordLabel.bottom + 4
        passwordLine.backgroundColor = phoneLine.backgroundColor
        
        loginBtn.frame = passwordLine.frame
        loginBtn.height = 45
        loginBtn.top = passwordLine.bottom + 16
        loginBtn.layer.cornerRadius = loginBtn.height/2
        loginBtn.layer.masksToBounds = true
        
        forgetBtn.frame = loginBtn.frame
        forgetBtn.width = loginBtn.width/2 - 0.5
        forgetBtn.top = loginBtn.bottom + 8
        
        line.frame = CGRect(x: forgetBtn.right, y: forgetBtn.top + forgetBtn.height/4, width: 1, height: forgetBtn.height/2)
        
        registerBtn.frame = forgetBtn.frame
        registerBtn.right = loginBtn.right
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if navigationController!.viewControllers.count < 3 {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    @IBAction func closedAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refreshLineColor(_ sender: UITextField) {
        phoneLine.backgroundColor = sender.tag == 0 ? loginBtn.backgroundColor : colorRGBA(red: 230, green: 230, blue: 230, alpha: 1)
        passwordLine.backgroundColor = sender.tag == 1 ? loginBtn.backgroundColor : colorRGBA(red: 230, green: 230, blue: 230, alpha: 1)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard !phoneTF.text!.isEmpty && phoneTF.text!.isPhoneNumber() else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            return
        }
        
        guard !passwordTF.text!.isEmpty && (6..<13).contains(passwordTF.text!.count) else {
            SVProgressHUD.showError(withStatus: "密码位数不正确")
            return
        }

        net_loginAction(phone: phoneTF.text!, password: passwordTF.text!) {[weak self] (data, error) in
            if data != nil {
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                UserInfoManager.shared().userInfo = data
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func forgetAction(_ sender: UIButton) {
        let newVC = FindPasswordVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        let newVC = RegisterVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
}

//Action
extension LoginMainVC {
    
}
