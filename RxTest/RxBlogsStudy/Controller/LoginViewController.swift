//
//  LoginViewController.swift
//  RxTest
//
//  Created by iOS on 2021/11/12.
//

import UIKit
import RxSwift
import RxCocoa


let filePath = documentTools() + "/USERICONPATH"

class LoginViewController: UIViewController {
    var loginView: LoginView!
    let ViewM = LoginViewModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        loginView = LoginView.init(frame: self.view.bounds)
        view.addSubview(loginView)

        ViewM.startLogin()

        loginView.signOut.rx.tap.subscribe { [self] (event) in
            ViewM.signout()
        }.disposed(by: self.ViewM.bag)

        loginView.signIn.rx.tap.subscribe(onNext: { [self] in
            ViewM.requestLogin.onNext(true)
        }).disposed(by: self.ViewM.bag)
    }
}
