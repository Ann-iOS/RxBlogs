//
//  BlogsViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/17.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import RxDataSources
import SVProgressHUD

class BlogsViewModel {

    var bag = DisposeBag()

    var blogsProvider = MoyaProvider<BlogsAPI>()

    var modelDataSource = BehaviorRelay(value: [blogModel]())

    var requestCommond = PublishSubject<Bool>()

    var tableview = UITableView()

    private var blogSource = BehaviorRelay(value: [blogModel]())


    func blogsBindingFunc(){

///        系统自带cell
//        modelDataSource.asObservable().bind(to: tableview.rx.items(cellIdentifier: "cellid")) {
//            row, model, cell in
//            print("asObservable 接收到了通知 \(row)")
//            let homeCell = cell as! HomeTableViewCell
//            homeCell.selectionStyle = .none
//            homeCell.configCellModel(blogsModel: model)
//        }.disposed(by: bag)


//        modelDataSource.asObservable().subscribe(onNext: {_ in
////            print($0)
//            print("asObservable 接收到了通知   ---")
//        }).disposed(by: bag)


//        modelDataSource.asDriver().drive(onNext: { [weak self] model in
//            guard let mySelf = self else {return}
//            print("drive 接收到通知!!!  \(model.count)")
//        }).disposed(by: bag)


//      自定义cell
        modelDataSource.bind(to: tableview.rx.items(cellIdentifier: "cellid")) { index, model, cell in
//            print("自定义cell 刷新列表了!! \(index)")
            let homeCell = cell as! HomeTableViewCell
            homeCell.selectionStyle = .none
            homeCell.configCellModel(blogsModel: model)
        }.disposed(by: bag)


        ///  发送网络请求
        requestCommond.subscribe { [self] (event: Event<Bool>) in
            SVProgressHUD.show()
            self.blogsProvider.rx
                .request(.BlogsList(tableName: "blogs", token: dbchain.token!, appcode: dbchain.appcode!))
                .mapJSON()
                .asObservable()
                .mapObject(type: BaseBlogsModel.self)
                .subscribe { (baseModel) in
                    self.blogSource.accept(baseModel.result!)
                    requestUserData()
                } onError: { (error) in
                    print("发生了错误:: \(error)")
                }.disposed(by: bag)
        }.disposed(by: self.bag)
    }

    /// 请求用户信息
    private func requestUserData() {
        blogSource.asObservable().subscribe {[weak self] (blogmodel) in
            guard let mySelf = self else {return}

            let signal = DispatchSemaphore(value: 1)
            let global = DispatchGroup()

            for (index,model) in blogmodel.element!.enumerated() {
                global.notify(queue: DispatchQueue.global(), work: DispatchWorkItem.init(block: {
                    signal.wait()
                    let tempBlogArr = blogmodel.element!
                    tempBlogArr[index].readNumber = randomIn(min: 100, max: 1000)
                    /// 查询头像信息
                    dbchain.queryDataByCondition("user",
                                                 ["dbchain_key":model.created_by]) { (userResult) in

                        guard let umodel = BaseUserModel.init(JSONString: userResult) else {
                            signal.signal()
                            return
                        }

                        if umodel.result?.count ?? 0 > 0 {
                            /// 查找头像
                            let userLastModel = umodel.result?.last
                            tempBlogArr[index].name = userLastModel!.name
                            tempBlogArr[index].imgUrl = userLastModel!.photo
                            signal.signal()
                        } else {
                            signal.signal()
                        }

                        if index == blogmodel.element!.count - 1 {
                            SVProgressHUD.dismiss()
                            mySelf.modelDataSource.accept(tempBlogArr.reversed())
                        }
                    }
                }))
            }
        }.disposed(by: bag)
    }

}


// 随机数
func randomIn(min: Int, max: Int) -> Int {
    return Int(arc4random()) % (max - min + 1) + min
}
