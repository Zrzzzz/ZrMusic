//
//  nameTF.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/24.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit

class TF: UITextField {
    static let nameTF: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    static let passwordTF: UITextField = {
        let tf = UITextField()
        tf.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        tf.clearButtonMode = .whileEditing
        tf.isSecureTextEntry = true
        return tf
    }()
    


}
