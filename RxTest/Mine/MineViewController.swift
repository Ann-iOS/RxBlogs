//
//  MineViewController.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import UIKit
import RxSwift
import Moya
import RxDataSources
import ObjectMapper


class MineViewController: UIViewController {

    var tableView: UITableView!

    var dataSource = [Post]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.rowHeight = 50
        self.view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

//        MoyaRxSwiftExample 文件夹 之 Moya + Rx 例子
//        MoyaRxSwiftExample_requestData()
//        MoyaRxSwiftExample_RxRequestExample()

    }
}


/// MoyaRxSwiftExample
extension MineViewController {

    // 成功
    func MoyaRxSwiftExample_requestData () {
        ApiProvider.request(.Show, callbackQueue: .main) { (result) in
            switch result {
            case .success(let response):
                let data = response.data
                let str = String(data: data, encoding: .utf8)!
                print("Success: \(String(data: data, encoding: .utf8)!)")
                // 处理数据
                self.dataSource = Mapper<Post>().mapArray(JSONString: str)!

                print("转换模型成功:!!!!! \(self.dataSource.count) ")

            case .failure(let error):
                print("error: \(error)")
                break
            }
        }
    }

    /// 成功
    func MoyaRxSwiftExample_RxRequestExample(){

        let viewModel  = MoyaViewModel(disposeBag: disposeBag)

        viewModel.getPosts()
            .subscribe { (post: [Post]) in
                self.dataSource = post
            } onError: { (error) in
                print("error: \(error)")
            }.disposed(by: disposeBag)



//        viewModel.createPost(title: "Title 1", body: "Body 11", userId: 1)
//            .subscribe { (post: Post) in
//                print("create: \(post.title ?? "")")
//            } onError: { (error) in
//                print("create_error: \(error)")
//            }.disposed(by: disposeBag)

    }

    /// 错误
    func MoyaRxSwiftExample_Rx_ErrorRequestExample() {

//        let viewModel  = MoyaViewModel(disposeBag: disposeBag)
//        viewModel.getData()
//
//        viewModel.dataSource
//            .asDriver(onErrorJustReturn: [])
//            .drive(tableView.rx.items) { (tableview, row, post) in
//
//                if let cell = tableview.dequeueReusableCell(withIdentifier: UITableViewCell.className) {
//                    cell.textLabel?.text = "UserID: \(post.id  ?? -1)"
//                    cell.detailTextLabel?.text = "内容: \(post.title ?? "没有内容 Error")"
//                    return cell
//                } else {
//                    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: UITableViewCell.className)
//                    cell.textLabel?.text = "UserID: \(post.id ?? -1)"
//                    cell.detailTextLabel?.text = "内容: \(post.title ?? "没有内容 Error")"
//                    return cell
//                }
//
//            }.disposed(by: disposeBag)
//

    }

}



extension MineViewController: UITableViewDelegate {

}

extension MineViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as UITableViewCell
        let model = self.dataSource[indexPath.row]
        cell.textLabel?.text = model.title
        return cell
    }
}






// MARK: - 获取类的字符串名称
extension NSObject {

    /// 对象获取类的字符串名称
    public var className: String {
        return runtimeType.className
    }

    /// 类获取类的字符串名称
    public static var className: String {
        return String(describing: self)
    }

    /// NSObject对象获取类型
    public var runtimeType: NSObject.Type {
        return type(of: self)
    }
}
