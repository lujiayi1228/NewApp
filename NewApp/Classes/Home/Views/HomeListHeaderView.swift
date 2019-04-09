//
//  HomeListHeaderView.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/7.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import FSPagerView

class HomeListHeaderView: UIView {
    
    var countDownFinishHandle : (()->())?
    var getResultHandle : (()->())?
    var showRuleHandle : (()->())?
    var menuClicekedHandle : ((Int)->())?
    
    private let textColor = colorRGBA(red: 160, green: 160, blue: 160, alpha: 1)
    private var timer : Timer?
    private var time = 0
    private var lotteryList : [HomeLotteryModel.Result] = []
    private var lastLottery = ""
    private var kaijiangNum = ""
    
    private let unitHeight = (screenHeight - naviHeight - 40 - tabbarHeight)/8 //40为中间20、50、100选项高度
    private let topBannerImages = [UIImage(named: "banner1"),
                                   UIImage(named: "banner2"),
                                   UIImage(named: "banner3")]
    
    private let cardBannerDatas = [(UIImage(named: "icon_money_20"),"12.00元"),
                                   (UIImage(named: "icon_money_50"),"30.00元"),
                                   (UIImage(named: "icon_money_100"),"60.00元")]
    
    private let menuDatas = [(UIImage(named: "充值"),"充值"),
                             (UIImage(named: "duihuan"),"兑换"),
                             (UIImage(named: "qianghongbao"),"抢红包"),
                             (UIImage(named: "邀请"),"邀请")]
    
