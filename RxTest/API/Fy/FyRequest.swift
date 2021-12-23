//
//  FyRequest.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

let requestTimeoutClosureFy = { (endpoint: Endpoint, done: @escaping MoyaProvider<FyApi>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        if (request.url?.absoluteString.contains(FyUrls.searchMusic.lowercased()) ?? false) {
            request.timeoutInterval = 30
//            request.addValue("zhangsan", forHTTPHeaderField: "user")
//            request.addValue("asdasdasdad", forHTTPHeaderField: "cookie")
        } else {
            request.timeoutInterval = 10
        }
        done(.success(request))
    } catch {
        return
    }
}


class FyRequest: NSObject {

    static let request = FyRequest()

    var provider = MoyaProvider<FyApi> (requestClosure: requestTimeoutClosureFy, plugins: [NetworkLoggerPlugin()])

//    public func searchSongs(keyword: String) -> Single<Result<Songs>> {
//        return provider.rx.request(.search(keyword: keyword))
//            .filterSuccessfulStatusCodes()
//            .mapModel()
////            .
//    }

    public func searchSongs(keyword:String) ->  Single<Result<Songs>>{
        return  provider.rx.request(.search(keyword: keyword))
            .filterSuccessfulStatusCodes()
            .mapModel()
            .flatMap { (result: FyResponse<Songs>) in
                if result.isSuccess{
                    return  Single.just(Result.regular(result.data ?? Songs()))
                } else {
                    return Single.just(Result<Songs>.failing(RxMoyaError.reason(result.message ?? "")))
                }
        } .catch({ error in
            return Single.just(Result.failing(RxMoyaError.reason(ErrorTips.netWorkError.rawValue)))
        })

    }
}
