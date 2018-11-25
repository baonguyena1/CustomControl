//
//  RoundedImageView.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/25/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

func degreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * CGFloat.pi / 180.0
}

func radiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat.pi
}

@IBDesignable
class RoundedImageView: UIView {
    
    @IBInspectable var image: UIImage? = nil
    @IBInspectable var strokeColor: UIColor = .black
    @IBInspectable var strokeWidth: CGFloat = 20.0
    @IBInspectable var completed: CGFloat = 0.2 {
        willSet {
            self.willChangeValue(forKey: "completed")
        }
        
        didSet {
            if completed < 0 { completed = 0.0 }
            if completed > 1 { completed = 1.0 }
            self.didChangeValue(forKey: "completed")
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if image != nil {
            let radius = max(bounds.width, bounds.height) / 2.0
            let clippingPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            clippingPath.addClip()
            
            image!.draw(in: rect)
        }
        
        if strokeWidth > 0 {
            let radius = max(bounds.width, bounds.height) / 2.0 - strokeWidth / 2.0
            let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
            let startAngle = -CGFloat.pi / 2
            let endAngle = degreesToRadians(-90 + 360 * completed)
            let strokePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            strokeColor.setStroke()
            strokePath.lineWidth = strokeWidth
            strokePath.stroke()
            
        }
    }
}