    private lazy var topBanner: FSPagerView = {
        let view = FSPagerView(frame: CGRect(x: 0, y: 0, width: width, height: unitHeight + realValue_H(value: 40)))
        view.automaticSlidingInterval = 4.0
        view.isInfinite = true
        view.delegate = self
        view.dataSource = self
        view.decelerationDistance = 2
        view.register(HomeBannerCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    private lazy var topBannerControl: FSPageControl = {
        let view = FSPageControl(frame: CGRect(x: 0, y: 0, width: topBanner.width, height: 15))
        view.bottom = topBanner.bottom - realValue_H(value: 24)
        view.numberOfPages = topBannerImages.count
        view.contentHorizontalAlignment = .center
        view.backgroundColor = clearColor
        view.currentPage = 0
        return view
    }()
    
    private lazy var placard: UILabel = {
        let placard = UILabel(frame: CGRect(x: 8 + 16 * 2, y: 0, width: width, height: unitHeight - realValue_H(value: 56)))
        placard.bottom = lotteryBgView.top
        placard.font = UIFont.systemFont(ofSize: 12)
        placard.text = "最公正、透明的二人抢购平台!每5分钟开奖一次!"
        placard.backgroundColor = whiteColor
        
        let imageV = UIImageView(frame: CGRect(x: 16, y: 0, width: 16, height: 16))
        imageV.centerY = placard.centerY
        imageV.image = UIImage(named: "icon_voice")
        imageV.contentMode = .scaleAspectFit
        addSubview(imageV)
        
        return placard
    }()
    
    private lazy var lotteryBgView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: unitHeight - realValue_H(value: 20)))
        view.bottom = unitHeight * 4
        view.backgroundColor = colorRGBA(red: 237, green: 237, blue: 242, alpha: 1)
        return view
    }()
    
    private lazy var lastLotteryLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: lotteryBgView.width, height: lotteryBgView.height/2))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = clearColor
        label.textColor = textColor
        return label
    }()
    
    private lazy var lotteryResultLabel: LotteryResultLabel = {
        let label = LotteryResultLabel(frame: lastLotteryLabel.frame)
        label.bottom = lotteryBgView.height
        label.backgroundColor = clearColor
        return label
    }()
    
    private lazy var cardTabView: SwipeMenuView = {
        let view = SwipeMenuView(frame: CGRect(x: 0, y: lotteryBgView.bottom, width: width, height: 40), contents: ["20元","50元","100元"], tabSize: CGSize(width: width, height: 40), tabNeedScroll: false)
        view.viewDelegate = self
        return view
    }()
    
    private lazy var cardBanner: FSPagerView = {
        let pagerView = FSPagerView(frame: CGRect(x: 16, y: cardTabView.bottom + 8, width: screenWidth - 16 * 2, height:unitHeight * 1.5))
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.itemSize = CGSize(width: pagerView.height/5*8, height: pagerView.height)
        pagerView.register(HomeCardCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.automaticSlidingInterval = 4.0
        pagerView.isInfinite = true
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.transformer?.minimumScale = 0.8
        return pagerView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: cardBanner.left, y: cardBanner.bottom + realValue_H(value: 16), width: cardBanner.width, height: realValue_H(value: 40)))
        label.backgroundColor = whiteColor
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var detailBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: cardBanner.left, y: priceLabel.bottom + realValue_H(value: 16), width: cardBanner.width, height: unitHeight - realValue_H(value: 8) - priceLabel.height))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.numberOfLines = 2
        
        let str = "抢购规则：根据当期开奖号码的最后四位数字之和。为单数则为“买 单”抢购成功，反之则“买双”抢购成功 详细说明>>>"
        let attstr = NSMutableAttributedString(string: str)
        attstr.addAttributes([NSAttributedString.Key.foregroundColor:priceLabel.textColor], range: NSRange(location: 0, length: str.count))
        attstr.addAttributes([NSAttributedString.Key.foregroundColor:themeColor], range: NSRange(location: str.count - 7, length: 7))
        btn.setAttributedTitle(attstr, for: .normal)
        btn.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        return btn
    }()
    
    private lazy var countDownTagLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: detailBtn.bottom + realValue_H(value: 20), width: (width - 16 * 2)/3, height: (unitHeight - 16)/2))
        label.centerX = detailBtn.centerX
        label.textAlignment = .center
        label.textColor = blackColor
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var countDownLabel: MZTimerLabel = {
        let label = MZTimerLabel(frame: countDownTagLabel.frame)
        label.top = countDownTagLabel.bottom
        label.textAlignment = .center
        label.textColor = themeColor
        label.font = countDownTagLabel.font
        label.timeFormat = "mm:ss:SSS"
        label.timerType = MZTimerLabelTypeTimer
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        addSubview(topBanner)
        addSubview(topBannerControl)
        createMenu()
        addSubview(placard)
        addSubview(lotteryBgView)
        lotteryBgView.addSubview(lastLotteryLabel)
        lotteryBgView.addSubview(lotteryResultLabel)
        addSubview(cardTabView)
        addSubview(cardBanner)
        addSubview(priceLabel)
        addSubview(detailBtn)
        addSubview(countDownTagLabel)
        addSubview(countDownLabel)
        createBuyBtns()
        createBottomLine()
    }
    
    private func createMenu() {
        let btnWidth = (width - 16 * 2)/4
        for (index,item) in menuDatas.enumerated() {
            let btn = CustomButton(type: .custom)
            btn.frame = CGRect(x: 16 + btnWidth * CGFloat(index), y: topBanner.bottom, width: btnWidth, height: unitHeight )
            btn.centerY = topBanner.bottom + (placard.top - topBanner.bottom) / 2
            btn.backgroundColor = whiteColor
            btn.layout = .normalTopBottom
            btn.setImage(item.0, for: .normal)
            btn.setTitle(item.1, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.setTitleColor(blackColor, for: .normal)
            btn.tag = index
            btn.addTarget(self, action: #selector(menuAction(sender:)), for: .touchUpInside)
            addSubview(btn)
        }
    }
    
    private func createBuyBtns() {
        let single = UIButton(type: .custom)
        single.frame = CGRect(x: 16, y: countDownTagLabel.top + realValue_H(value: 8) , width: (screenWidth - 16*2)/3, height: countDownLabel.bottom - countDownTagLabel.top - realValue_H(value: 16))
        single.backgroundColor = colorRGBA(red: 252, green: 84, blue: 87, alpha: 1)
        single.cornerRadius(radius: 5)
        single.addTarget(self, action: #selector(buyAction(sender:)), for: .touchUpInside)
        single.tag = 0
        single.setTitle("买单", for: .normal)
        single.setTitleColor(whiteColor, for: .normal)
        
        let double = UIButton(type: .custom)
        double.frame = single.frame
        double.right = width - 16
        double.backgroundColor = colorRGBA(red: 86, green: 165, blue: 252, alpha: 1)
        double.cornerRadius(radius: 5)
        double.addTarget(self, action: #selector(buyAction(sender:)), for: .touchUpInside)
        double.tag = 1
        double.setTitle("买双", for: .normal)
        double.setTitleColor(whiteColor, for: .normal)
        
        addSubview(single)
        addSubview(double)
    }
    
    private func createBottomLine() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 8))
        view.bottom = height
        view.backgroundColor = colorRGBA(red: 220, green: 220, blue: 220, alpha: 1)
        addSubview(view)
    }
    
    @objc private func menuAction(sender:UIButton) {
        if menuClicekedHandle != nil {
            menuClicekedHandle!(sender.tag)
        }
    }
    
    @objc private func buyAction(sender:UIButton) {
        
    }
    
    @objc private func showDetail() {
        if showRuleHandle != nil {
            showRuleHandle!()
        }
    }
    
    func refreshCountDown(data:HomeLastlotteryModel) {
        if countDownLabel.counting {
            countDownLabel.pause()
        }
        let date = Double(Date().milliStamp)
        let time = Double(Double(data.msg!.targettime) - date) / 1000
        countDownLabel.setCountDownTime(time)
        lastLottery = data.msg!.result!
        countDownTagLabel.text = data.msg!.targetnum! + "期投注倒计时"
        countDownLabel.start {[weak self] (time) in
            if self!.countDownFinishHandle != nil {
                self!.countDownFinishHandle!()
            }
        }
        lastLotteryLabel.text = "上期开奖期号 : \(data.msg!.num)"
        lastLotteryLabel.isHidden = false
        lotteryResultLabel.isHalf = true
        lotteryResultLabel.top = lastLotteryLabel.bottom
        
        let dataa = HomeLotteryModel.Result(left: data.msg!.result, right: "", odd_name:(data.msg!.isodd == "1" ? "单" : "双"), result_he: data.msg!.result_he)
        lotteryResultLabel.refresh(num: "", data: dataa)

    }
    
    func refreshLottery(data:HomeLotteryModel) {
        lotteryList = data.msg!.list!
        lastLotteryLabel.isHidden = true
        lotteryResultLabel.height = lotteryBgView.height
        lotteryResultLabel.isHalf = false
        lotteryResultLabel.top = 0
        kaijiangNum = data.msg!.kaijiangnum!
        time = data.msg!.sec / 1000 * 10
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changeResult), userInfo: nil, repeats: true)
    }
    
    @objc private func changeResult() {
        guard time > 0 else {
            if timer?.isValid == true {
                timer?.invalidate()
                timer = nil
                if getResultHandle != nil {
                    getResultHandle!()
                }
            }
            lastLotteryLabel.isHidden = false
            lotteryResultLabel.isHalf = true
            lotteryResultLabel.top = lastLotteryLabel.bottom
            return
        }
        let data = lotteryList[time % lotteryList.count]
        lotteryResultLabel.refresh(num: kaijiangNum, data: data)
        time -= 1
    }
}

