//
//  HomeTableViewCell.swift
//  RxTest
//
//  Created by iOS on 2021/12/21.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    var backView = UIView()
    var iconImgV = UIImageView()
    var nameLabel = UILabel()
    var readCountImgV = UIImageView()
    var readCount = UILabel()
    var titleLabel = UILabel()
    var detailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.backgroundColor = .colorWithHexString("#F8F8F8")

        backView.backgroundColor = .white
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
        self.contentView.addSubview(backView)

        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        detailLabel.numberOfLines = 4
        detailLabel.textColor = .colorWithHexString("#9E9E9E")
        detailLabel.font = UIFont.systemFont(ofSize: 14)

        iconImgV.image = UIImage(named: "home_temporary_image")
        iconImgV.layer.cornerRadius = 13
        iconImgV.layer.masksToBounds = true

        nameLabel.text = "未知用户"
        nameLabel.textColor = .colorWithHexString("#444444")
        nameLabel.font = UIFont.systemFont(ofSize: 16)

        readCountImgV.image = UIImage(named: "home_file_see_number")
        readCount.text = "100"
        readCount.textColor = .colorWithHexString("#9E9E9E")
        readCount.font = UIFont.systemFont(ofSize: 16)

        backView.addSubview(titleLabel)
        backView.addSubview(detailLabel)
        backView.addSubview(iconImgV)
        backView.addSubview(nameLabel)
        backView.addSubview(readCountImgV)
        backView.addSubview(readCount)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-4)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-22)
        }

        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.width.equalTo(titleLabel)
            make.left.equalTo(titleLabel)
        }

        iconImgV.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(22)
            make.bottom.equalToSuperview().offset(-12)
            make.width.height.equalTo(26)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgV.snp.right).offset(10)
            make.centerY.equalTo(iconImgV)
        }

        readCountImgV.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImgV)
            make.right.equalToSuperview().offset(-64)
            make.width.height.equalTo(16)
        }

        readCount.snp.makeConstraints { (make) in
            make.centerY.equalTo(readCountImgV)
            make.left.equalTo(readCountImgV.snp.right).offset(6)
        }
    }

    public func configCellModel(blogsModel: blogModel){
        self.titleLabel.text = blogsModel.title
        self.detailLabel.text = blogsModel.body
        self.nameLabel.text = blogsModel.name ?? "未知用户"
        self.readCount.text = "\(blogsModel.readNumber ?? 100)"
        if blogsModel.imgUrl != nil, !blogsModel.imgUrl!.isBlank {
            iconImgV.kf.setImage(with: URL(string: dbchain.baseurl! + "ipfs/" + blogsModel.imgUrl!), placeholder: UIImage(named: "home_temporary_image"))
        } else {
            /// 女生头像   home_icon_image    男生头像 :  home_temporary_image
            iconImgV.image = UIImage(named: "home_temporary_image")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
