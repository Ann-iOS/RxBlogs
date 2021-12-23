//
//  APIManager.swift
//  RxTest
//
//  Created by iOS on 2021/12/13.
//

import Foundation
import RxSwift
import RxCocoa
import HandyJSON
import Moya
import SwiftyJSON

/////定义在处理过程中可能出现的Error
//enum RxSwiftMoyaError: String {
//    case ParseJSONError   ///解析json时出错
//    case OtherError       ///其他错误
//    case ResponseError    ///返回的结果有错
//    case RequestFailedError ///请求返回错误 （根据请求码判断）
//}
//
//
/////让其实现Swift.Error 协议
//extension RxSwiftMoyaError: Swift.Error { }


///扩展 RxSwift的Observable协议，添加mapModel方法
//extension Observable {
//
//    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> Observable<T> {
//        return map { response in
//
//            ///判断Response类型
//            guard let response = response as? Moya.Response else {
//                throw RxSwiftMoyaError.ResponseError
//            }
//
//            ///判断请求码
//            guard (200...209) ~= response.statusCode else {
//                throw RxSwiftMoyaError.RequestFailedError
//            }
//
//            ///转json
//            guard let json = try? (JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as! [String: Any]) else {
//                throw RxSwiftMoyaError.ResponseError
//            }
//
//
//            ///使用HandyJSON库，映射成指定模型
//            let object = JSONDeserializer<T>.deserializeFrom(dict: json)
//            guard let model = object else {
//                throw RxSwiftMoyaError.ParseJSONError
//            }
//            return model
//        }
//    }
//}





//扩展Moya支持HandyJSON的解析

//extension Response {
//    func mapModel<T: HandyJSON>(_ type: T.Type) -> T {
//        let jsonString = String.init(data: data, encoding: .utf8)
//        if let modelT = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
//            return modelT
//        }
//        return JSONDeserializer<T>.deserializeFrom(json: "msg:请求有误")!
//    }
//}
//
//extension ObservableType where Element == Response {
//    public func mapModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
//        return flatMap { response -> Observable<T> in
//            return Observable.just(response.mapModel(T.self))
//        }
//    }
//}





class APIManager: NSObject {

//    static let shared = APIManager()
//    private let provider = MoyaProvider<API>()
//
//    func getHomeListData(_ tableName: String,_ token: String) -> Observable<[BaseBlogsSections]> {
//
//        return Observable<[BaseBlogsSections]>.create { observable -> Disposable in
//            self.provider.request(.getTableListWith(tableName: tableName, token: token), callbackQueue: .main) { (response) in
//                switch response {
//                case let .success(result):
//                    let blogs = self.blogsParse(result.data)
//                    observable.onNext(blogs)
//                    observable.onCompleted()
//                case let .failure(error):
//                    observable.onError(error)
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
//
//    /// 处理数据
//    func blogsParse(_ data: Any) -> [BaseBlogsSections] {
//        guard let result = JSON(data)["result"].array else {
//            return []
//        }
//        var blogs :[blogModel] = []
//        result.forEach {
//            guard !$0.isEmpty else { return }
//            let model = blogModel(id: $0["id"].string ?? "",
//                                  created_by: $0["created_by"].string ?? "",
//                                  created_at: $0["created_at"].string ?? "",
//                                  title: $0["title"].string ?? "",
//                                  body: $0["body"].string ?? "",
//                                  name: $0["name"].string ?? "",
//                                  imgUrl: $0["imgUrl"].string ?? "",
//                                  readNumber: 20)
//            blogs.append(model)
//        }
//        return [BaseBlogsSections(height: "0", items: blogs)]
//    }
}
