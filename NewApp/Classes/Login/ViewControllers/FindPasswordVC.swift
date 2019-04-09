//
//  FindPasswordVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/7.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class FindPasswordVC: RootVC {
    
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
    
    private lazy var nextBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = phoneTF.frame
        btn.height += 5
        btn.top = codeTF.bottom + spacing
        btn.backgroundColor = themeColor
        btn.setTitle("下一步", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.cornerRadius(radius: btn.height/2)
        btn.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configView() {
        configNaviView(title: "找回密码")
        view.addSubview(bgView)
        bgView.addSubview(phoneTF)
        bgView.addSubview(codeTF)
        bgView.addSubview(codeBtn)
        bgView.addSubview(nextBtn)
        configLines()
    }
    
    private func configLines() {
        let bottoms = [phoneTF.bottom,codeTF.bottom]
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
    
    @objc private func nextAction(sender:UIButton) {
        guard !phoneTF.text!.isEmpty && phoneTF.text!.isPhoneNumber() else {
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
            return
        }
        
        guard !codeTF.text!.isEmpty else {
            SVProgressHUD.showError(withStatus: "请输入正确的验证码")
            return
        }
        
        //TODO:下一步
        let newVC = ResetPasswordVC()
        navigationController?.pushViewController(newVC, animated: true)
        
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
