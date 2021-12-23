//
//  FyUrls.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import Moya

struct FyUrls {
    #if DEBUG
    static let service: Bool = false
    #else
    static let service: Bool = true
    #endif

    static var domain: String {
        return FyUrls.service ? "https://v1.api.cn/" : "https://v1.alapi.cn/"
    }

    static var searchMusic : String {
        return "api/music/search"
    }
}


enum FyApi {
    case search(keyword: String)
}


extension FyApi: TargetType {
    var baseURL: URL {
        return URL(string: FyUrls.domain)!
    }

    var path: String {
        switch self {
        case .search:
            return FyUrls.searchMusic
        default:
            return ""
        }
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .get
        default:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .search(let keyword):
            let params = ["keyword": keyword]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }


}
