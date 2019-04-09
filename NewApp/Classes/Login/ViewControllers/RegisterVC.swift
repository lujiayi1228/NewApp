//
//  RegisterVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/4.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegisterVC: RootVC {
    
    private let spacing : CGFloat = realValue_H(value: 60)

    private var timer : Timer?
    private var time = 120
    
    private lazy var bgView: UIScrollView = {
        let view = UIScrollView(frame: CGRect(x: 0, y: naviView!.bottom, width: screenWidth, height: screenHeight - naviView!.bottom))
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentSize = view.size
        view.backgroundColor = whiteColor
        return view
    }()
    
    private lazy var phoneTF: UITextField = {
        let left = realValue_W(value: 80)
        let tf = UITextField(frame: CGRect(x: left, y: realValue_H(value: 160), width: screenWidth - left * 2, height: realValue_H(value: 80)))
        tf.backgroundColor = whiteColor
        tf.placeholder = "请输入手机号码"
        tf.textColor = blackColor
        tf.keyboardType = .numberPad
        tf.clearButtonMode = .whileEditing
        tf.font = UIFont.systemFont(ofSize: 16)
        return tf
    }()
    
    private lazy var codeTF: UITextField = {
        let tf = UITextField(frame: CGRect(x: phoneTF.left, y: phoneTF.bottom + spacing, width: phoneTF.width - realValue_W(value: 200), height: phoneTF.height))
        tf.backgroundColor = whiteColor
        tf.placeholder = "请输入验证码"
        tf.textColor = blackColor
        tf.keyboardType = phoneTF.keyboardType
        tf.font = phoneTF.font
        return tf
    }()
    
    private lazy var codeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: realValue_W(value: 200), height: phoneTF.height - 10)
        btn.centerY = codeTF.centerY
        btn.right = phoneTF.right
        btn.backgroundColor = themeColor
        btn.setTitle("获取验证码", for: .normal)
        btn.setTitleColor(whiteColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(codeAction(sender:)), for: .touchUpInside)
        btn.cornerRadius(radius:btn.height / 2)
        return btn
    }()
    
    private lazy var passwordTF: UITextField = {
        let tf = UITextField(frame: phoneTF.frame)
        tf.top = codeTF.bottom + spacing
        tf.placeholder = "请输入密码(长度在6-12之间)"
        tf.textColor = phoneTF.textColor
        tf.font = phoneTF.font
        tf.backgroundColor = whiteColor
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var verifyTF : UITextField = {
        let tf = UITextField(frame: passwordTF.frame)
        tf.top = passwordTF.bottom + spacing
        tf.placeholder = "请确认密码"
        tf.textColor = passwordTF.textColor
        tf.font = passwordTF.font
        tf.backgroundColor = passwordTF.backgroundColor
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var protocolBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = whiteColor
        btn.frame = CGRect(x: verifyTF.left, y: verifyTF.bottom + 8, width: verifyTF.width, height: verifyTF.height - 10)
        
        let imageV = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
        imageV.image = UIImage.svgImageNamed(name: "icon_register_protocol", size: imageV.size)
        imageV.centerY = btn.height/2
        imageV.backgroundColor = whiteColor
        btn.addSubview(imageV)
        
        let label = UILabel(frame: CGRect(x: imageV.right + 10, y: 0, width: btn.width - imageV.right - 10, height: btn.height))
        label.centerY = imageV.centerY
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = whiteColor
        label.textColor = colorRGBA(red: 200, green: 200, blue: 200, alpha: 1)
        let str = NSMutableAttributedString(string: "注册即代表同意《用户注册协议》")
        str.addAttributes([NSAttributedString.Key.underlineStyle: 1], range: NSMakeRange(7, str.string.count - 7))
        str.addAttributes([NSAttributedString.Key.underlineColor: label.textColor], range: NSMakeRange(7, str.string.count - 7))
        label.attributedText = str
        btn.addSubview(label)
        
        btn.addTarget(self, action: #selector(protocolAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var registerBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = passwordTF.frame
        btn.height += 5
        btn.top = protocolBtn.bottom + 8
        btn.backgroundColor = themeColor
        btn.setTitle("注册", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.cornerRadius(radius: btn.height/2)
        btn.addTarget(self, action: #selector(registerAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configView() {
        configNaviView(title: "注册")
        view.addSubview(bgView)
        bgView.addSubview(phoneTF)
        bgView.addSubview(codeTF)
        bgView.addSubview(codeBtn)
        bgView.addSubview(passwordTF)
        bgView.addSubview(verifyTF)
        bgView.addSubview(protocolBtn)
        bgView.addSubview(registerBtn)
        configLines()
    }
    
    private func configLines() {
        let bottoms = [phoneTF.bottom,codeTF.bottom,passwordTF.bottom,verifyTF.bottom]
        for bottom in bottoms {
            let line = UIView(frame: CGRect(x: phoneTF.left, y: bottom + 4, width: phoneTF.width, height: 1))
            line.backgroundColor = colorRGBA(red: 230, green: 230, blue: 230, alpha: 1)
            bgView.addSubview(line)
        }
    }

    @objc private func codeAction(sender:UIButton) {
        sender.isEnabled = false
        guard !phoneTF.text!.isEmpty && phoneTF.text!.isPhoneNumber() else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            return
        }
        
        net_sendmsgAction(phone: phoneTF.text!, handle: {[weak self] (resp) in
            if resp?.error == 0 {
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                self?.codeBtnCountDown()
            }
        }) {
            sender.isEnabled = true
        }
    }
    
    @objc private func protocolAction(sender:UIButton) {
        let newVC = UserProtocolVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    @objc private func registerAction(sender:UIButton) {
        guard !phoneTF.text!.isEmpty && phoneTF.text!.isPhoneNumber() else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            return
        }
        
        guard !codeTF.text!.isEmpty else {
            SVProgressHUD.showError(withStatus: "请输入验证码")
            return
        }
        
        guard !passwordTF.text!.isEmpty && (6..<13).contains(passwordTF.text!.count) else {
            SVProgressHUD.showError(withStatus: passwordTF.placeholder)
            return
        }
        
        guard !verifyTF.text!.isEmpty && (6..<13).contains(verifyTF.text!.count) && verifyTF.text! == passwordTF.text! else {
            SVProgressHUD.showError(withStatus: "请重新确认密码")
            return
        }
        
        net_registerAction(mobile: phoneTF.text!, password:passwordTF.text! , password_two: verifyTF.text!, code: codeTF.text!) { model,resp in
            
        }
        
    }
    
    private func codeBtnCountDown() {
        codeBtn.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDowning), userInfo: nil, repeats: true)
    }
    
    @objc private func countDowning() {
        codeBtn.setTitle("重新发送(\(time))", for: .normal)
        
        if time <= 0 {
            if timer?.isValid != true {
                timer?.invalidate()
                timer = nil
            }
            codeBtn.setTitle("获取验证码", for: .normal)
            codeBtn.isEnabled = true
            return
        }
        time -= 1
    }
}
