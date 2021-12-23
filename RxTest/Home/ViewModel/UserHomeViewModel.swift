//
//  UserHomeViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

class UserHomeViewModel {

    let bag = DisposeBag()

    let userDataSource = BehaviorRelay(value: [userModel]())

//    let userDataSource = PublishSubject<[userModel]>()

    let blogDataSource = BehaviorRelay(value: [blogModel]())

    let requestCommond = PublishSubject<Bool>()


    func getUserInformation () {

//        let concatSubject = BehaviorSubject(value: self.userDataSource)
//
//        concatSubject.asObservable().concat().subscribe { (userModels) in
//            print("获取用户信息: \(userModels.count)")
//            let lastUser = userModels.last
//            print("最后一条用户信息的name: \(lastUser?.name) --- 头像地址\(lastUser?.photo)")
//        } onCompleted: {
//            concatSubject.onCompleted()
//        }.disposed(by: self.bag )


        requestCommond.subscribe { (event) in

            /// 获取用户信息
            /// 获取发布的博客列表
            dbchain.queryDataByCondition("user",
                                         ["dbchain_key": UserDefault.getAddress()!]) { [weak self] (userResult) in
                guard let mySelf = self else {return}
                guard let umodel = BaseUserModel.init(JSONString: userResult) else {
                    SVProgressHUD.showError(withStatus: "请求用户信息失败")
                    return
                }

                mySelf.userDataSource.accept(umodel.result!)
            }


            /// 请求博客数据
            dbchain.queryDataByCondition("blogs",
                                         ["created_by": UserDefault.getAddress()!]) { [weak self] (blogResult) in
                guard let mySelf = self else {return}
                guard let bmodel = BaseBlogsModel.init(JSONString: blogResult) else {
                    SVProgressHUD.showError(withStatus: "请求用户_博客_信息失败")
                    return
                }

                mySelf.blogDataSource.accept(bmodel.result!)
            }

        }.disposed(by: bag)
    }
}
