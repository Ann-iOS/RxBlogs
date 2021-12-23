//
//  ViewController.swift
//  RxTest
//
//  Created by iOS on 2021/12/13.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    let viewModel = MusicListViewModel()
    var tableView: UITableView!
    var label: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

//        tableView = UITableView(frame: self.view.bounds, style: .plain)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
////        tableView.delegate = self
////        tableView.dataSource = self
//        tableView.rowHeight = 50
//        tableView.separatorStyle = .none
//        view.addSubview(tableView)
//
//        /// 绑定数据
//        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: "cellID",cellType: UITableViewCell.self)){_ , music,cell in
//            cell.textLabel?.text = music.name
//            cell.detailTextLabel?.text = music.singer
//        }.disposed(by: disposeBag)
//
//        /// 点击事件
//        tableView.rx.modelSelected(Music.self).subscribe { (music) in
//            print("点击了 \(music)")
//        }.disposed(by: disposeBag)



//        **************   演示例子  *****************  //
//        label = UILabel.init(frame: CGRect(x: 100, y: 100, width: 200, height: 60))
//        label.backgroundColor = .yellow
//        view.addSubview(label)

//        testRx()
//        PublishSubjectRx()
//        BehaviorSubjectRx()
//        ReplaySubjectRx()
//        BehaviorRelayRx()

//     操作符合集
//        bufferRx()
//        windowRx()
//        mapRx()
//        flatMapRx()
//        flatMapLatestRx()
//        concatMapRx()
//        scanRx()
//        groupByRx()

//        过滤操作符
//        filterRx()
//        distinctUntilChangedRx()
//        singleRx()
//        elementAtRx()
//        ignoreElementsRx()
//        takeRx()
//        takeLastRx()
//        skipRx()
//        SampleRx()
//        debounceRx()
//        ambRx()
//        takeWhileRx()
//        takeUntilRx()
//        skipWhileRx()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


///  过滤操作符   filter、take、skip
extension ViewController {

    func filterRx() {
        Observable.of(2,5,41,6,74,11)
            .filter { $0 > 10 }
            .subscribe(onNext: { print("大于10的数:,",$0 )})
            .disposed(by: disposeBag)
    }

    // 过滤连续重复的事件
    func distinctUntilChangedRx() {
        Observable.of(1,2,3,1,1,5,4,4,4)
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }

    /*
     限制只发送一次事件，或者满足条件的第一个事件。
     如果存在有多个事件或者没有事件都会发出一个 error 事件。
     如果只有一个事件，则不会发出 error 事件。
     */
    func singleRx() {
        Observable.of(1,2,3,4)
            .single { $0 == 2 }
            .subscribe(onNext: { print($0)})
            .disposed(by: disposeBag)

        Observable.of(1,2,3,5)
            .single()
            .subscribe(onNext: {print( $0 )})
            .disposed(by: disposeBag)
    }

    // 该方法实现只处理在指定位置的事件。
    func elementAtRx() {
        // 只打印 第2位
        Observable.of(1,2,3,4,5)
            .element(at: 2)
            .subscribe(onNext: { print($0) } )
            .disposed(by: disposeBag)
    }

    // 该操作符可以忽略掉所有的元素，只发出 error 或 completed 事件。
    // 如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符。
    func ignoreElementsRx() {
        Observable.of(1,23,3,4,4)
            .ignoreElements()
            .subscribe{ print( "hehehhehe",$0 ) }
            .disposed(by: disposeBag)
    }

