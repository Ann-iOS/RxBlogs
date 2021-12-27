//
//  HomeViewController.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//   https://www.hangge.com/blog/cache/detail_1933.html

import UIKit
import RxSwift
import RxCocoa
import HDWalletSDK
//import GMChainSm2

class HomeViewController: UIViewController {

    var rightIconBtn = UIButton()
    var publishBlogButton = UIButton()
    let blogsVM = BlogsViewModel.init()
    var tableview : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .colorWithHexString("#F8F8F8")

        publishBlogButton.setTitle("写博客", for: .normal)
        publishBlogButton.setTitleColor(.white, for: .normal)
        publishBlogButton.backgroundColor = .colorWithHexString("#2E44FF")
        publishBlogButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        publishBlogButton.layer.cornerRadius = 18
        publishBlogButton.layer.masksToBounds = true

        setNavBar()
        bindBlogsView()

        rightIconBtn.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext:  {
                let vc = UserHomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: self.blogsVM.bag)

        publishBlogButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                let vc = PublishBlogViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: self.blogsVM.bag)

        /// 接收博客发布成功后的通知
        _ = NotificationCenter.default.rx
            .notification(Notification.Name(PUBLISHBLOGSSUCCESSKEY))
            .take(until: self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: { _ in
                self.blogsVM.requestCommond.onNext(true)
            }).disposed(by: self.blogsVM.bag)

        tableview.rx.itemSelected.bind { [weak self] index in
            self?.tableview.deselectRow(at: index, animated: false)
            let model = self?.blogsVM.modelDataSource.value[index.row]
//            print("model: \(model?.title) --- index: \(index.row)")
            self?.navigationController?.pushViewController(DetailBlogViewController(blogModel: model!), animated: true)
        }.disposed(by: blogsVM.bag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(publishBlogButton)
        publishBlogButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-26)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(52)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(UserDefault.getCurrentMnemonic()!)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            let fileDic = FileTools.sharedInstance.filePathsWithDirPath(path: filePath)
            do {
                let imageData = try Data(contentsOf: URL.init(fileURLWithPath: fileDic[0]))
                rightIconBtn.setImage(UIImage(data: imageData), for: .normal)
            }
            catch {
                rightIconBtn.setImage(UIImage(named: "home_icon_image"), for: .normal)
            }
        }
    }


    func bindBlogsView() {
        self.tableview = UITableView.init(frame: self.view.bounds, style: .plain)
        self.tableview.separatorStyle = .none
        self.tableview.backgroundColor = .colorWithHexString("#F8F8F8")
        self.tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        tableview.register(HomeTableViewCell.self, forCellReuseIdentifier: "cellid")
        tableview.rowHeight = 170
        view.addSubview(tableview)

        blogsVM.tableview = tableview
        blogsVM.blogsBindingFunc()

        blogsVM.requestCommond.onNext(true)
    }

    func setNavBar() {
        let  item =  UIBarButtonItem (title:  "" , style: . plain , target:  self , action:  nil )
        self.navigationItem.backBarButtonItem = item

        self.navigationController?.navigationBar.barTintColor = .colorWithHexString("#F3F3F3")
        let navContentView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: kNavBarHeight))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navContentView)

        let leftImgV = UIImageView.init(image: UIImage(named: "creat_top_image"))
        leftImgV.frame = CGRect(x: 0, y: 0, width: 178, height: 40)
        navContentView.addSubview(leftImgV)

        rightIconBtn = UIButton.init(frame: CGRect(x: navContentView.frame.width - 76, y: 0, width: 40, height: 40))
        rightIconBtn.layer.cornerRadius = 20
        rightIconBtn.layer.masksToBounds = true

        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            let fileDic = FileTools.sharedInstance.filePathsWithDirPath(path: filePath)
            do{
                let imageData = try Data(contentsOf: URL.init(fileURLWithPath: fileDic[0]))
                rightIconBtn.setImage(UIImage(data: imageData), for: .normal)
            }catch{
                rightIconBtn.setImage(UIImage(named: "home_icon_image"), for: .normal)
            }
        } else {
            rightIconBtn.setImage(UIImage(named: "home_icon_image"), for: .normal)
        }
        navContentView.addSubview(rightIconBtn)
    }
}


extension UIViewController {
    ///消除导航栏下划线
       func clearNavigationBarLine() {
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
       }

       ///消除标签栏下划线
       func clearTabBarLine() {
           let image_w = creatColorImage(.white)
           if #available(iOS 13.0, *) {
               let appearance = UITabBarAppearance()
               appearance.backgroundImage = image_w
               appearance.shadowImage = image_w
               self.tabBarController?.tabBar.standardAppearance = appearance
           } else {
               self.tabBarController?.tabBar.backgroundImage = image_w
               self.tabBarController?.tabBar.shadowImage = image_w
           }
       }

       ///用颜色创建一张图片
       func creatColorImage(_ color:UIColor,_ ARect:CGRect = CGRect.init(x: 0, y: 0, width: 1, height: 1)) -> UIImage {
           let rect = ARect
           UIGraphicsBeginImageContext(rect.size)
           let context = UIGraphicsGetCurrentContext()
           context?.setFillColor(color.cgColor)
           context?.fill(rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image!
       }
}