extension HomeListHeaderView : SwipeMenuViewDelegate , FSPagerViewDelegate, FSPagerViewDataSource{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if pagerView == topBanner {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! HomeBannerCell
            cell.imageView?.image = topBannerImages[index]
            return cell
        }else {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! HomeCardCell
            cell.imageView?.image = cardBannerDatas[index].0
            return cell
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        if pagerView == topBanner {
            topBannerControl.currentPage = pagerView.currentIndex
        }else {
            cardTabView.updateSelectedTab(index: pagerView.currentIndex)
            priceLabel.text = "抢购价:" + cardBannerDatas[pagerView.currentIndex].1
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let cell = pagerView.cellForItem(at: index)
        cell?.isSelected = false
        pagerView.deselectItem(at: index, animated: false)
    }
    
    func SwipMenuViewDidSelected(currentIndex: Int, lastIndex: Int) {
        cardBanner.selectItem(at: currentIndex, animated: true)
    }

}


fileprivate class HomeBannerCell: FSPagerViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowColor = clearColor.cgColor
        imageView?.frame = CGRect(x: realValue_W(value: 70), y: 12, width: width - realValue_W(value: 140), height: height - 24)
    }
    
}

fileprivate class HomeCardCell : FSPagerViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowColor = clearColor.cgColor
        isHighlighted = false
    }
}

