//
//  HomeMainVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/3.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class HomeMainVC: RootVC {
    
    private let menuVCs = ["HomeConvertVC","HomeRedenvelopeVC","HomeInviteVC"]
    
    private lazy var titleImageV: UIImageView = {
        let imagev = UIImageView(frame: CGRect(x: 0, y: 0, width: 200 * 3 / 5, height: 46 * 3 / 5))
        imagev.center = textLabel!.center
        imagev.image = UIImage(named: "home_titlelogo")
        imagev.backgroundColor = clearColor
        return imagev
    }()
    
    private lazy var tableView: UITableView = {
        let tab = UITableView(frame: CGRect(x: 0, y: naviView!.bottom, width: view.width, height: screenHeight - naviView!.bottom - tabbarHeight), style: .plain)
        tab.delegate = self
        tab.dataSource = self
        tab.tableHeaderView = headerView
        return tab
    }()
    
    private lazy var headerView: HomeListHeaderView = {
        let view = HomeListHeaderView(frame: CGRect(x: 0, y: naviView!.bottom, width: self.view.width, height: screenHeight - naviView!.bottom - tabbarHeight))
        view.countDownFinishHandle = ({ [weak self] in
            self!.getLottery()
        })
        view.getResultHandle = ({[weak self] in
            self!.getLastlottery()
        })
        view.showRuleHandle = ({[weak self] in
            self!.showUserRule()
        })
        view.menuClicekedHandle = ({ [weak self] index in
            self!.menuClicked(index: index)
        })
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func configView() {
        configNewNaviView()
        view.addSubview(tableView)
    }
    
    private func configNewNaviView() {
        configNaviView(title: nil)
        leftBtn?.isHidden = true
        rightBtn?.isHidden = true
        naviView?.addSubview(titleImageV)
    }
    
    private func getData() {
        getLastlottery()
    }
    
    private func getLastlottery() {
        net_getLastlottery {[weak self] (model, resp) in
            if model?.error == 0 {
                self!.headerView.refreshCountDown(data:model!)
            }
        }
    }
    
    private func getLottery() {
        net_getLottery {[weak self] (model, resp) in
            if model?.msg?.kaijiang == 1 {
                self!.headerView.refreshLottery(data: model!)
            }
        }
    }
    
    private func showUserRule() {
        let newVC = HomeUserRulesVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    private func menuClicked(index:Int) {
        guard checkLogin() else {
            return
        }
        switch index {
        case 0:
            let payView = RechargeAlertView()
            let alertVC = CustomAlertVC(contentType: .animation(payView))
            alertVC.show()
        default:
            gotoNewVC(index: index - 1)
        }
    }
    
    private func gotoNewVC(index:Int) {
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"]
        guard let ns = nameSpace as? String else{
            return
        }
        let myClass: AnyClass? = NSClassFromString(ns + "." + menuVCs[index])
        guard let viewControllerClass = myClass as? UIViewController.Type else{
            return
        }
        let newVC = viewControllerClass.init()
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension HomeMainVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
