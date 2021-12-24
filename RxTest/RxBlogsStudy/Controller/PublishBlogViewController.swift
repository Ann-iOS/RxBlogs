//
//  PublishBlogViewController.swift
//  RxTest
//
//  Created by iOS on 2021/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class PublishBlogViewController: UIViewController {

    var publishView : PublishView!
    let viewModel = PublishViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()

        publishView.saveBtn.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] in
                guard let mySelf = self else {return}
                
                mySelf.viewModel.publishBlogsEvent(title: mySelf.publishView.titleTextField.text!,
                                                   body: mySelf.publishView.contenTextView.text!)
                mySelf.viewModel.requestPublishBlogs.onNext(true)
            }).disposed(by: self.viewModel.bag)


        /// 订阅 ViewModel 的结果
        viewModel.publishState.subscribe { [weak self] (state) in
            guard let mySelf = self else {return}
            if state.element == 1 {
                mySelf.navigationController?.popViewController(animated: true)
            }
        }.disposed(by: self.viewModel.bag)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    func configView() {
        self.view.backgroundColor = .colorWithHexString("#F8F8F8")
        let leftItem = UIButton.init(frame: CGRect(x: 10, y: 0, width: 50, height: (self.navigationController?.navigationBar.bounds.height)!))
        leftItem.setTitle("标题", for: .normal)
        leftItem.setTitleColor(.black, for: .normal)
        leftItem.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftItem)

        let cancelButton = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.maxX - 60, y: 0, width: 60, height: (self.navigationController?.navigationBar.bounds.height)!))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.colorWithHexString("#9E9E9E"), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cancelButton)

        cancelButton.rx.tap.subscribe(onNext: {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.viewModel.bag)

        publishView = PublishView.init(frame: self.view.bounds)
        self.view.addSubview(publishView)
    }
}
