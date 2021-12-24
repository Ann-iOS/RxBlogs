//
//  LoginView.swift
//  RxTest
//
//  Created by iOS on 2021/12/21.
//

import UIKit

/// 文件管理 沙盒路径  dynamic
let documentTools = FileTools.sharedInstance.docDir
let USERICONPATH = "UserIconPath"

class LoginView: UIView {
    
    var topImgV: UIImageView!
    var centerBackView: UIView!
    var iconImgV: UIImageView!
    var signOut: UIButton!
    var signIn: UIButton!
    var nickNameLabel: UILabel!
    var mnemonicBackView: UIView!
    var mnemonicTipLabel: UILabel!
    var mnemonicLabel: UILabel!

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

        iconImgV = UIImageView.init()
        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            let fileDic = FileTools.sharedInstance.filePathsWithDirPath(path: filePath)
            do {
                let imageData = try Data(contentsOf: URL.init(fileURLWithPath: fileDic[0]))
                iconImgV.image = UIImage(data: imageData)!
            } catch {
                iconImgV.image = UIImage(named: "home_icon_image")
            }
        } else {
            iconImgV.image = UIImage(named: "home_icon_image")
        }
        iconImgV.layer.cornerRadius = 54
        iconImgV.layer.masksToBounds = true
        centerBackView.addSubview(iconImgV)

        signOut = UIButton.init(type: .custom)
        signOut.setImage(UIImage(named: "home_goout_btn_ img"), for: .normal)
        signOut.sizeToFit()
        centerBackView.addSubview(signOut)

        nickNameLabel = UILabel.init()
        nickNameLabel.textAlignment = .center
        nickNameLabel.textColor = .black
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nickNameLabel.text = UserDefault.getUserNikeName() ?? "MASIKE"
        centerBackView.addSubview(nickNameLabel)

        signIn = UIButton.init(type: .custom)
        signIn.setTitle("立即进入", for: .normal)
        signIn.setTitleColor(.white, for: .normal)
        signIn.backgroundColor = .colorWithHexString("#2E44FF")
        signIn.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        signIn.layer.cornerRadius = 20
        signIn.layer.masksToBounds = true
        centerBackView.addSubview(signIn)

        mnemonicBackView = UIView.init()
        mnemonicBackView.backgroundColor = .colorWithHexString("#EFEFEF")
        mnemonicBackView.layer.cornerRadius = 10
        mnemonicBackView.layer.masksToBounds = true
        self.addSubview(mnemonicBackView)

        mnemonicTipLabel = UILabel.init()
        mnemonicTipLabel.text = "当前助记词"
        mnemonicTipLabel.textAlignment = .center
        mnemonicTipLabel.textColor = .black
        mnemonicTipLabel.font = UIFont.systemFont(ofSize: 20)
        mnemonicBackView.addSubview(mnemonicTipLabel)

        mnemonicLabel = UILabel.init()
        mnemonicLabel.textAlignment = .left
        mnemonicLabel.numberOfLines = 0
        mnemonicLabel.textColor = .colorWithHexString("#9E9E9E")
        let mnemonicStr = UserDefault.getCurrentMnemonic()!
        //通过富文本来设置行间距
        let  paraph =  NSMutableParagraphStyle ()
        //行间距设置
        paraph.lineSpacing = 10
        //样式属性集合
        let  attributes = [ NSAttributedString.Key.font : UIFont .systemFont(ofSize: 18),
                            NSAttributedString.Key.paragraphStyle : paraph]
        mnemonicLabel.attributedText =  NSAttributedString (string: mnemonicStr, attributes: attributes)
        mnemonicBackView.addSubview(mnemonicLabel)

        topImgV.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(70)
            make.centerX.equalToSuperview()
        }

        centerBackView.snp.makeConstraints { (make) in
            make.top.equalTo(topImgV.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 76)
            make.height.equalTo(350)
        }

        iconImgV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.height.equalTo(108)
        }

        signOut.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(22)
            make.width.height.equalTo(20)
            make.right.equalToSuperview().offset(-25)
        }

        nickNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImgV.snp.bottom).offset(36)
            make.width.equalToSuperview()
        }

        signIn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(42)
            make.width.equalTo(200)
            make.height.equalTo(64)
        }

        mnemonicBackView.snp.makeConstraints { (make) in
            make.top.equalTo(centerBackView.snp.bottom).offset(54)
            make.centerX.equalToSuperview()
            make.height.equalTo(168)
            make.width.equalTo(UIScreen.main.bounds.width - 60)
        }

        mnemonicTipLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(22)
            make.centerX.equalToSuperview()
        }

        mnemonicLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(56)
            make.left.equalToSuperview().offset(21)
            make.right.equalToSuperview().offset(-21)
            make.height.equalTo(104)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
