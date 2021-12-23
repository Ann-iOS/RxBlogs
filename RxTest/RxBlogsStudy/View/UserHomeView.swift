//
//  UserHomeView.swift
//  RxTest
//
//  Created by iOS on 2021/12/23.
//

import UIKit

class UserHomeView: UIView {

    let tableView = UITableView.init(frame: CGRect.zero, style: .plain)

    var iconImg = UIImage() {
        didSet {
            iconImgV.image = iconImg
        }
    }

    lazy var iconImgV : UIImageView = {
        let imgv = UIImageView()
        let filePath = documentTools() + "/USERICONPATH"
        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            let fileDic = FileTools.sharedInstance.filePathsWithDirPath(path: filePath)
            do{
                let imageData = try Data(contentsOf: URL.init(fileURLWithPath: fileDic[0]))
                imgv.image = UIImage(data: imageData)!
            }catch{
                imgv.image = UIImage(named: "home_icon_image")
            }
        } else {
            imgv.image = UIImage(named: "home_icon_image")
        }
        return imgv
    }()

    lazy var nikeNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont().themeHNBoldFont(size: 25)
        label.text = "MASIKE"
        return label
    }()

    lazy var signLabel : UILabel = {
        let label = UILabel()
        label.textColor = .colorWithHexString("444444")
        label.font = UIFont().themeHNFont(size: 16)
        label.text = "留下一句座右铭吧~"
        return label
    }()

    lazy var genderImgV : UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage(named: "homepage_gender_female")
        return imgv
    }()

    lazy var headerView : UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 254))
        iconImgV.frame = CGRect(x: SCREEN_WIDTH * 0.5 - 54, y: 40, width: 108, height: 108)
        iconImgV.extSetCornerRadius(54)
        view.addSubViews([iconImgV,nikeNameLabel,signLabel,genderImgV])
        nikeNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImgV.snp.bottom).offset(15)
            make.centerX.equalTo(iconImgV).offset(-12)
        }

        signLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImgV)
            make.top.equalTo(iconImgV.snp.bottom).offset(56)
        }

        genderImgV.snp.makeConstraints { (make) in
            make.centerY.equalTo(nikeNameLabel)
            make.left.equalTo(nikeNameLabel.snp.right).offset(16)
            make.width.height.equalTo(23)
        }

        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "userCellId")
        tableView.backgroundColor = .RGBColor(242)
        tableView.frame = self.bounds
        tableView.rowHeight = 170
        tableView.separatorStyle = .none
        addSubview(tableView)

        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 260)
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configUserInfo(model: userModel) {
        nikeNameLabel.text = model.name
        let motto = model.motto!.isBlank ? "留下一句座右铭吧~" : model.motto
        signLabel.text = motto
        iconImgV.kf.setImage(with: URL(string: dbchain.baseurl! + "ipfs/" + model.photo), placeholder: UIImage(named: "home_icon_image"))
        if model.age == "0" {
            self.genderImgV.image = UIImage(named: "homepage_gender_female")
        } else {
            self.genderImgV.image = UIImage(named: "setting_gender_boy")
        }
    }
}
