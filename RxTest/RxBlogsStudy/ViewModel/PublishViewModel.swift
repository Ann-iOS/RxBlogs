//
//  PublishViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/23.
//

import Foundation
import RxSwift
import RxCocoa
import DBChainKit
import SVProgressHUD

let PUBLISHBLOGSSUCCESSKEY = "PublishBlogsSuccessKey"
class PublishViewModel {

    let bag = DisposeBag()

    var publishState = PublishSubject<Int>()

    let requestPublishBlogs = PublishSubject<Bool>()

    func publishBlogsEvent(title: String, body: String) {
        requestPublishBlogs.subscribe { _ in
            SVProgressHUD.show()
            let params: [String: Any] = ["title":title,
                                         "body":body]

            dbchain.insertRow(tableName: "blogs",
                              fields: params) { [weak self] (state) in
                guard let mySelf = self else {return}
                guard state == "1" else {
                    SVProgressHUD.showError(withStatus: "发布失败")
                    mySelf.publishState.onNext(0)
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                mySelf.publishState.onNext(1)
                NotificationCenter.default.post(name: NSNotification.Name(PUBLISHBLOGSSUCCESSKEY), object: nil)
            }
        }.disposed(by: bag)
    }
}
