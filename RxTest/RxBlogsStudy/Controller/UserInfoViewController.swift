//
//  UserInfoViewController.swift
//  RxTest
//
//  Created by iOS on 2021/12/23.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class UserInfoViewController: UIViewController {

    @IBOutlet weak var iconImgV: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var sexWomanButton: UIButton!
    @IBOutlet weak var sexManButton: UIButton!
    @IBOutlet weak var ageTextfield: UITextField!
    @IBOutlet weak var mottoTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    let viewModel = UserInfoViewModel()
    var selectSex = 1

    private let navImgV = UIImageView.init(image: UIImage(named: "homepage_nav_image"))
    // MARK: 图片选择器界面
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var selectUploadImage = UIImage() {
        didSet {
            iconImgV.setBackgroundImage(selectUploadImage, for: .normal)
            iconImgV.setBackgroundImage(selectUploadImage, for: .selected)
        }
    }

    var model: userModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary

        self.configNavBar()
        self.configDefaultData()

        viewModel.getUserInformationEvent()
        viewModel.requestUserInfo.onNext(true)
        viewModel.userInfoModels.subscribe { (models) in
            if models.element?.count ?? 0 > 0 {
                let lastModel = models.element!.last
                self.model = lastModel
                self.ageTextfield.text = lastModel!.age
                self.mottoTextField.text = lastModel!.motto
                self.nickNameTextField.text = lastModel!.name

                if lastModel?.photo != nil {
                    self.iconImgV.kf.setBackgroundImage(with: URL(string: dbchain.baseurl! + "ipfs/\(lastModel!.photo)"), for: .normal, placeholder: UIImage(named: "home_icon_image"))
                }

                if lastModel!.sex == "0" {
                    self.selectSex = 0
                    self.sexManButton.backgroundColor = .clear
                    self.sexWomanButton.backgroundColor = .colorWithHexString("#EFEFEF")
                } else {
                    self.selectSex = 1
                    self.sexManButton.backgroundColor = .colorWithHexString("#EFEFEF")
                    self.sexWomanButton.backgroundColor = .clear
                }
            }
        }.disposed(by: self.viewModel.bag)

        /// 性别按钮点击事件
        sexWomanButton.rx.tap.subscribe (onNext: {
            self.selectSex = 0
            self.sexManButton.backgroundColor = .clear
            self.sexWomanButton.backgroundColor = .colorWithHexString("#EFEFEF")
        }).disposed(by: self.viewModel.bag)

        sexManButton.rx.tap.subscribe(onNext: {
            self.selectSex = 1
            self.sexManButton.backgroundColor = .colorWithHexString("#EFEFEF")
            self.sexWomanButton.backgroundColor = .clear
        }).disposed(by: self.viewModel.bag)

        /// 头像选择
        iconImgV.rx.tap.subscribe { _ in
            self.selectIconImageEvent()
        }.disposed(by: self.viewModel.bag)

        /// 保存事件
        saveButton.rx.tap
            .subscribe { _ in
                /// 条件判断
                if self.selectUploadImage.pngData() != nil
                    || self.nickNameTextField.text != self.model?.name
                    || self.selectSex != Int(self.model?.sex ?? "1")
                    || self.ageTextfield.text != self.model?.age
                    || self.mottoTextField.text != self.model?.motto
                {
                    self.viewModel.saveUserInfoEvent(name: self.nickNameTextField.text,
                                                     sex: "\(self.selectSex)",
                                                     age: self.ageTextfield.text,
                                                     motto: self.mottoTextField.text,
                                                     iconImage: self.selectUploadImage)
                    self.viewModel.requestSaveObservable.onNext(true)
                    /// 订阅结果
                    self.viewModel.saveStateObservable.subscribe { (state) in
                        if state.element == 1 {
                            print("成功了  刷新首页的头像! 并返回到上一个页面")
                            NotificationCenter.default.post(name: NSNotification.Name("ModityUserInfoSuccessKey"), object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }.disposed(by: self.viewModel.bag)
                }
            }.disposed(by: self.viewModel.bag)

    }


    func configNavBar() {
        navImgV.frame = CGRect(x: UIScreen.main.bounds.width * 0.5 - 90, y: 20, width: 180, height: 40)
        self.navigationItem.titleView = navImgV
    }

    func configDefaultData() {
        self.nickNameTextField.text = UserDefault.getUserNikeName()!

        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            let fileDic = FileTools.sharedInstance.filePathsWithDirPath(path: filePath)
            do {
                let imageData = try Data(contentsOf: URL.init(fileURLWithPath: fileDic[0]))
                iconImgV.setBackgroundImage(UIImage(data: imageData)!, for: .normal)
            } catch {
                iconImgV.setBackgroundImage(UIImage(named: "home_icon_image"), for: .normal)
            }
        } else {
            iconImgV.setBackgroundImage(UIImage(named: "home_icon_image"), for: .normal)
        }
    }

    func selectIconImageEvent() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil)) // 取消按钮
        controller.addAction(UIAlertAction(title: "拍照选择", style: .default) { action in
            self.selectorSourceType(type: .camera)
        }) // 拍照选择
        controller.addAction(UIAlertAction(title: "相册选择", style: .default) { action in
            self.selectorSourceType(type: .photoLibrary)
        }) // 相册选择
        self.present(controller, animated: true, completion: nil)
    }

    func selectorSourceType(type: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            imagePicker.sourceType = type
            // 打开图片选择器
            present(imagePicker, animated: true, completion: nil)
        } else {
            if type == .camera {
                SVProgressHUD.showError(withStatus: "相机权限未打开")
            } else {
                SVProgressHUD.showError(withStatus: "相册权限未打开")
            }
        }
    }
}


extension UserInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // MARK: - Image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /// 5. 用户选中一张图片时触发这个方法，返回关于选中图片的 info
        /// 6. 获取这张图片中的 originImage 属性，就是图片自己
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("error: did not picked a photo")
        }

        /// 7. 根据须要作其它相关操做，这里选中图片之后关闭 picker controller 便可
        picker.dismiss(animated: true) { [unowned self] in
            // add a image view on self.view
            self.selectUploadImage = selectedImage
        }
    }

      // MARK: 当点击图片选择器中的取消按钮时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
      }
}
