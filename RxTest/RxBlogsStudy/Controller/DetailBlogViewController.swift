//
//  DetailBlogViewController.swift
//  RxTest
//
//  Created by iOS on 2021/12/27.
//

import UIKit

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
//        viewModel.tableview = detailView.tableView
        viewModel.requestGetReply.onNext(true)

        viewModel.replyDataSource.subscribe { [weak self] (models) in
            print("接收到评论了.  \(models.element?.count)")
            self?.detailView.discussModelArr = models.element ?? []
        }.disposed(by: viewModel.bag)
    }
}

