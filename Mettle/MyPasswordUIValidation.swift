//
//  MyPasswordUIValidation.swift
//  Mettle
//
//  Created by Peter Huffman on 5/21/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit
import SmileLock

class MyPasswordModel {
    class func match(_ password: String) -> MyPasswordModel? {
        guard password == "123456" else { return nil }
        return MyPasswordModel()
    }
}

class MyPasswordUIValidation: PasswordUIValidation<MyPasswordModel> {
    init(in stackView: UIStackView) {
        super.init(in: stackView, digit: 6)
        validation = { password in
            MyPasswordModel.match(password)
        }
    }
    
    //handle Touch ID
    override func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            let dummyModel = MyPasswordModel()
            self.success?(dummyModel)
        } else {
            passwordContainerView.clearInput()
        }
    }
}
