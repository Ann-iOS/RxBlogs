//
//  API.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import Foundation
import Moya
import HDWalletSDK

struct URL_Macro {
    static let BASEURL : String = "https://controlpanel.dbchain.cloud/relay/"
    static let Chainid : String = "testnet"
    static let APPCODE : String = "5APTSCPSF7"
    /// 图片下载地址
    static let ImageBaseURL = BASEURL + "/ipfs/"
}


//设置请求超时时间
let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<API>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 30
        done(.success(request))
    } catch {
        print("超时!!!!!")
        return
    }
}


enum API {
    case getPhoneNumberCode(mobile: String)
    case getTableListWith(tableName: String,token: String)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: URL_Macro.BASEURL)!
    }

    var path: String {
        switch self {
        case .getPhoneNumberCode(let mobile):
            return "dbchain/oracle/nft/send_verf_code/register/\(mobile)"
        case .getTableListWith(let tableName, let token):
            let dic : [[String:Any]] = [["method":"table","table":tableName]]
            let dicData = try! JSONSerialization.data(withJSONObject: dic, options: [])
            let dicBase = Base58.encode(dicData)

            return "dbchain/querier/\(token)/\(URL_Macro.APPCODE)/\(dicBase)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPhoneNumberCode(_),
             .getTableListWith(_, _):
            return .get
        default:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getPhoneNumberCode,
             .getTableListWith:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
