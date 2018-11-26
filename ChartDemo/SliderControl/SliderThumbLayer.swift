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
        ctx.setShadow(offset: CGSize(width: 0, height: 3), blur: 1, color: shadowColor.cgColor)
        
        let path = UIBezierPath(ovalIn: bounds)
        ctx.addPath(path.cgPath)

        ctx.setFillColor(slider.thumbTint.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // 2 ways for fill image
        if let cgImage = slider.thumImage?.cgImage {
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath

            let imageLayer = CALayer()
            imageLayer.frame = bounds
            imageLayer.contents = cgImage
            imageLayer.mask = maskLayer

            addSublayer(imageLayer)
        }
        
//        if let image = slider.thumImage {
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.frame = bounds
//            shapeLayer.path = path.cgPath
//            shapeLayer.fillColor = UIColor(patternImage: image).cgColor
//            addSublayer(shapeLayer)
//        }
    }

}

extension UIImage {
    func applyingClippingBezierPath(_ path: UIBezierPath) -> UIImage! {
        let frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        path.addClip()
        self.draw(in: frame)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return newImage
    }
}