    // 该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed
    func takeRx() {
        Observable.of(1,2,3,4)
            .take(3)
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)
    }

    // 该方法实现仅发送 Observable 序列中的后 n 个事件。
    func takeLastRx() {
        Observable.of(1,2,3,4)
            .takeLast(3)
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)
    }

    // 该方法用于跳过源 Observable 序列发出的前 n 个事件
    func skipRx(){
        Observable.of(1,2,3,4)
            .skip(2)
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)
    }

    // Sample 除了订阅源 Observable 外，还可以监视另外一个 Observable， 即 notifier
    // 每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
    func SampleRx() {
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()

        source
            .sample(notifier)
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)

        source.onNext(1)

        /// 让源序列 接收消息
        notifier.onNext("A")

        source.onNext(2)

        /// 让源序列 接收消息
        notifier.onNext("B")
        notifier.onNext("C")

        source.onNext(11)
        source.onNext(22)
        source.onNext(3)
        source.onNext(4)

        /// 让源序列 接收消息
        notifier.onNext("D")

        source.onNext(16)
        source.onNext(17)
        source.onNext(18)
        source.onNext(5)

        notifier.onNext("E")
        source.onNext(6)

        notifier.onCompleted()
    }

    //  用来过滤掉高频产生的元素
    func debounceRx() {
        //定义好每个事件里的值以及发送的时间
        let items = [
            ["value":1,"time":0.1],
            ["value":2,"time":1.1],
            ["value":3,"time":1.2],
            ["value":4,"time":1.2],
            ["value":5,"time":1.3],
            ["value":6,"time":2.1]
        ]

        // delay: 设定延迟多少时间发出Observable的每个元素
        // delaySubscription: 设定多少时间延迟订阅Observable
        Observable.from(items)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(.milliseconds(Int(item["time"]! * 1000)),
                                       scheduler: MainScheduler.instance)
            }.debounce(.milliseconds(500), scheduler: MainScheduler.instance)  //只发出与下一个间隔超过0.5秒的元素
            .subscribe(onNext: { print( "value:",$0 ) } )
            .disposed(by: disposeBag)
    }

    //当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
    func ambRx() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()

        subject1
            .amb(subject2)
            .amb(subject3)
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)
        //第一个订阅的是 subject2 只会打印出 subject2的元素  其余不会输出
        subject2.onNext(2)   // 打印 2
        subject1.onNext(20)
        subject2.onNext(2)   // 打印 2
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)   // 打印 3
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
    }

    //该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
    func takeWhileRx() {
        Observable.of(1,2,5,3,4)
            // <= 4  只会输出 1 和 2. 在遍历到 5时. 不满足条件. 便自动结束
            .take(while: { $0 <= 4 })
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)
    }

    // 除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier
    // 如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件
    func takeUntilRx() {

        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()

        source
            .take(until: notifier)
            .subscribe(onNext: { print( $0 ) } )
            .disposed(by: disposeBag)

        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")

        /// 源序列停止接收消息
//        notifier.onCompleted()
        notifier.onNext("z")

        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
    }

    // https://www.hangge.com/blog/cache/detail_1948.html
    // 跳过前面所有满足条件的.  一旦遇到第一个满足条件的之后 便不再进行跳过操作.
    func skipWhileRx() {
        Observable.of(1,2,3,4,5,6,7,1,2,3,4)
            .skip(while: { $0 < 4 })
            .subscribe(onNext: {print($0)})
            .disposed(by: disposeBag)
    }



}






// 变换操作符  buffer、map、flatMap、scan concatMap groupBy
extension ViewController {

    // buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
    //该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
    func bufferRx(){
        let subject = PublishSubject<String>()
        /// 每缓存 3个 元素 则组合起来 一起发出.
        /// 如果一秒内 不够 3个. 也会发出.  ( 有几个发几个,.  一个都没有的话. 发空数组)
        subject
            .buffer(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        subject.onNext("d")

        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")

        subject.onNext("4")
    }


    //window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
    //同时 buffer 要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列
    func windowRx() {
        let subject = PublishSubject<String>()

        //  每3个元素作为一个子Observable发出。 不足 3个时, 有几个发几个.
        subject.window(timeSpan: .seconds(1), count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
//                print("subject: \($0)")
                NSLog("subject:\($0)")
                $0.asObservable()
                    .subscribe(onNext: {
//                        print($0)
                        NSLog("\($0)")
                    }).disposed(by: self!.disposeBag)

            }).disposed(by: disposeBag)

//        subject.onNext("a")
//        subject.onNext("b")
//        subject.onNext("c")
//
//        subject.onNext("1")
//        subject.onNext("2")
//        subject.onNext("3")
    }

    //该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
    func mapRx() {
        Observable.of(1,2,3)
            .map { $0 * 10}
            .subscribe(onNext: { print( $0 ) })
            .disposed(by: disposeBag)
    }

    // map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列
    // 而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
    // 这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
    func flatMapRx() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")

