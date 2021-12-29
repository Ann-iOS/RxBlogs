//
//  DetailBlogViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/27.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

class DetailBlogViewModel {

    let bag = DisposeBag()

//    var tableview = UITableView()

    let replyDataSource = BehaviorRelay(value: [discussModel]())
    private var tempReplyDataSource = BehaviorRelay(value: [discussModel]())

    /// 获取 回复列表的订阅
    let requestGetReply = PublishSubject<Bool>()
    /// 发布评论事件的订阅
    let requestPublishBlogs = PublishSubject<Bool>()


    /// 获取所有评论数据
    func requestBlogsReplyEvent(blogID: String) {
        requestGetReply.subscribe { (_) in
            SVProgressHUD.show()
            dbchain.queryDataByCondition("discuss",
                                         ["blog_id":blogID]) { [weak self] (jsonStr) in
                guard let dmodel = BaseDiscussModel.init(JSONString: jsonStr) else {
                    SVProgressHUD.showError(withStatus: "请求评论列表失败")
                    return
                }
                self?.tempReplyDataSource.accept(dmodel.result!)

                self?.requestReplyUserInfo()
            }
        }.disposed(by: bag)
    }

    /// 获取回复列表的用户信息
    private func requestReplyUserInfo() {

        /// 临时保存回复数据
        let tempReplyArr = BehaviorRelay(value:[discussModel]() )

        tempReplyDataSource.subscribe { (models) in
            models.element?.forEach({ (model) in
                var tempModel = model
                dbchain.queryDataByCondition("user",
                                             ["dbchain_key":model.created_by]) { [weak self] (jsonStr) in
                    guard let umodel = BaseUserModel.init(JSONString: jsonStr) else {
                        SVProgressHUD.showError(withStatus: "请求用户信息失败")
                        return
                    }

                    if umodel.result?.count ?? 0 > 0 {
                        let userModel = umodel.result!.last
                        tempModel.nickName = userModel?.name ?? "未知用户"
                        tempModel.imageIndex = userModel?.photo ?? ""

                        /// 判断回复的id 是否为空
                        if model.discuss_id.isBlank {
                            self?.replyDataSource.accept((self?.replyDataSource.value)! + [tempModel])
//                            tempReplyArr.accept([tempModel])
//                            print("单独的评论: \(self?.replyDataSource.value.count)")
                        } else {
                            /// 添加到 临时数组 做进一步处理
                            tempModel.replyNickName = userModel?.name ?? "未知"
//                            tempReplyArr.append(tempModel)
                            tempReplyArr.accept([tempModel])
                        }

                    } else {
                        /// 判断回复的id 是否为空
                        if model.discuss_id.isBlank {
                            self?.replyDataSource.accept((self?.replyDataSource.value)! + [tempModel])
//                            tempReplyArr.accept([tempModel])
//                            print("单独的评论11: \(self?.replyDataSource.value.count)")
                        } else {
                            /// 添加到 临时数组 做进一步处理
                            tempModel.replyNickName = "未知用户"
//                            tempReplyArr.append(tempModel)
                            tempReplyArr.accept([tempModel])
                        }
                    }
                }
            })
        }
        .disposed(by: bag)

        /// 重新组装 回复数据
        tempReplyArr.subscribe { (models) in

            print("重新组装 回复数据 :\(self.tempReplyDataSource.value.count)")
            var tempModels = self.tempReplyDataSource.value

            for model in tempModels {
                let rmodel = replyDiscussModel()
                rmodel.blog_id = model.blog_id
                rmodel.created_at = model.created_at
                rmodel.created_by = model.created_by
                rmodel.id = model.id
                rmodel.imageIndex = model.imageIndex
                rmodel.nickName = model.nickName
                rmodel.replyID = model.id
                rmodel.discuss_id = model.discuss_id
                rmodel.text = model.text

                for (index, dmodel) in tempModels.enumerated() {
                    var tempDModel = dmodel
                    if dmodel.id == model.discuss_id {
                        rmodel.replyNickName = dmodel.nickName
                        tempDModel.discuss_id = model.discuss_id
                        tempDModel.replyModelArr.append(rmodel)
                        tempModels[index] = tempDModel
                    }
                }
            }

            self.replyDataSource.accept(tempModels)

            print("组装完成: \(self.replyDataSource.value.count) tempModels: \(tempModels.count)")
            SVProgressHUD.dismiss()

        }.disposed(by: bag)


//        replyDataSource.bind(to: tableview.rx.items(cellIdentifier: DetailBlogTableViewCell.identifier)) { index, model, cell in
//            let detailCell = cell as! DetailBlogTableViewCell
////            detailCell.configModel(model: model[index])
//
//            print("index: \(index) -- model: \(model.replyModelArr.count) --- cell: \(cell)")
//
//        }.disposed(by: bag)
    }


    /// 发布评论
    /// contentStr :  评论的内容
    /// replyId :  回复评论的id
    func requestPublishBlogsEvent(contentStr: String, replyId: String) {

    }
}