fileprivate class LotteryResultLabel : UIView {
    
    var isHalf : Bool = true {
        didSet {
            if isHalf {
                height = halfHeight
            }else {
                height = halfHeight * 2
            }
            contentView.centerY = height/2
            firstLabel.centerY = contentView.height/2
            secondLabel.centerY = contentView.height/2
            thirdLabel.centerY = contentView.height/2
            forthLabel.centerY = contentView.height/2
            lastLabel.centerY = contentView.height/2
            flag = true
        }
    }
    
    private var flag = false
    
    private var halfHeight : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        halfHeight = frame.height
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        addSubview(contentView)
        contentView.addSubview(firstLabel)
        contentView.addSubview(secondLabel)
        contentView.addSubview(thirdLabel)
        contentView.addSubview(forthLabel)
        contentView.addSubview(lastLabel)
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.height = height
        view.backgroundColor = clearColor
        return view
    }()
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.height = height
        label.backgroundColor = contentView.backgroundColor
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        label.textColor = colorRGBA(red: 160, green: 160, blue: 160, alpha: 1)
        return label
    }()
    
    private lazy var secondLabel : UILabel = {
        let label = UILabel()
        label.height = height
        label.backgroundColor = firstLabel.backgroundColor
        label.textColor = themeColor
        label.font = firstLabel.font
        label.textAlignment = .center
        return label
    }()
    
    private lazy var thirdLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        label.backgroundColor = themeColor
        label.font = secondLabel.font
        label.textColor = whiteColor
        label.cornerRadius(radius: 3)
        label.textAlignment = .center
        return label
    }()

    private lazy var forthLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        label.width = 35
        label.backgroundColor = thirdLabel.backgroundColor
        label.font = thirdLabel.font
        label.textColor = thirdLabel.textColor
        label.cornerRadius(radius: 3)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lastLabel: UILabel = {
        let label = UILabel()
        label.height = height
        label.backgroundColor = contentView.backgroundColor
        label.textColor = firstLabel.textColor
        label.text = "成功夺宝"
        label.font = firstLabel.font
        return label
    }()
    
    func refresh(num:String,data:HomeLotteryModel.Result) {
        if flag {
            secondLabel.width = labelAutoWidth(content: data.left!, font: secondLabel.font, height: secondLabel.height) + 4
            firstLabel.width = (width - secondLabel.width - thirdLabel.width * 2 - 4 - 8)/2
            lastLabel.width = firstLabel.width
            secondLabel.left = firstLabel.right + 4
            thirdLabel.left = secondLabel.right
            forthLabel.left = thirdLabel.right + 4
            lastLabel.right = width
            if isHalf {
                contentView.width = width
                contentView.left = 0
            }else {
                lastLabel.width = 0
                contentView.width = forthLabel.right
                contentView.centerX = width/2
            }
            flag = false
        }
        firstLabel.text = isHalf ? "开奖结果" : num + "期开奖中:"
        secondLabel.text = data.left
        thirdLabel.text = "\(data.result_he)"
        forthLabel.text = data.odd_name
    }
}
