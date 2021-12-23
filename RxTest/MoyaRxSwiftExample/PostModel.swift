//
//  PostModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import ObjectMapper

struct BaseModel<T: Codable>: Codable {
    let data : T?
    let errorCode : Int?
    let errorMsg : String?
}

extension BaseModel {
    /// 请求是否成功
    var isSuccess: Bool {  errorCode == 0 }

}



struct Post: Mappable {
    var id: Int?
    var title: String?
    var body: String?
    var userId: String?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
        userId <- map["userId"]
    }
}

//
//class Post: Mappable {
//    var id: Int?
//    var title: String?
//    var body: String?
//    var userId: String?
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        id <- map["id"]
//        title <- map["title"]
//        body <- map["body"]
//        userId <- map["userId"]
//    }
//}
