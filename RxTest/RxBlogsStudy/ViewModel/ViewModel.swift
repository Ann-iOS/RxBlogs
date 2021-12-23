//
//  ViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import HandyJSON

//  ********* 演示例子 viewModel  ************ //
struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "淘汰", singer: "陈奕迅"),
        Music(name: "后来", singer: "刘若英"),
        Music(name: "勿忘", singer: "李代沫"),
        Music(name: "彻悟", singer: "程响"),
        Music(name: "故事很短", singer: "于冬然")
    ])
}


class HomeListViewModel {

//    let provider = MoyaProvider<API>()
//
//    func getHomeList(_ tableName: String,_ token: String,_ success:@escaping ()->()) {
//
//       try? provider.rx.request(.getTableListWith(tableName: tableName, token: token), callbackQueue: .main)
//            .asObservable()
//            .replay(3)
//            .mapModel(BaseBlogsModel.self)
//            .subscribe { (model) in
//                print("博客信息列表: \(model)")
//            }.disposed(by: DisposeBag())
//
//
//
////        provider.request(.getTableListWith(tableName: tableName, token: token), callbackQueue: .main) { (response) in
////            switch response {
////            case let .success(result):
//////                let blogs = self.blogsParse(result.data)
//////                observable.onNext(blogs)
//////                observable.onCompleted()
////            break
////            case let .failure(error):
//////                observable.onError(error)
////            break
////            }
////        }
//    }

}



final class NetworkTools {

//    static func request<H: HandyJSON, T: TargetType>(_ type:T, _ model: H.Type) -> Observable<H> {
//
//        let mp = MoyaProvider<T>()
//        let ob = try? mp
//            .rx.request(type)  ///type 实现T类型协议的具体对象
//            .asObservable()
//            .mapModel(model)
//
//        return ob!
//    }
}


/////使用
//NetworkTools.request(MemberApi.login(username: "haha", password: "123456", token: "qwe"), UserInfo.self)
//.subscribe(onNext:{   ///订阅
//
//})
