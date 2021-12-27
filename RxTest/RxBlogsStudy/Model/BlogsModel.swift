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

struct BaseDiscussModel: Mappable {
    var height : String?
    var result : [discussModel]?
    init?(map: Map) { }

    mutating func mapping(map: Map) {
        height <- map["height"]
        result <- map["result"]
    }
}

struct discussModel: Mappable {
    var id: String = ""
    var created_by: String = ""
    var created_at: String = ""
    /// 文章id
    var blog_id:String = ""
    /// 评论id
    var discuss_id: String = ""
    /// 评论内容
    var text: String = ""
    /// 自定义类型.  头像
    var imageIndex: String = ""
    var nickName: String = ""

    var replyModelArr :[replyDiscussModel] = []
    /// 回复人的昵称
    var replyNickName: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id <- map["id"]
        created_by <- map["created_by"]
        created_at <- map["created_at"]
        blog_id <- map["blog_id"]
        discuss_id <- map["discuss_id"]
        text <- map["text"]
        imageIndex <- map["imageIndex"]
        nickName <- map["nickName"]
        replyModelArr <- map["replyModelArr"]
        replyNickName <- map["replyNickName"]
    }
}

//struct replyDiscussModel: Mappable {
//
//    var id: String = ""
//    var created_by: String = ""
//    var created_at: String = ""
//    /// 文章id
//    var blog_id:String = ""
//    /// 评论id
//    var discuss_id: String = ""
//    /// 评论内容
//    var text: String = ""
//    /// 自定义类型.  头像
//    var imageIndex: String = ""
//    var nickName: String = ""
//    /// 回复id
//    var replyID :String = ""
//    /// 回复人的昵称
//    var replyNickName: String = ""
//
//    init?(map: Map) { }
//
//    mutating func mapping(map: Map) {
//        id <- map["id"]
//        created_by <- map["created_by"]
//        created_at <- map["created_at"]
//        blog_id <- map["blog_id"]
//        discuss_id <- map["discuss_id"]
//        text <- map["text"]
//        imageIndex <- map["imageIndex"]
//        nickName <- map["nickName"]
//        replyNickName <- map["replyNickName"]
//    }
//}

class replyDiscussModel: Codable {

    var id: String = ""
    var created_by: String = ""
    var created_at: String = ""
    /// 文章id
    var blog_id:String = ""
    /// 评论id
    var discuss_id: String = ""
    /// 评论内容
    var text: String = ""
    /// 自定义类型.  头像
    var imageIndex: String = ""
    var nickName: String = ""
    /// 回复id
    var replyID :String = ""
    /// 回复人的昵称
    var replyNickName: String = ""
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
