//
//  User.swift
//  RxTest
//
//  Created by iOS on 2021/12/16.
//

//  User.swift
import ObjectMapper

class User: Mappable {
    required init?(map: Map) {}

    func mapping(map: Map) {
        userId <- map["userId"]
        name <- map["name"]
        age <- map["age"]
    }

    var userId:Int = 0
    var name:String = ""
    var age:Int = 0
}
