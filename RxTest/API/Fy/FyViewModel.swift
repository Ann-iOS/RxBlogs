//
//  FyViewModel.swift
//  RxTest
//
//  Created by iOS on 2021/12/15.
//

import Foundation
import RxSwift

class FyViewModel: NSObject {

    var dispose = DisposeBag()
    public typealias NetworkResultClosure = (_ names: String) -> Void

    func fetcgMusicListData(keyword: String, networkResultClosure:@escaping NetworkResultClosure) {

        _ =  FyRequest.request.searchSongs(keyword: keyword).subscribe(onSuccess: { (result) in
            switch result {
            case.regular(let songsInfo):
                var name:String = ""
                for song in songsInfo.songs{
                    name = name + "\n" + song.name
                }
                networkResultClosure(name)
            case .failing( _):
                break
            }
        }) { (error) in
            print(error)
        }.disposed(by: dispose)
    }

}
