//
//  CreatedViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/20.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

/// 验证状态
enum ValidationResult {
    case ok(message: String)
    case empty // 空
    case validating // 验证状态中
    case failed(message: String)  // 失败
}

protocol WireFrame {

    /// 弹框
    /// 由于弹框属于View层，但是又得在ViewModel中使用，这违背了MVVM模式中ViewModel不能引用View的限制。所以通过协议来解决这个问题，在ViewModel层中定义如下协议：
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息体
    ///   - cancelAction: 取消按钮
    ///   - actions: 其他按钮数组
    ///   - animated: 是否动画
    ///   - completion: 完成闭包
    func promptFor<Action: CustomStringConvertible>(_ title: String,message: String,cancelAction: Action,actions: [Action]?, animated: Bool, completion: (() -> Void)?) -> Observable<Action>
}



import DBChainKit
class CreatedViewModel {

    let bag = DisposeBag()
    var requestCommond = PublishSubject<Bool>()

    func requestRegister(mnemonicStr: String,nickName: String) {

        requestCommond.subscribe { (event) in
            SVProgressHUD.show()
            let lowMnemoicStr = mnemonicStr.lowercased()
            DispatchQueue.global().async {
                let privatekey = dbchain.generatePrivateByMenemonci(lowMnemoicStr)
                let publickey = dbchain.generatePublickey(privatekey)
                let address = dbchain.generateAddress(publickey)

                // 注册
                dbchain.registerNewAccountNumber { (state, msg) in
                    if state {
                        /// 插入数据到用户表
                        print("获取积分成功!!!!")
                        self.insertUserData(mnemonicStr: mnemonicStr,
                                            privatekeyStr: privatekey,
                                            publickeyStr: publickey,
                                            address: address,
                                            nickName: nickName)
                    } else {
                        print("获取积分 失败 !!!")
                        SVProgressHUD.showError(withStatus: "获取积分失败")
                    }
                }
            }

        }.disposed(by: bag)
    }

    /// 插入基本信息到数据表
    private func insertUserData(mnemonicStr: String,
                                privatekeyStr: String,
                                publickeyStr: String,
                                address: String,
                                nickName: String) {
        /// 将用户信息新增到用户表
        let fieldsDic = ["name":nickName,
                         "age":"",
                         "dbchain_key":address,
                         "sex":"",
                         "status":"",
                         "photo":"",
                         "motto":""] as [String : Any]
        dbchain.insertRow(tableName: "user",
                          fields: fieldsDic) { (state) in
            if state == "1" {
                DispatchQueue.main.async {
                    UserDefault.saveCurrentMnemonic(mnemonicStr)
                    UserDefault.saveUserNikeName(nickName)
                    UserDefault.saveAddress(address)
                    UserDefault.savePublickey(privatekeyStr)
                    UserDefault.savePrivateKey(publickeyStr)
                    SVProgressHUD.dismiss()
                    print("注册时昵称: \(nickName) --- \(UserDefault.getUserNikeName())")
                    let vc = HomeViewController.init()
                    let nav = UINavigationController.init(rootViewController: vc)
                    UIApplication.shared.keyWindow?.rootViewController = nav
                }
            } else {
                SVProgressHUD.showError(withStatus: "注册失败")
            }
        }
    }
}
