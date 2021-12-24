//
//  CreateViewController.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import DBChainKit

/// 初始化DBChainKit
let dbchain = DBChainKit.init(appcode: "GGPJWXRSC6",
                              chainid: "testnet02",
                              baseurl: "https://controlpanel.dbchain.cloud/relay02/",
                              encryptType: Sm2())

class CreateViewController: UIViewController {

    var createdView: CreateView!
    let viewModel = CreatedViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        createdView = CreateView.init(frame: self.view.bounds)
        view.addSubview(createdView)

        /// 昵称输入框设定
        createdView.nameTextField.rx.text.orEmpty.map {
            $0.count >= 2
        }.share(replay: 1)
        .subscribe(onNext: { [weak self] bool in
            guard let mySelf = self else {return}
            mySelf.createdView.loginButton.isEnabled = bool
            mySelf.createdView.loginButton.isSelected = bool
            mySelf.createdView.loginButton.backgroundColor = bool == true ? .colorWithHexString("#2E44FF") : .colorWithHexString("#F8F8F8")
        }).disposed(by: self.viewModel.bag)

        // 登录按钮
        createdView.loginButton.rx.tap.subscribe(onNext: { [self] in
            /// viewModel  赋值
            viewModel.requestRegister(mnemonicStr: createdView.mnemonicLabel.text!,
                                      nickName: createdView.nameTextField.text!)
            viewModel.requestCommond.onNext(true)
        }).disposed(by: self.viewModel.bag)

        /// 生成助记词
        createdView.createrMnemonicButton.rx.tap.subscribe(onNext: { [self] in
            createdView.mnemonicLabel.text = dbchain.createMnemonic()
        }).disposed(by: self.viewModel.bag)

    }
}
