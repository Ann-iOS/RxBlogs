//
//  DetailBlogViewController.swift
//  RxTest
//
//  Created by iOS on 2021/12/27.
//

import UIKit
import SVProgressHUD

class DetailBlogViewController: UIViewController {

    private var blogmodel : blogModel!
    var detailView: DetailBlogView!
    var viewModel = DetailBlogViewModel()
    
   required init(blogModel: blogModel) {
        super.init(nibName: nil, bundle: nil)
        self.blogmodel = blogModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "帖子详情"

        detailView = DetailBlogView.init(frame: self.view.bounds)
        detailView.titleStr = self.blogmodel.title
        detailView.detailTitleStr = self.blogmodel.body
        self.view.addSubview(detailView)

        viewModel.requestBlogsReplyEvent(blogID: self.blogmodel.id)
        viewModel.requestGetReply.onNext(true)

        viewModel.replyDataSource.subscribe { [weak self] (models) in

            SVProgressHUD.dismiss()
            print("接收到评论了.  \(models.element?.count)")

            self?.detailView.discussModelArr = models.element ?? []

        }.disposed(by: viewModel.bag)



        detailView.replyBtn.rx.tap.subscribe { [weak self] (_) in

//            print("评论: \(self?.detailView.replyID), --- \(self?.detailView.replyTextField.text)")
            if self?.detailView.replyTextField.text != nil {
                SVProgressHUD.show()

                let dic: [String: Any] = ["blog_id":self?.blogmodel.id ?? "",
                                          "discuss_id":self?.detailView.replyID ?? "",
                                          "text":self?.detailView.replyTextField.text ?? ""]

                dbchain.insertRow(tableName: "discuss",
                                  fields: dic) { (result) in
                    guard result == "1" else { SVProgressHUD.showSuccess(withStatus: "发布失败"); return }
                    SVProgressHUD.showSuccess(withStatus: "发布成功")
                    self?.detailView.replyTextField.text = nil
                    self?.viewModel.requestGetReply.onNext(true)
                }
            }
        }.disposed(by: viewModel.bag)
    }
}

