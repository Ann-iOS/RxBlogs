//
//  FySongResponse.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import HandyJSON

struct Songs: HandyJSON {
    var songs: [Song] = [Song]()
}

struct Song: HandyJSON {
    var id: Int = 0
    var name: String = ""
}
