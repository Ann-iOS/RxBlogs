//
//  FyParams.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
class FyBaseParams: NSObject {

    var channel: String {
        return "com.lpf.FyNetWork"
    }

    var vno: Int {
        return 100
    }

    var baseParams: [String: Any]? {
        var tempParams: [String: Any] = [String: Any]()
        tempParams["channel"] = channel
        tempParams["vno"] = vno
        return tempParams
    }

    var allParams: [String: Any]!

}

class FyParams: FyBaseParams {
    init(params: [String: Any]? = [String: Any]()) {
        super.init()
        var tempParams = [String: Any]()

        for param in baseParams ?? [String: Any]() {
            tempParams[param.key] = param.value
        }

        for param in params ?? [String: Any]() {
            tempParams[param.key] = param.value
        }

        allParams = tempParams
    }
}
