//
//  UserInfo.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 3. 14..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
import GoogleSignIn

class UserInfo: Object{
    @objc dynamic var id: Int = 0                                                           //Primary Key
    @objc dynamic var email: String = Auth.auth().currentUser?.email ?? "NoEmail"
    @objc dynamic var nickname: String = Auth.auth().currentUser?.displayName ?? "Noname"   //Not Null
    @objc dynamic var image: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "humanSample.png"))!
    @objc dynamic var address: String?
    @objc dynamic var cowork: Bool = false                                                  //default: false
    @objc dynamic var job: String = ""
    @objc dynamic var introducing: String?
    @objc dynamic var purpose: String?
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(UserInfo.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

func addUser(_ address: String?, _ job: String){
    let realm = try! Realm()
    let object = UserInfo()
    object.id = object.incrementID()
    object.address = address
    object.job = job
    try! realm.write{
        realm.add(object)
    }
}

// 로그인 완료 직후 addUser 메소드 불러서 유저 정보 저장
//