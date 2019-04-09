//
//  UserMainVC.swift
//  NewApp
//
//  Created by weijieMac on 2019/4/3.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class UserMainVC: RootVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newVC = LoginMainVC()
        navigationController?.pushViewController(newVC, animated: true)
    }
    
}
