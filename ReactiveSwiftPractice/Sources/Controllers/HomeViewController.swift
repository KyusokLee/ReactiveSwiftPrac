//
//  ViewController.swift
//  ReactiveSwiftPractice
//
//  Created by Kyus'lee on 2024/03/26.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

// Life Cycle and Variables
class HomeViewController: UIViewController {
    
    // Property: 監視可能なボックスで、値を保持する。保持している値に変更があれば、Observerに通知する。初期値やSignal, SignalProducer, または他のPropertyのいずれかを通して、初期化できる
    
    // MutableProperty: 監視可能なボックス。Propertyと異なり、保持した値を直接変更することが可能
    // また、BindingTargetProviderに準拠しているので、Signal, SignalProducer, Propertyからバインディング演算子(<~)を使うことで、値を更新すことが可能
    
    
    
    
//    let dataList = Property.combineLatest(PropertyOne, PropertyTwo, PropertyThree).map {
//      dataOne, dataTwo, dataThree -> (resultOne: [NewType], resultTwo: Int64)? in
//        guard let contentsOne = dataOne?.contents else { return nil }
//        guard let selectedDataThree = dataThree, dataThree.hasSampleContent else { return nil }
//        guard let selectedDataThreeID = dataThree.contentID else { return nil }
//        return (contentsOne.flatMap { contentOne -> [NewType] in
//          let isActive = dataTwo.contains { $0 == contentOne.name }
//          let content = contentOne.content.isEmpty ? [.contentEmpty] : contentOne.content
//          .map {
//            NewType.init(content: $0, contentID: selectedDataThreeID ...)
//          }
//          return [
//            [NewType.sample(.init(name: contentOne.name, count: contentOne.count, ...))], isActive ? content : []
//          ].flatMap { $0 }
//        }, selectedDataThreeID)
//    }
    
    @IBOutlet weak var practiceTextField: UITextField!
    @IBOutlet weak var practiceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpController()
    }
}

// Functions and Logics
extension HomeViewController {
    func setUpController() {
        createTextFieldSignal()
    }
    
    func createTextFieldSignal() {
        // Signalを監視する
        // <Bool, NoError>型のObserverだから、<Bool, NoError>型のSignalあるいはSignalProducerからの値を受け取ることができる
        // Observerが定義できたら、Observerで監視を開始しよう
        let observer = Signal<Bool, Never>.Observer{ [weak self] value in
            self?.practiceButton.isEnabled = value ?? false
            print("Button State: \(self?.practiceButton.state)")
        }
        
        // isEnabledが有効になっているかがわからない
        
        // TextFieldの入力を監視
        // Optional<String>を排出する
        let textFieldSignal = practiceTextField.reactive.continuousTextValues
        
        // signalを変換する
        // Bool型の値を排出するSignalに変換
        let transformedSignal = textFieldSignal.map { $0.count >= 10 }
        
        // Signalの監視を解除する
        // observeはDisposable型のインスタンスを返す
        // 監視を解除するために返す
        let disposable = transformedSignal.observe(observer)
        
        // Scopeを制限
        disposable?.dispose()
    }
}
