//
//  ImageView+Extension.swift
//  Scaffold
//
//  Created by caishilin on 2022/3/1.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension UniversalImageView: BZCompatible {}
public extension BZ where Base: UniversalImageView {
    
    /// The position of the displayed portion of the image.
    enum Position {
        /// Displays the top or left part of the image.
        case head
        /// Default, displays the center part of the image.
        case center
        /// Displays the bottom or right part of the image.
        case tail
    }
    
    /// Displays part of the image in the image view.
    /// - Parameters:
    ///   - image: Displayed image.
    ///   - position: Rendering position of the image.
    ///   - renderWHRatio: The `width / height` ratio of the image view, can be ignored if the image view's frame has been set.
    func set(
        image: UniversalImage?,
        at position: Position = .center,
        renderWHRatio: CGFloat? = nil
    ) {
        base.image = image
        
        // The position `center` is the default rendering pattern in image views.
        guard let image = image, position != .center else { return }
        
        let imageWHRatio = image.size.width / image.size.height
        var renderWHRatio = renderWHRatio
        
        if renderWHRatio == nil {
            let imageViewSize = base.bounds.size
            if !imageViewSize.width.isZero, !imageViewSize.height.isZero {
                renderWHRatio = imageViewSize.width / imageViewSize.height
            }
        }
        
        guard let renderWHRatio = renderWHRatio else {
            assertionFailure("You must specify the rendering ratio or the image view has valid size.")
            return
        }
        
        guard imageWHRatio != renderWHRatio else { return }
        
#if canImport(UIKit)
        let layer = base.layer
#elseif canImport(AppKit)
        guard let layer = base.layer else { return }
#endif
        
        switch position {
        case .head:
            if imageWHRatio > renderWHRatio {
                let ratio = renderWHRatio / imageWHRatio
                layer.contentsRect = CGRect(
                    x: 0,
                    y: 0,
                    width: ratio,
                    height: 1)
            } else {
                let ratio = imageWHRatio / renderWHRatio
                layer.contentsRect = CGRect(
                    x: 0,
                    y: 0,
                    width: 1,
                    height: ratio)
            }
        case .tail:
            if imageWHRatio > renderWHRatio {
                let ratio = renderWHRatio / imageWHRatio
                layer.contentsRect = CGRect(
                    x: 1 - ratio,
                    y: 0,
                    width: ratio,
                    height: 1)
            } else {
                let ratio = imageWHRatio / renderWHRatio
                layer.contentsRect = CGRect(
                    x: 0,
                    y: 1 - ratio,
                    width: 1,
                    height: ratio)
            }
        case .center:
            break
        }
    }
}



