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
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var tableView: UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
//        初始化tableView
        setupTV()
        
        
        
    }
}

extension Accounter {
    func setupTV() {
        tableView = UITableView(frame: CGRect(x: 0, y: 70, width: width, height: height - 70), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension Accounter: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            return 80
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = nicknameCell()
            
        default:
            <#code#>
        }
        
        
        
        
        return cell
    }
}
