//
//  UserInfoViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/24.
//

import Foundation
import RxSwift
import RxCocoa
import SVProgressHUD

class UserInfoViewModel {

    let bag = DisposeBag()
    let userInfoModels = BehaviorRelay(value: [userModel]())
    let saveStateObservable = BehaviorRelay(value: 0)

    let requestUserInfo = PublishSubject<Bool>()
    let requestSaveObservable = PublishSubject<Bool>()

    func getUserInformationEvent() {
        requestUserInfo.subscribe { _ in
            SVProgressHUD.show()
            dbchain.queryDataByCondition("user",
                                         ["dbchain_key":UserDefault.getAddress()!]) { [weak self] (jsonStr) in
                guard let mySelf = self else {return}
                guard let umodel = BaseUserModel.init(JSONString: jsonStr), umodel.result!.count > 0 else {
                    SVProgressHUD.showError(withStatus: "请求用户信息失败")
                    return
                }
                SVProgressHUD.dismiss()
                mySelf.userInfoModels.accept(umodel.result!)
            }
        }.disposed(by: bag)
    }

    /// 保存事件
    func saveUserInfoEvent(name: String?,
                           sex: String,
                           age: String?,
                           motto: String?,
                           iconImage: UIImage?) {
        requestSaveObservable.subscribe { _ in
            SVProgressHUD.show()
            var imageCid = ""
            if iconImage?.pngData() != nil {
                /// 先上传头像
                dbchain.uploadfile(filename: "file",
                                   fileData: iconImage!.compressImage()) { (state) in
                    print("上传头像 返回 cid state: \(state)")
                    imageCid = state
                    self.saveIconImageLocal(iconImg: iconImage!)
                    UserDefault.saveUserNikeName(name!)
                    self.uploadUserInformationEvent(name: name, sex: sex, age: age, motto: motto, cid: imageCid)
                }
            } else {
                self.uploadUserInformationEvent(name: name, sex: sex, age: age, motto: motto, cid: imageCid)
            }
        }.disposed(by: bag)
    }

    private func uploadUserInformationEvent(name: String?,
                                            sex: String,
                                            age: String?,
                                            motto: String?,
                                            cid: String?){
        let dic: [String: Any] = ["name":name ?? "",
                                  "sex":sex,
                                  "age":age ?? "",
                                  "dbchain_key": UserDefault.getAddress()!,
                                  "motto":motto ?? "",
                                  "photo":cid ?? ""]
        dbchain.insertRow(tableName: "user",
                          fields: dic) { (result) in
            if result == "1" {
                self.saveStateObservable.accept(1)
                SVProgressHUD.showSuccess(withStatus: "保存成功")
            } else {
                self.saveStateObservable.accept(0)
                SVProgressHUD.showError(withStatus: "保存失败")
            }
        }
    }

    /// 保存图片在本地
    private func saveIconImageLocal(iconImg: UIImage) {
        /// 将头像保存到本地

        let imageData = iconImg.pngData()!

        /// 创建文件并保存
        if FileTools.sharedInstance.isFileExisted(fileName: USERICONPATH, path: filePath) == true {
            /// 该文件已存在
            // 删除
            let _ = FileTools.sharedInstance.deleteFile(fileName: USERICONPATH, path: filePath)
        } else {
            /// 重新创建目录 文件夹 缓存数据
            let _ = FileTools.sharedInstance.createDirectory(path:filePath)
        }

        /// 创建文件并保存
        if FileTools.sharedInstance.isFileExisted(path: filePath) {
            let saveFileStatus = FileTools.sharedInstance.createFile(fileName: USERICONPATH, path: filePath, contents:imageData, attributes: nil)
            if saveFileStatus == true {
                print("图片保存成功")
            } else {
                print("图片保存失败")
            }
        }
    }
}
