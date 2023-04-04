//
//  DataModel.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/20.
//

import UIKit
import RealmSwift

// Realm -> Value Object class
class DiaryData: Object {
    // @objc dynamic: 변수 값이 바뀔 때 Realm + DB에 알려줌
    @objc dynamic var date: String = ""
    @objc dynamic var review: String = ""
    @objc dynamic var emotion: String = "Neutral"
    @objc dynamic var photo: Data? = nil
}
