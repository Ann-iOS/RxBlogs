//
//  CreateView.swift
//  RxTest
//
//  Created by iOS on 2021/12/20.
//

import Foundation
import UIKit

class CreateView: UIView {

    var topImgV: UIImageView!
    var centerBackView: UIView!
    var mnemonicBackView: UIView!
    var mnemonicTipLabel: UILabel!
    var mnemonicLabel: UILabel!
    var nameTextField: UITextField!
    var loginButton: UIButton!
    var createrMnemonicButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .colorWithHexString("#F3F3F3")
        topImgV = UIImageView.init(image: UIImage(named: "creat_top_image"), highlightedImage: UIImage(named: "creat_top_image"))
        centerBackView = UIView.init()
        centerBackView.backgroundColor = .white
        centerBackView.layer.cornerRadius = 10
        centerBackView.layer.masksToBounds = true
        addSubview(topImgV)
        addSubview(centerBackView)

        mnemonicBackView = UIView.init()
        mnemonicBackView.backgroundColor = .colorWithHexString("#F8F8F8")
        mnemonicBackView.layer.cornerRadius = 10
        mnemonicBackView.layer.masksToBounds = true
        centerBackView.addSubview(mnemonicBackView)

        mnemonicTipLabel = UILabel.init()
        mnemonicTipLabel.text = "助记词"
        mnemonicTipLabel.textColor = .colorWithHexString("#444444")
        mnemonicTipLabel.textAlignment = .center
        mnemonicTipLabel.font = UIFont.init(name: "Medium", size: 20)
        mnemonicBackView.addSubview(mnemonicTipLabel)

        mnemonicLabel = UILabel.init()
        mnemonicLabel.textColor = .colorWithHexString("#444444")
        mnemonicLabel.font = UIFont.systemFont(ofSize: 20)
        mnemonicLabel.numberOfLines = 0
        let str = "much group during enjoy hen category captain search maze notable toddler build"
        //通过富文本来设置行间距
        let  paraph =  NSMutableParagraphStyle ()
        //将行间距设置为28
        paraph.lineSpacing = 20
        //样式属性集合
        let  attributes = [ NSAttributedString.Key.font : UIFont .systemFont(ofSize: 20),
                            NSAttributedString.Key.paragraphStyle : paraph]
        mnemonicLabel.attributedText =  NSAttributedString (string: str, attributes: attributes)
        mnemonicLabel.textAlignment = .center
        mnemonicBackView.addSubview(mnemonicLabel)

        nameTextField = UITextField.init()
        nameTextField.placeholder = "请输入昵称"
        nameTextField.textAlignment = .center
        nameTextField.textColor = .colorWithHexString("#444444")
        nameTextField.backgroundColor = .colorWithHexString("#F8F8F8")
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.masksToBounds = true
        nameTextField.font = UIFont.boldSystemFont(ofSize: 25)
        centerBackView.addSubview(nameTextField)

        loginButton = UIButton.init()
        loginButton.setTitle("立即进入", for: .normal)
        loginButton.setTitleColor(.white, for: .selected)
        loginButton.setTitleColor(.gray, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginButton.backgroundColor = .colorWithHexString("#2E44FF")

        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        centerBackView.addSubview(loginButton)

        createrMnemonicButton = UIButton.init()
        createrMnemonicButton.setTitle("生成助记词", for: .normal)
        createrMnemonicButton.setTitleColor(.colorWithHexString("#2E44FF"), for: .normal)
        createrMnemonicButton.backgroundColor = .white
        createrMnemonicButton.layer.borderWidth = 1
        createrMnemonicButton.layer.borderColor = UIColor.colorWithHexString("#2E44FF").cgColor
        createrMnemonicButton.layer.cornerRadius = 20
        createrMnemonicButton.layer.masksToBounds = true
        centerBackView.addSubview(createrMnemonicButton)

        topImgV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }

        centerBackView.snp.makeConstraints { (make) in
            make.top.equalTo(topImgV.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 20)
            make.height.equalTo(520)
        }

        mnemonicBackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(35)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 60)
            make.height.equalTo(200)
        }

        mnemonicTipLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
        }

        mnemonicLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mnemonicTipLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 80)
            make.height.equalTo(120)
        }

        nameTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(mnemonicBackView.snp.bottom).offset(12)
            make.width.equalTo(mnemonicBackView.snp.width)
            make.height.equalTo(62)
        }

        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTextField.snp.bottom).offset(22)
            make.width.equalTo(nameTextField)
            make.height.equalTo(64)
        }

        createrMnemonicButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginButton.snp.bottom).offset(22)
            make.width.equalTo(loginButton.snp.width)
            make.height.equalTo(loginButton.snp.height)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
