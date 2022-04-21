//
//  Array+BZ.swift
//  BZExtension
//
//  Created by caishilin on 2022/3/13.
//

import Foundation

@resultBuilder
public struct ArrayBuilder<Expression> {
    public typealias Component = [Expression]
    
    public static func buildExpression(_ element: Expression) -> Component {
        return [element]
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else { return [] }
        return component
    }
    
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        return Array(components.joined())
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        return Array(components.joined())
    }
}
