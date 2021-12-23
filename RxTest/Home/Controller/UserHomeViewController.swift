//
//  UserHomeViewController.swift
//  RxTest
//
//  Created by iOS on 2021/12/23.
//

import UIKit
import RxSwift
import RxCocoa

class UserHomeViewController: UIViewController {

    let bag = DisposeBag()
    private let navImgV = UIImageView.init(image: UIImage(named: "homepage_nav_image"))
    private let editButton = UIButton.init(type: .custom)
    private var userView: UserHomeView!
    let userViewModel = UserHomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .colorWithHexString("#F8F8F8")
        configNavBar()

        userView = UserHomeView.init(frame: self.view.bounds)
        self.view.addSubview(userView)

        userViewModel.getUserInformation()
        /// 开始订阅发送网络请求
        userViewModel.requestCommond.onNext(true)

        /// Header View  赋值
        userViewModel.userDataSource.subscribe { [weak self] (event) in
            guard let mySelf = self else {return}
            if event.element!.count > 0 {
                let model = event.element!.last
                mySelf.userView.configUserInfo(model: model!)
            }
        }.disposed(by: bag)

        /// TableView 赋值
//        userViewModel.blogDataSource.subscribe { (event) in
//            print("首页 博客的数量: \(event.element?.count)")
//        }.disposed(by: bag)

        /// drive 赋值
        userViewModel.blogDataSource.asDriver().drive(userView.tableView.rx.items(cellIdentifier: "userCellId", cellType: HomeTableViewCell.self)){ (index, model, cell ) in
            let uModel = self.userViewModel.userDataSource.value.last
            let blogsModel = model
            blogsModel.name = uModel?.name
            blogsModel.imgUrl = uModel?.photo
            blogsModel.readNumber = randomIn(min: 100, max: 1000)
            cell.selectionStyle = .none
            cell.configCellModel(blogsModel: blogsModel)
        }.disposed(by: bag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    func configNavBar() {
        navImgV.frame = CGRect(x: UIScreen.main.bounds.width * 0.5 - 90, y: 20, width: 180, height: 40)
        self.navigationItem.titleView = navImgV

        editButton.setImage(UIImage(named: "homepage_edit"), for: .normal)
        editButton.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 20, width: 32, height: 32)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
    }
}
