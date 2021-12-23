//
//  CenterViewController.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import UIKit
import Moya
import RxSwift
import RxBlocking

class CenterViewController: UIViewController {
    
//    let provider = MoyaProvider<MyApiService>()
    let blogsVM = BlogsViewModel()
    var tableview : UITableView!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        bindBlogsView()
    }

    func bindBlogsView() {
        self.tableview = UITableView.init(frame: self.view.bounds, style: .plain)
        view.addSubview(tableview)

        blogsVM.tableview = tableview
        blogsVM.blogsBindingFunc()

        blogsVM.requestCommond.onNext(true)
    }

}


/*
 let provider = MoyaProvider<MyApiService>()

 // Moya 提供最原始的请求方式，响应的数据是二进制
 provider.request(.user(userId: "101")){ result in
         // do something with the result
         let text = String(bytes: result.value!.data, encoding: .utf8)
     print("text1 = \(text)")
 }

 // 结合RxSwift，响应的数据是二进制
 provider.rx.request(.user(userId: "101")).subscribe({result in
         // do something with the result
         switch result {
         case let .success(response):
             let text = String(bytes: response.data, encoding: .utf8)
             print("text2 = \(text)")
         case let .error(error):
             print(error)
     }
 })

 // 通过mapJSON把数据转换成json格式
 provider.rx.request(.user(userId: "101")).mapJSON().subscribe({result in
         // do something with the result
         switch result {
         case let .success(text):
             print("text3 = \(text)")
         case let .error(error):
             print(error)
     }
 })
 // 通过mapJSON把数据转换成json格式，并转换成最常见的Observable
 provider.rx.request(.user(userId: "101")).mapJSON().asObservable().subscribe(onNext: { result in
         // do something with the result
         print("text4 = \(result)")
 }, onError:{ error in
     // do something with the error
 })
 */
