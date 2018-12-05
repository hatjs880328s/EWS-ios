//
//  PKCS12.swift
//  EWS-For-iOS
//
//  Created by Noah_Shan on 2018/12/5.
//  Copyright © 2018 wangxk. All rights reserved.
//

import UIKit

class PKCS128: NSObject {
    @objc func getNmae() {
//        var name = PKCS12()
//        //name.getPublicKey()
//        name.signTheDataSHA1(withRSA: "hehe")

        let data = Bundle.main.path(forResource: "shanwzh", ofType: "pfx")
        let realData = try! Data(contentsOf: URL(fileURLWithPath: data!))
        print(String(data: realData as! Data, encoding: String.Encoding.utf8))
    }
}
