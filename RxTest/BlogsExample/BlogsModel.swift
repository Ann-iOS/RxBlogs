//
//  BlogsModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/17.
//

import Foundation
import ObjectMapper
import RxDataSources

struct BaseBlogsModel: Mappable {
    var height : String?
    var result : [blogModel]?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        height <- map["height"]
        result <- map["result"]
    }
    
}

class blogModel: Mappable {
    var id: String = ""
    var created_by: String = ""
    var created_at: String = ""
    var title:String = ""
    var body: String = ""
    var name: String?
    var imgUrl: String?
    var readNumber: Int?
    
    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        created_by <- map["created_by"]
        created_at <- map["created_at"]
        title <- map["title"]
        body <- map["body"]
        name <- map["name"]
        imgUrl <- map["imgUrl"]
        readNumber <- map["readNumber"]
    }
}




struct BaseUserModel: Mappable {
    var height : String?
    var result : [userModel]?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        height <- map["height"]
        result <- map["result"]
    }
}

struct userModel: Mappable {
    var id: String = ""
    var created_by: String = ""
    var created_at: String = ""
    /// 昵称
    var name:String = ""
    /// 年龄
    var age: String = ""
    /// 库链地址
    var dbchain_key: String = ""
    /// 性别
    var sex: String = ""
    /// 账号是否可用
    var status: String = ""
    /// 头像
    var photo: String = ""
    /// 座右铭
    var motto: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        created_by <- map["created_by"]
        created_at <- map["created_at"]
        name <- map["name"]
        age <- map["age"]
        dbchain_key <- map["dbchain_key"]
        sex <- map["sex"]
        status <- map["status"]
        photo <- map["photo"]
        motto <- map["motto"]
    }
}











//
//extension BaseBlogsModel: SectionModelType {
//
//    init(original: BaseBlogsModel, items: [blogModel]) {
//        self = original
//        self.result = items
//    }
//
//    typealias Item = blogModel
//    var items: [blogModel] {
//        return result!
//    }
//}