        let variable = BehaviorRelay(value: subject1)

        variable.asObservable()
            .flatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject1.onNext("B")
        variable.accept(subject2)

        subject2.onNext("2")
        subject1.onNext("C")

        subject2.onNext("3")
        subject1.onNext("D")
    }


    // flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件。
    // flatMapFirst 与 flatMapLatest 正好相反：flatMapFirst 只会接收最初的 value 事件
    func flatMapLatestRx() {
       // 将上例中的 flatMap 改为 flatMapLatest
        let subject1 = BehaviorSubject(value: "A")
//        let subject2 = BehaviorSubject(value: "1")

        let variable = BehaviorRelay(value: subject1)

        variable.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject1.onNext("B")
//        variable.accept(subject2)

//        subject2.onNext("2")
        subject1.onNext("C")

//        subject2.onNext("3")
        subject1.onNext("D")
    }


    /*
     concatMap 与 flatMap 的唯一区别是：
     当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。
     或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅
     */
    func concatMapRx() {
        /** A, B, C, 2  */
        // 先打印 subject1 订阅的数据后, 才打印 subject2 订阅的数据
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")

//        let variable = BehaviorSubject(value: subject1)
        let variable = BehaviorRelay(value: subject1)

        variable.asObservable()
            .concatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)

        subject1.onNext("B")
        variable.accept(subject2)
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
    }

    // scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
    func scanRx() {
        Observable.of(1,2,3,4,5)
            .scan(2) { (acum, elem) in
                acum + elem
            }.subscribe(onNext: {print( $0 )})
            .disposed(by: disposeBag)
    }


    // 将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来
    func groupByRx() {
        /// 将 奇偶数 分成两组
//        Observable<Int>.of(1,6,5,8,2,3,8,55,02,04,36,7)
//            .groupBy { (element) -> String in
//                return element % 2 == 0 ? "偶数" : "奇数"
//            }.subscribe(onNext: { print( "打印: ",$0 )})
//            .disposed(by: disposeBag)

        /*
         打印结果:
         打印:  GroupedObservable<String, Int>(key: "奇数", source: RxSwift.(unknown context at $108880a78).GroupedObservableImpl<Swift.Int>)
         打印:  GroupedObservable<String, Int>(key: "偶数", source: RxSwift.(unknown context at $108880a78).GroupedObservableImpl<Swift.Int>)
         */


        // 例子 二
        Observable<Int>.of(1,6,5,8)
            .groupBy { (element) -> String in
                return element % 2 == 0 ? "偶数" : "奇数"
            }.subscribe { [weak self] event in
                switch event {
                    case .next(let group):
                        group.asObservable().subscribe({ event in
                            print(" key: \(group.key)   event: \(event)")
                        })
                        .disposed(by: self!.disposeBag)
                default:
                    print("kong")
                }
            }.disposed(by: disposeBag)

        /*
         打印结果:
         key: 奇数   event: next(1)
         key: 偶数   event: next(6)
         key: 奇数   event: next(5)
         key: 偶数   event: next(8)
         key: 偶数   event: completed
         key: 奇数   event: completed
        kong

         */

        /// 例子三
//        Observable<Int>.of(1,6,5,8)
//            .groupBy { (element) -> String in
//                return element % 2 == 0 ? "偶数" : "奇数"
//            }.subscribe(onNext: { group in
//                group.asObservable().subscribe { event in
//                    print("key: \(group.key)    event: \( event)")
//                }.disposed(by: self.disposeBag)
//            }).disposed(by: disposeBag)


        /*
         打印结果:
         key: 奇数    event: next(1)
         key: 偶数    event: next(6)
         key: 奇数    event: next(5)
         key: 偶数    event: next(8)
         key: 奇数    event: completed
         key: 偶数    event: completed
         */

    }

}


// ***************
// 各种订阅者的区别**
// ***************
extension ViewController {

