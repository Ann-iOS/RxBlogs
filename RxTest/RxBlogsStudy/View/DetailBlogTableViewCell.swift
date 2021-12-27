//
//  DetailBlogTableViewCell.swift
//  RxTest
//
//  Created by iOS on 2021/12/27.
//

import UIKit

class DetailBlogTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contenTitleLabel: UILabel!

    static let identifier = "BlogDetailCellID"

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.iconImgV.contentMode = .scaleAspectFill
        self.iconImgV.extSetCornerRadius(24)
        self.contenTitleLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configModel(model: replyDiscussModel) {
        self.iconImgV.kf.setImage(with: URL(string: dbchain.baseurl! + "ipfs/" + model.imageIndex), placeholder: UIImage(named: "home_icon_image"))
        if !model.nickName.isBlank {
            nameLabel.text = model.nickName + " 回复 " + model.replyNickName
        } else {
            nameLabel.text = "未知用户"
        }
        contenTitleLabel.text = model.text
    }

}
