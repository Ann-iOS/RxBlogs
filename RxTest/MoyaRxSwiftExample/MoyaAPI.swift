//
//  MoyaAPI.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import Moya


let ApiProvider = MoyaProvider<MyAPI>()

enum MyAPI {
    case Show
    case Create(title: String, body: String, userId: Int)
}

extension MyAPI: TargetType {

    var headers: [String : String]? {
        switch self {
        case .Show:
            return nil
        case .Create(let title, let body, let userId):
            return ["title": title, "body": body, "userId": "\(userId)"]
        }
    }

    var baseURL: URL {
        return URL(string: "http://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .Show:
            return "/posts"
        case .Create(_, _, _):
            return "/posts"
        }
    }

    var method: Moya.Method {
        switch self {
        case .Show:
            return .get
        case .Create(_, _, _):
            return .post
        }
    }

//    var parameters: [String: Any]? {
//        switch self {
//        case .Show:
//            return nil
//        case .Create(let title, let body, let userId):
//            return ["title": title, "body": body, "userId": userId]
//        }
//    }

//    var sampleData: Data {
//        switch self {
//        case .Show:
//            return "[{\\"userId\\": \\"1\\", \\"Title\\": \\"Title String\\", \\"Body\\": \\"Body String\\"}]".data(using: String.Encoding.utf8)!
//        case .Create(_, _, _):
//            return "Create post successfully".data(using: String.Encoding.utf8)!
//        }
//    }

    var task: Task {
        return .requestPlain
    }
}
