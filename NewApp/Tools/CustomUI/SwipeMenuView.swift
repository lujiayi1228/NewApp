//
//  SwipeMenuView.swift
//  KuWen
//
//  Created by weijieMac on 2019/1/8.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

@objc protocol SwipeMenuViewDelegate : NSObjectProtocol{
    @objc func SwipMenuViewDidSelected(currentIndex:Int,lastIndex:Int)
}

@objc fileprivate protocol SwipeMenuTabViewDelegate : NSObjectProtocol{
    @objc func SwipeMenuTabDidSelected(index:Int)
}

class SwipeMenuView: UIScrollView {

    private var contents : [String] = []
    
    weak var viewDelegate : SwipeMenuViewDelegate?
    
    private var tabView : SwipeMenuTabView?
    
    private var currentIndex = 0
    
    init(frame: CGRect, contents:[String], tabSize:CGSize, tabNeedScroll:Bool) {
        super.init(frame: frame)
        self.contents = contents
        configView()
        createTabView(size: tabSize,tabNeedScroll: tabNeedScroll)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        isPagingEnabled = true
        bounces = false
        contentSize = CGSize(width: self.width*CGFloat(self.contents.count), height: self.height)
        delegate = self
        backgroundColor = whiteColor
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isScrollEnabled = true
        isPagingEnabled = true
    }
    
    private func createTabView(size:CGSize,tabNeedScroll:Bool) {
        tabView = SwipeMenuTabView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), titles: contents, needScroll: tabNeedScroll)
        tabView?.centerX = self.centerX
        tabView?.delegate = self
        addSubview(tabView!)
    }
    
    func updateSelectedTab(index:Int) {
        tabView?.selectedNewBtn(index: index)
    }
}

extension SwipeMenuView : UIScrollViewDelegate,SwipeMenuTabViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(self.contentOffset.x / self.width)
        guard currentIndex != index else {
            return
        }
        if viewDelegate != nil {
            viewDelegate?.SwipMenuViewDidSelected(currentIndex: index, lastIndex: currentIndex)
        }
        tabView?.selectedNewBtn(index: index)
        currentIndex = index
    }
    
    func SwipeMenuTabDidSelected(index: Int) {
        if viewDelegate != nil {
            viewDelegate?.SwipMenuViewDidSelected(currentIndex: index, lastIndex: currentIndex)
        }
    }
}

fileprivate class SwipeMenuTabView: UIView {
    
    private var titles : [String] = []
    
    private var buttons : [UIButton] = []
    
    private var currentIndex = 0
    
    private var needScroll = false
    
    private lazy var bottomLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 2))
        view.backgroundColor = themeColor
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    weak var delegate : SwipeMenuTabViewDelegate?
    
    init(frame:CGRect ,titles:[String], needScroll:Bool) {
        super.init(frame:frame)
        self.titles = titles
        self.needScroll = needScroll
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        self.backgroundColor = clearColor
        scrollView.frame = self.bounds
        self.addSubview(scrollView)
        scrollView.isScrollEnabled = false
        
        let btnWidth = self.width/CGFloat(titles.count)

        for index in 0..<titles.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: CGFloat(index)*btnWidth, y: 0, width: btnWidth, height: self.height)
            button.setTitle(titles[index], for: .normal)
            button.tag = index
            button.backgroundColor = clearColor
            button.setTitleColor(colorStr(color: "#787878"), for: .normal)
            button.setTitleColor(blackColor, for: .selected)
            button.isSelected = index == 0
            button.titleLabel?.font = UIFont.systemFont(ofSize: needScroll ? 15 : 17)
            
            scrollView.addSubview(button)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        bottomLine.centerX = buttons.first!.centerX
        bottomLine.bottom = buttons.first!.bottom
        scrollView.addSubview(bottomLine)
    }
    
    @objc private func buttonAction(sender:UIButton) {
        updateButtons(index: sender.tag)
        if delegate != nil {
            delegate!.SwipeMenuTabDidSelected(index: sender.tag)
        }
    }
    
    fileprivate func selectedNewBtn(index:Int) {
        updateButtons(index: index)
    }
    
    private func updateButtons(index:Int) {
        guard currentIndex != index else {return}
        for btn in buttons {
            btn.isSelected = btn.tag == index ? true : false
        }
        currentIndex = index
        UIView.animate(withDuration: 0.3) {[weak self] in
            self!.bottomLine.centerX = self!.buttons[index].centerX
        }
    }
}
