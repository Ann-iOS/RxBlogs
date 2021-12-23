//
//  LoginViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/21.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

class LoginViewModel {

    let bag = DisposeBag()
    var requestLogin = PublishSubject<Bool>()

    /// 开始登录
    func startLogin() {
        requestLogin.subscribe { (event) in
            SVProgressHUD.show()
            // 接收到信号 开始发送登录请求
            DispatchQueue.global().async {
                let privatekey = dbchain.generatePrivateByMenemonci(UserDefault.getCurrentMnemonic()!)
                let publickey = dbchain.generatePublickey(privatekey)
                _ = dbchain.generateAddress(publickey)

                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    let vc = HomeViewController.init()
                    let nav = UINavigationController.init(rootViewController: vc)
                    UIApplication.shared.keyWindow?.rootViewController = nav
                }
            }
        }.disposed(by: bag)
    }

    /// 退出操作
    func signout(){
        let filePath = documentTools() + "/USERICONPATH"
        /// 创建文件并保存
        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            // 该文件已存在 删除
            let _ = FileTools.sharedInstance.deleteFile(fileName: USERICONPATH, path: filePath)
        }
        UserDefault.removeUserData()
        let vc = CreateViewController()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
