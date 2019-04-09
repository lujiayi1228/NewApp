//
//  RechargeAlertView.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/9.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class RechargeAlertView: UIView , AlertAnimationViewProtocol{
    
    private enum PayStyle : Int{
        case zhifubao
        case weixin
    }
    
    private var payStyle = PayStyle.zhifubao {
        didSet {
            finishBtn.isSelected = payStyle == .weixin
            if finishBtn.isSelected {
                guard weixinArray.count == zhifubaoArray.count else {return}
                _ = payBtns.map{$0.setTitle(weixinArray[$0.tag].name, for: .normal)}
            }else {
                _ = payBtns.map{$0.setTitle("\(zhifubaoArray[$0.tag])元", for: .normal)}
            }
        }
    }
    
    private let zhifubaoArray = [19,99,599,999,
                                 1499,1999,2999,4999]
    
    private var weixinArray : [PaylistModel.proxy] = []
    
    private var payBtns : [UIButton] = []
    private var styleBtns : [UIButton] = []
    private var lastPayIndex = 0
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "充值"
        label.backgroundColor = clearColor
        label.textColor = blackColor
        label.textAlignment = .center
        
        let bottomLine = CALayer()
        bottomLine.backgroundColor = colorRGBA(red: 220, green: 220, blue: 220, alpha: 1).cgColor
        bottomLine.frame = CGRect(x: 0, y: label.height - 0.5, width: label.width, height: 0.5)
        label.layer.addSublayer(bottomLine)
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = clearColor
        btn.frame = CGRect(x: 0, y: 0, width: label.height, height: label.height)
        btn.right = label.width
        btn.setImage(UIImage(named: "icon_close"), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        label.addSubview(btn)
        
        return label
    }()
    
    private lazy var modeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16, y: height/2, width: width - 16*2, height: 30))
        label.backgroundColor = titleLabel.backgroundColor
        label.textColor = titleLabel.textColor
        label.text = "支付方式"
        label.font = titleLabel.font
        return label
    }()
    
    private lazy var finishBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: width - modeLabel.left * 2, height: titleLabel.height)
        btn.cornerRadius(radius: 5)
        btn.centerX = width/2
        btn.bottom = height - 16
        btn.backgroundColor = themeColor
        btn.setTitleColor(whiteColor, for: .normal)
        btn.setTitleColor(whiteColor, for: .selected)
        btn.setTitle("确认购买", for: .normal)
        btn.setTitle("联系代理充值", for: .selected)
        btn.titleLabel?.font = titleLabel.font
        btn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        backgroundColor = whiteColor
        frame = CGRect(x: 0, y: screenHeight, width: screenWidth, height: (phoneBottom - phoneTop) / 2)
        addSubview(titleLabel)
        addSubview(modeLabel)
        addSubview(finishBtn)
        createPayBtns()
        createStyleBtns()
        getList()
    }
    
    private func createPayBtns() {
        let spacing : CGFloat = 8
        let btnWidth = (width - 16 * 2 - spacing * 3) / 4
        let btnHeight = (modeLabel.top - titleLabel.bottom - 16 * 3) / 2
        
        for (index,price) in zhifubaoArray.enumerated() {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 16 + (btnWidth + spacing) * CGFloat(index%4), y:titleLabel.bottom + 16 + (btnHeight + 16)*CGFloat(Int(index/4)), width: btnWidth, height: btnHeight)
            btn.backgroundColor = clearColor
            btn.setBackgroundImage(UIImage(named: "pay_payIcon_selected"), for: .selected)
            btn.setBackgroundImage(UIImage(named: "pay_payIcon_normal"), for: .normal)
            btn.setTitle("\(price)元", for: .normal)
            btn.setTitleColor(colorRGBA(red: 151, green: 151, blue: 151, alpha: 1), for: .normal)
            btn.setTitleColor(whiteColor, for: .selected)
            btn.tag = index
            btn.isSelected = index == 0
            btn.addTarget(self, action: #selector(selectedItem(sender:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            addSubview(btn)
            payBtns.append(btn)
        }
    }
    
    private func createStyleBtns() {
        let btnWidth : CGFloat = 80
        let btnHeight = payBtns.first!.height
        let itmes = [(UIImage(named: "pay_zhifubaoicon"),UIImage(named: "pay_zhifubaoicon_selected"),"支付宝"),
                     (UIImage(named: "pay_weixinicon"),UIImage(named: "pay_weixinicon_selected"),"官方代理")]
        for (index,item) in itmes.enumerated() {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: modeLabel.left + (modeLabel.left + btnWidth) * CGFloat(index), y: 0, width: btnWidth, height: btnHeight)
            btn.centerY = modeLabel.bottom + (finishBtn.top - modeLabel.bottom) / 2
            btn.setBackgroundImage(UIImage(named: "pay_payIcon_selected"), for: .selected)
            btn.setBackgroundImage(UIImage(named: "pay_payIcon_normal"), for: .normal)
            btn.setTitleColor(colorRGBA(red: 151, green: 151, blue: 151, alpha: 1), for: .normal)
            btn.setTitleColor(whiteColor, for: .selected)
            btn.addTarget(self, action: #selector(changeStyle(sender:)), for: .touchUpInside)
            btn.tag = index
            btn.isSelected = index == 0
            btn.setTitle(item.2, for: .normal)
            btn.setImage(item.0, for: .normal)
            btn.setImage(item.1, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            addSubview(btn)
            styleBtns.append(btn)
        }
    }
    
    @objc private func closeAction() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseCustomAlertVC"), object: nil)
    }
    
    @objc private func finishAction() {
        switch payStyle {
        case .weixin:
            proxyAction(index: lastPayIndex)
        case .zhifubao:
            rechargeAction(index: lastPayIndex)
        }
    }
    
    @objc private func selectedItem(sender:UIButton) {
        guard sender.tag != lastPayIndex else {
            return
        }
        sender.isSelected = true
        payBtns[lastPayIndex].isSelected = false
        lastPayIndex = sender.tag
    }
    
    @objc private func changeStyle(sender:UIButton) {
        guard sender.tag != payStyle.rawValue else {
            return
        }
        payStyle = RechargeAlertView.PayStyle(rawValue: sender.tag)!
        sender.isSelected = true
        styleBtns[1-sender.tag].isSelected = false
    }
    
    private func rechargeAction(index:Int) {
        net_getPayurl(price: zhifubaoArray[index]) {[weak self] in
            
        }
    }
    
    private func proxyAction(index:Int) {
        
    }
    
    private func getList() {
        net_getPaylist {[weak self] (model, response) in
            if model?.msg?.list != nil {
                self!.weixinArray = model!.msg!.list
            }
        }
    }
    
    func showAnimation() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self!.bottom = screenHeight
        }
    }
    
    func dismissAnimation(finish: @escaping (() -> ())) {
        UIView.animate(withDuration: 0.2, animations: {[weak self] in
            self!.top = screenHeight
        }) {(finished) in
            if finished {
                finish()
            }
        }
    }
}
