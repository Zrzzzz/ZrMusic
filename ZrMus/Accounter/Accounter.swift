//
//  Accounter.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/21.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class Accounter: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkBtn = UIButton()
        view.addSubview(checkBtn)
        checkBtn.backgroundColor = .black
        checkBtn.setTitle("登录", for: .normal)

        checkBtn.snp.updateConstraints { (m) in
            m.width.height.equalTo(50)
            m.center.equalToSuperview()
        }
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
