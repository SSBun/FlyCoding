//
//  UIView+Extension.swift
//  Scaffold
//
//  Created by caishilin on 2022/3/13.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - View Represetnable

public protocol ViewRepresentable {
    var view: UniversalView { get }
}

extension UniversalView: ViewRepresentable {
    public var view: UniversalView { self }
}

/// UniversalView container used to write expressive view layouts.
///
///         VC(self) {
///             View(topBar) {
///                 titleLabel
///                 backBtn
///             }
///             contentView
///             View(bottomBar) {
///                 moreBtn
///             }
///         }
public typealias VC = ViewContainer
public struct ViewContainer: ViewRepresentable {
    public var view: UniversalView
    
    @discardableResult
    public init(
    _ containerView: UniversalView,
    @ArrayBuilder<ViewRepresentable> childrenBuilder: () -> [ViewRepresentable] = { [] }
    ) {
        self.view = containerView
        let subviews = childrenBuilder()
        if let stackView = containerView as? UniversalStackView {
            subviews.map(\.view).forEach {
                if $0.superview != stackView {
                    stackView.addSubview($0)
                }
                stackView.addArrangedSubview($0)
            }
        } else {
            subviews.map(\.view).forEach { containerView.addSubview($0) }
        }
    }
}
