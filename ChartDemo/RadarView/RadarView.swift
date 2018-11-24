//
//  RadarView.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class RadarView: UIView {
    
    @IBInspectable var padding: CGFloat = 16 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var ovalCount: Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var ovalColor: UIColor = .lightGray {
        didSet {
            setNeedsDisplay()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.sublayers?.forEach {
            if $0 is CATextLayer {
                $0.removeFromSuperlayer()
            }
        }
        
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = max(bounds.width, bounds.height) / 2 * 0.7
        
        let width = (radius - padding) / CGFloat(ovalCount)
        for i in 1...ovalCount {
            let subRadius = width * CGFloat(i)
            let path = UIBezierPath(arcCenter: center, radius: subRadius - lineWidth, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            path.lineWidth = 0.5
            ovalColor.setStroke()
            path.stroke()
        }
        
        let angleDifference = 2 * .pi / CGFloat(ovalCount)
        for i in 0..<ovalCount {
            let angle = 3 * .pi / 2 + CGFloat(i) * angleDifference
            let next = pointFor(angle: angle)
            let path = UIBezierPath()
            path.move(to: center)
            path.addLine(to: next)
            path.lineWidth = 0.5
            ovalColor.setStroke()
            path.stroke()
            
            let content = text(with: "Math")
            content.frame = CGRect(x: next.x, y: next.y, width: 40, height: 20)
            self.layer.addSublayer(content)
        }
    }
    
    fileprivate func pointFor(angle: CGFloat) -> CGPoint {
        let radius = max(bounds.width, bounds.height) / 2 - padding
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let xPos = center.x + radius * cos(angle)
        let yPos = center.y + radius * sin(angle)
        return CGPoint(x: xPos, y: yPos)
    }
    
    fileprivate func text(with string: String?) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.foregroundColor = UIColor.red.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .right
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 13
        textLayer.string = string
        return textLayer
    }

}