    // PublishSubject、BehaviorSubject、ReplaySubject、Variable
    // 开始订阅后才会接收数据,在被订阅前发送的数据将不会被接收
    func PublishSubjectRx() {

        let subject = PublishSubject<String>()

        subject.onNext("1111")
        // 第一次订阅
        subject.subscribe { (str) in
            print("第一次订阅",str)
        } onCompleted: {
            print("第一次订阅:completed")
        }.disposed(by: disposeBag)

        // 当前已有一个订阅, 该条信息会输出
        subject.onNext("2222")

        // 第二次订阅
        subject.subscribe { (str) in
            print("第二次订阅",str)
        } onCompleted: {
            print("第二次订阅:completed")
        }.disposed(by: disposeBag)

        // 当前已有两个订阅, 该信息同样会输出
        subject.onNext("33333")

        // 结束
        subject.onCompleted()

        /// 该条信息不会输出
        subject.onNext("444444")

//      subject 结束后.只会执行 completed ,
//        subject.subscribe { (str) in
//            print("第三次订阅",str)
//        }onCompleted: {
//            print("第三次订阅:completed")
//        }.disposed(by: disposeBag)
//
//        subject.onNext("5555")
    }


    // BehaviorSubject 当有订阅者订阅时, 会立即收到上一个发出的事件. 初始化的 value 会被接收.
    // 发生 error 事件后,. 再次订阅时. 只能接收 error 事件.   33333 不会被接收打印.
    func BehaviorSubjectRx() {
        let subject = BehaviorSubject(value: "1111")
        /// 第一次订阅
        subject.subscribe{ event in
            print("第 1次订阅:", event)
        }.disposed(by: disposeBag)

        /// 发送 next 事件
        subject.onNext("22222")

        /// 发送error 事件
        subject.onError(NSError(domain: "local, Error", code: 0, userInfo: nil))

        /// 第二次订阅
        subject.subscribe { event in
            print("第 2次订阅:", event)
        }.disposed(by: disposeBag)

        /// 再次发送 next 事件
        subject.onNext("333333")
    }


    // 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数
    /*
     比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个 .next 的 event。
     如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event 外，还会收到那个终结的 .error 或者 .complete 的 event。
     */
    func ReplaySubjectRx() {
        /// 2 个 缓存
        let subject = ReplaySubject<String>.create(bufferSize: 2)

        /// 连续发送 3个 next 事件
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")

        /// 第一次订阅
        subject.subscribe { event in
            print("第 1 次订阅:",event)
        }.disposed(by: disposeBag)

        /// 再发送一个 next
        subject.onNext("444")

        /// 第二次订阅
        subject.subscribe { event in
            print("第 2 次订阅",event)
        }.disposed(by: disposeBag)

        /// 结束
        subject.onCompleted()

        /// 第 三 次订阅
        subject.subscribe { event in
            print("第 3 次订阅",event)
        }.disposed(by: disposeBag)

        /// 不会被接收和打印 .
        subject.onNext("55555")

        /// 再次订阅 也只会打印 333 444, completed
        subject.subscribe { event in
            print("第 4 次订阅:",event)
        }.disposed(by: disposeBag)

    }


