//
//  PublishView.swift
//  RxTest
//
//  Created by iOS on 2021/12/22.
//

import UIKit
import RxCocoa
import RxSwift

class PublishView: UIView {

    lazy var titleTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = .colorWithHexString("EFEFEF")
        tf.extSetCornerRadius(10)
        tf.font = UIFont.ThemeFont.H3Medium
        tf.textColor = .black
        tf.setValue(18, forKey: "paddingLeft")
        tf.placeholder = "    请输入标题"
        tf.leftViewMode = .always
        return tf
    }()

    lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.text = "正文"
        label.textColor = .black
        label.font = UIFont.ThemeFont.H2Medium
        return label
    }()

    lazy var contenTextView : UITextView = {
        let view = UITextView()
        view.backgroundColor = .colorWithHexString("EFEFEF")
//        view.delegate = self
        view.textColor = .colorWithHexString("444444")
        view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.extSetCornerRadius(10)
        return view
    }()

    lazy var placeholderLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.text = "请输入博客正文"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    lazy var bottomImageV : UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "creat_top_image")
        return imgV
    }()

    lazy var saveBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .colorWithHexString("2E44FF")
        btn.extSetCornerRadius(20)
        btn.setImage(UIImage(named: "save_write_blog"), for: .normal)
        btn.setImage(UIImage(named: "save_write_blog"), for: .selected)
        btn.setImage(UIImage(named: "save_write_blog"), for: .highlighted)
        return btn
    }()

    let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleTextField.frame = CGRect(x: 16, y: 20 + kNavBarAndStatusBarHeight, width: SCREEN_WIDTH - 32, height: 52)
        tipLabel.frame = CGRect(x: 16, y: titleTextField.frame.maxY + 30, width: 100, height: 24)
        contenTextView.frame = CGRect(x: 16, y: tipLabel.frame.maxY + 14, width: SCREEN_WIDTH - 32, height: SCREEN_HEIGHT - kNavAndTabHeight - 140 - 80)
        placeholderLabel.frame = CGRect(x: 26, y: 19, width: 200, height: 20)
        contenTextView.addSubview(placeholderLabel)
        bottomImageV.frame = CGRect(x: 16, y: contenTextView.frame.maxY + 10, width: 137, height: 30)
        saveBtn.frame = CGRect(x: SCREEN_WIDTH - 95, y: contenTextView.frame.maxY - 20, width: 64, height: 64)
        self.addSubViews([titleTextField,tipLabel,contenTextView,bottomImageV,saveBtn])

        contenTextView.rx.text.distinctUntilChanged().subscribe(onNext: { [weak self] str in
            guard let mySelf = self else {return}
            //获取文本内容
            if str!.count > 0 {
                mySelf.placeholderLabel.isHidden = true
             } else {
                mySelf.placeholderLabel.isHidden = false
             }
            //通过富文本来设置行间距
            let paraph = NSMutableParagraphStyle()
            //将行间距设置为28
            paraph.lineSpacing = 20
            //样式属性集合
             let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),
                               NSAttributedString.Key.paragraphStyle: paraph]
            mySelf.contenTextView.attributedText = NSAttributedString(string: str!, attributes: attributes)
        }).disposed(by: bag)

        let titleVaild = titleTextField.rx.text.orEmpty.map {
            $0.count >= 1
        }.share(replay: 1)

        let bodyVaild = contenTextView.rx.text.orEmpty.map {
            $0.count >= 1
        }.share(replay: 1)

        /// 按钮绑定输入框的状态
        Observable.combineLatest(titleVaild, bodyVaild) { $0 && $1 }
            .bind(to: saveBtn.rx.isEnabled)
            .disposed(by: bag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
