//
//  BZExtension.swift
//  BZExtension
//
//  Created by caishilin on 2022/3/1.
//

import Foundation

public struct BZ<Base> {
    public let base: Base
    public init(_ base: Base) { self.base = base }
}

public protocol BZCompatible {
    associatedtype Base
    
    var bz: BZ<Base> { get set }
    static var bz: BZ<Base>.Type { get set }
}

public extension BZCompatible {
    var bz: BZ<Self> {
        get { BZ(self) }
        set {}
    }
    
    static var bz: BZ<Self>.Type {
        get { BZ<Self>.self }
        set {}
    }
}
