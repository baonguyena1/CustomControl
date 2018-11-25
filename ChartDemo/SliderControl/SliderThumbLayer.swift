//
//  SliderThumbLayer.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/11/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class SliderThumbLayer: CALayer {
    
    var highlighted = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak var sliderControl: SliderControl?
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        guard let slider = sliderControl else {
            return
        }
        sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shadowColor = UIColor.gray
        ctx.setShadow(offset: CGSize(width: 0, height: 1), blur: 1, color: shadowColor.cgColor)
        let corderRadius = bounds.height / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: corderRadius)
        ctx.addPath(path.cgPath)
        
        let shape = CAShapeLayer()
        shape.frame = bounds
        shape.path = path.cgPath
        shape.fillColor = slider.thumbTint.cgColor
        addSublayer(shape)
        if let image = slider.thumImage {
            self.contents = image.cgImage
            self.contentsGravity = .center
        }
        masksToBounds = true
    }

}

fileprivate extension UIImage {
    func applyingClippingBezierPath(path: UIBezierPath) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        self.draw(at: .zero)
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return maskedImage
    }
}
