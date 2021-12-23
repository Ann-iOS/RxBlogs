//
//  Observable+ObjectMapper.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper


//extension Observable {
//
//    func mapObject<T: Mappable>(type: T.Type) -> Observable {
//        return self.map { response in
//            guard let dict = response as? [String: Any] else {
//                throw RxSwiftMoyaError.ParseJSONError
//            }
//
//            return Mapper<T>().map(JSON: dict) as! Element
//        }
//    }
//
//
//    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
//        return self.map { response in
//            guard let array = response as? [Any] else {
//                throw RxSwiftMoyaError.ParseJSONError
//            }
//            guard let dicts = array as? [[String: Any]] else {
//                throw RxSwiftMoyaError.ParseJSONError
//            }
//            return Mapper<T>().mapArray(JSONArray: dicts)
//        }
//    }
//
//}
//
//enum RxSwiftMoyaError: String {
//    case ParseJSONError
//    case OtherError
//}
//
//extension RxSwiftMoyaError: Swift.Error {}
//

extension Observable {
    
    func mapObject<T: Mappable>(type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }

            return Mapper<T>().map(JSON: dict)!
        }
    }

    func mapArray<T: Mappable>(type: T.Type) -> Observable<[T]> {
        return self.map { response in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            guard let array = response as? [Any] else {
                throw RxSwiftMoyaError.ParseJSONError
            }

            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.ParseJSONError
            }

            return Mapper<T>().mapArray(JSONArray: dicts)
        }
    }
}

enum RxSwiftMoyaError: String {
    case ParseJSONError
    case OtherError
}

extension RxSwiftMoyaError: Swift.Error { }








//public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
//    func mapObject<T: BaseMappable>(type: T.Type) -> Single<T> {
//        return self.map{ response in
//            return try response.mapObject(type: type)
//        }
//    }
//    func mapArray<T: BaseMappable>(type: T.Type) -> Single<[T]> {
//        return self.map{ response in
//            return try response.mapArray(type: type)
//        }
//    }
//}
//
//public extension ObservableType where Element == Response {
//    func mapObject<T: BaseMappable>(type: T.Type) -> Observable<T> {
//        return self.map{ response in
//            return try response.mapObject(type: type)
//        }
//    }
//    func mapArray<T: BaseMappable>(type: T.Type) -> Observable<[T]> {
//        return self.map{ response in
//            return try response.mapArray(type: type)
//        }
//    }
//}



//public extension Response {
//    func mapObject<T: BaseMappable>(type: T.Type) throws -> T{
//        let text = String(bytes: self.data, encoding: .utf8)
//        if self.statusCode < 400 {
//            return Mapper<T>().map(JSONString: text!)!
//        }
//        do{
//            let serviceError = Mapper<ServiceError>().map(JSONString: text!)
//            throw serviceError!
//        }catch{
//            if error is ServiceError {
//                throw error
//            }
//            let serviceError = ServiceError()
//            serviceError.message = "服务器开小差，请稍后重试"
//            serviceError.error_code = "parse_error"
//            throw serviceError
//        }
//    }
//    func mapArray<T: BaseMappable>(type: T.Type) throws -> [T]{
//        let text = String(bytes: self.data, encoding: .utf8)
//        if self.statusCode < 400 {
//            return Mapper<T>().mapArray(JSONString: text!)!
//        }
//        do{
//            let serviceError = Mapper<ServiceError>().map(JSONString: text!)
//            throw serviceError!
//        }catch{
//            if error is ServiceError {
//                throw error
//            }
//            let serviceError = ServiceError()
//            serviceError.message = "服务器开小差，请稍后重试"
//            serviceError.error_code = "parse_error"
//            throw serviceError
//        }
//    }
//}


//class ServiceError:Error,Mappable{
//    var message:String = ""
//    var error_code:String = ""
//    required init?(map: Map) {}
//    init() {
//
//    }
//    func mapping(map: Map) {
//        error_code <- map["error_code"]
//        message <- map["error"]
//    }
//    var localizedDescription: String{
//        return message
//    }
//}
