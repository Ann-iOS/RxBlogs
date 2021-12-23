//
//  BlogsAPI.swift
//  RxTest
//
//  Created by iOS on 2021/12/17.
//

import Foundation
import Moya
import HDWalletSDK

let BlogsApiProvider = MoyaProvider<BlogsAPI>()

enum BlogsAPI {
    case BlogsList(tableName: String, token: String,appcode: String)
//    case UserInformation(UID: String)
}

extension BlogsAPI: TargetType {

    var headers: [String : String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "https://controlpanel.dbchain.cloud/relay02/")!
    }

    var path: String {
        switch self {
        case .BlogsList(let tableName, let token, let appcode):
            let dic : [[String:Any]] = [["method":"table","table":tableName]]
            let dicData = try! JSONSerialization.data(withJSONObject: dic, options: [])
            let dicBase = Base58.encode(dicData)
            return "dbchain/querier/\(token)/\(appcode)/\(dicBase)"
//        case .UserInformation(let UID):
//            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .BlogsList:
            return .get
        }
    }

    var task: Task {
        return .requestPlain
    }
}
