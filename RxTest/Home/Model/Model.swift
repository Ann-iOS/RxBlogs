//
//  Model.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import Foundation
import UIKit
import RxDataSources
import HandyJSON

/**  *******  演示例子模型  ************    */
struct Music {
    let name: String
    let singer: String

    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

/// 自定义打印
extension Music: CustomStringConvertible {
    var description: String {
        return "name: \(name) singer: \(singer)"
    }
}









// **********   博客例子   ***************

//struct BaseBlogsSections {
//
////    var height : String?
////    var result : [blogModel]
//
//    var height: String?
//    var items: [blogModel]
//
//}
//
//extension BaseBlogsSections : SectionModelType {
//
//    typealias Item = blogModel
//
//    init(original: BaseBlogsSections, items: [blogModel]) {
//        self = original
//        self.items = items
//    }
//}
//
//
//struct blogModel {
//    var id: String
//    var created_by: String
//    var created_at: String
//    var title:String
//    var body: String
//    var name: String
//    var imgUrl: String
//    var readNumber: Int
//}


//class BaseBlogsModel: HandyJSON {
//    var height: String?
//    var result: [blogModel]?
//    required init() { }
//}
//
//class blogModel :HandyJSON {
//    var id: String?
//    var created_by: String?
//    var created_at: String?
//    var title:String?
//    var body: String?
//    var name: String?
//    var imgUrl: String?
//    var readNumber: Int?
//    required init() { }
//}
