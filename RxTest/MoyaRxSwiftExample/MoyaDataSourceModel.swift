import RxDataSources

struct MoyaDataSourceModel {
    var header: String?
    var items: [Post]
}

extension MoyaDataSourceModel : SectionModelType {

    typealias Item = Post
    init(original: MoyaDataSourceModel, items: [Post]) {
        self = original
        self.items = items
    }
}
