//
//  RxRelay+Extension.swift
//  Scaffold
//
//  Created by caishilin on 2022/3/13.
//

#if canImport(RxRelay)
import RxRelay
import RxSwift

@propertyWrapper
public final class BehaviorRelayVariable<ValueType> {
    
    private var value: ValueType
    
    private let disposeBag = DisposeBag()
    
    public var wrappedValue: ValueType {
        get {
            value
        }
        set {
            set(newValue, notify: true)
        }
    }
    
    public let projectedValue: BehaviorRelay<ValueType>
    
    public init(wrappedValue: ValueType) {
        value = wrappedValue
        projectedValue = BehaviorRelay(value: wrappedValue)
        
        projectedValue.subscribe(onNext: { [weak self] in
            self?.set($0, notify: false)
        }).disposed(by: disposeBag)
    }
    
    private func set(_ newValue: ValueType, notify: Bool) {
        value = newValue
        if notify {
            projectedValue.accept(newValue)
        }
    }
}

#endif
