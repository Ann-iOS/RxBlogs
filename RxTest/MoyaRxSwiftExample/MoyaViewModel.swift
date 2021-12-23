//
//  MoyaViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

import ObjectMapper

class MoyaViewModel {

    /// DisposeBag
    private let disposeBag: DisposeBag

    private let provider = MoyaProvider<MyAPI>()

    /// 既是可监听序列也是观察者的数据源,里面封装的其实是BehaviorSubject
    let dataSource: BehaviorRelay<[Post]> = BehaviorRelay(value: [])


    /// 初始化方法
     /// - Parameter disposeBag: 传入的disposeBag
     init(disposeBag: DisposeBag) {
         self.disposeBag = disposeBag
     }

    func getPosts() -> Observable<[Post]> {
        return provider.rx.request(.Show)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapJSON()
            .mapArray(type: Post.self)
    }


//    public func getData() {
//        getPostsData()
//    }
//
//    private func getPostsData() {
//        provider.rx.request(.Show)
//            .debug()
//            .map([Post].self)
//            .debug()
//            .compactMap { $0 }
//            .debug()
//            .asObservable()
//            .asSingle()
//            .debug()
//            .subscribe { (event) in
//
//                print("数据: \(event)")
//
//                switch event {
//
//                case .success(let model):
//
//                    print("数据获取成功: \(model) - ")
//
//                case .failure(let error):
//
//                    print("数据获取失败: \(error)")
//
//                    break
//                }
//            }.disposed(by: disposeBag)
//    }




//    func createPost(title: String, body: String, userId: Int) -> Observable<Post> {
//        return provider.rx.request(.Create(title: title, body: body, userId: userId))
//            .asObservable()
//            .mapJSON()
//            .mapObject(type: Post.self)
//    }


}