    // 我们通过这个属性可以获取最新值。而通过它的 accept() 方法可以对值进行修改。
    // 与 BehaviorSubject 不同的是，不需要也不能手动给 BehaviorReply 发送 completed 或者 error 事件来结束它（BehaviorRelay 会在销毁时也不会自动发送 .complete 的 event）。
    func BehaviorRelayRx() {
//        简单示例
//        let subject = BehaviorRelay<String>(value: "1111")
//        /// 改变 Value 的值
//        subject.accept("222")
//
//        /// 第一次订阅
//        subject.subscribe { event in
//            print("第一次订阅:",event)
//        }.disposed(by: disposeBag)
//
//
////        subject.asObservable().subscribe {
////            print("订阅订阅:",$0)
////        }.disposed(by: disposeBag)
//
//        /// 再次修改 value 值
//        subject.accept("333")
//
//        subject.subscribe { event in
//            print("第二次订阅:",event)
//        }.disposed(by: disposeBag)
//
////        subject.asObservable().subscribe {
////            print("订阅22222:",$0)
////        }.disposed(by: disposeBag)
//
//        /// 修改 value 值
//        subject.accept("4444")


        /// 常用在列表上拉加载功能上，BehaviorRelay 用来保存所有加载到的数据
        let subject = BehaviorRelay<[String]>(value: ["A"])

        /// 修改 添加值
        subject.accept(subject.value + ["B","C"])

        // 订阅
        subject.subscribe { event in
            print("第一次订阅:",event)
        }.disposed(by: disposeBag)

        // 修改
        subject.accept(subject.value + ["D","E","F"])

        subject.subscribe { event in
            print("第二次订阅:",event)
        }.disposed(by: disposeBag)

        /// 再次 修改
        subject.accept(subject.value + ["G","H","I","J","K"])

        subject.asObservable().subscribe {
            print("第三次订阅:",$0)
        }.disposed(by: disposeBag)
    }



// ****************************
// observable 和 observer 实例**
// ****************************
    func testRx() {
//        let observable = Observable<String>.create { (observer) -> Disposable in
//            observer.onNext("测试打印咯!")
//            observer.onCompleted()
//            return Disposables.create()
//        }
//
//        observable.subscribe { item in
////            print($0)
//            print(item)
//        }

//        let ob = Observable.of("AAA","BBB","CCC")
//        ob.subscribe { (item) in
//            print(item)
//        }

//        let range = Observable.range(start: 1, count: 3)
//        range.subscribe { (item) in
//            print(item)
//        }

        /// generate 条件判断
//        let generate = Observable.generate(initialState: 0, condition: {
//            $0 <= 10
//        }, iterate: {
//            $0 + 2
//        })
//        generate.subscribe { (item) in
//            print(item)
//        }

        // deferred
//        var isOdd = true
//        //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
//        let factory : Observable<Int> = Observable.deferred {
//            //让每次执行这个block时候都会让奇、偶数进行交替
//            isOdd = !isOdd
//            //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
//            if isOdd {
//                return Observable.of(1,3,5,7)
//            } else {
//                return Observable.of(2,4,6,8)
//            }
//        }

//        /// 第一次订阅
//        factory.subscribe { (event) in
//            print("\(isOdd)",event)
//        }
//        /// 第二次订阅
//        factory.subscribe { (event) in
//            print("\(isOdd)",event)
//        }


//        interval() 方法  类似于定时器. 定时发送
//        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//
//        interval.subscribe { (event) in
//            print(event)
//        }


//        timer() 方法 ,  延迟执行
//        5秒种后发出唯一的一个元素0
//        let timer = Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
//        timer.subscribe { (event) in
//            print(event)
//        }

        /// 延迟 5 秒后, 每一秒产生一个元素, 总共三个元素
//        let ob1 =  Observable<Int>.timer(.seconds(3), period: .seconds(5), scheduler: MainScheduler.instance)
//
//        ob1.subscribe { (event) in
//            print(event)
//        }


        /// 绑定Label. 定义观察者
        let observer: Binder<String> = Binder(label) { (view, text) in
            view.text = text
        }

        /// Observable 序列    每一秒 发出一个索引值
        let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

        observable
            .map{ "当前索引值 \($0)" }
            .bind(to: observer)
            .disposed(by: disposeBag)
    }




}


/// 直接 对 Label 进行扩展
/*
 label.text = "123"
 /// Observable 序列    每一秒 发出一个索引值
 let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

 observable
     .map{ CGFloat($0) }
     // 根据索引值不断变大放大字体
     .bind(to: label.fontSize)
     .disposed(by: disposeBag)
 */

//extension UILabel {
//    public var fontSize: Binder<CGFloat> {
//        return Binder(self) { label, fontSize in
//            label.font = UIFont.systemFont(ofSize: fontSize)
//        }
//    }
//}





// 扩展 Reactive . 条件是当 Base 控件为 UILabel 或者 label 子类时, 绑定属性时要 写成 label.rx.fontSize
/*

 label.text = "123"
 /// Observable 序列    每一秒 发出一个索引值
 let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

 observable
     .map{ CGFloat($0) }
     // 根据索引值不断变大放大字体
     .bind(to: label.rx.fontSize)
     .disposed(by: disposeBag)

 */
extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label,fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}






//extension ViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
//        if cell == nil {
//            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cellID")
//        }
//        cell!.selectionStyle = .none
//        let model = viewModel.data[indexPath.row]
//        cell?.textLabel?.text = model.name
//        cell?.detailTextLabel?.text = model.singer
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//}
//
//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("点击的信息:\(viewModel.data[indexPath.row])")
//    }
//}
