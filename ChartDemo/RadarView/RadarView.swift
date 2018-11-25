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
    
    @IBInspectable var lineWidth: CGFloat = 0.5 {
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
    
    @IBInspectable var shapeColor: UIColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 0.4) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var datasources: [Int] = [4, 5, 3, 4, 5] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var attributes: [String] = ["Hello", "What", "Is", "Your", "Name"] {
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
        let radius = min(bounds.width, bounds.height) / 2 * 0.7
        
        let radiusPerOval = (radius - padding) / CGFloat(ovalCount)
        let anglePerOval = 2 * .pi / CGFloat(ovalCount)
        
        // Draw oval
        for i in 1...ovalCount {
            let subRadius = radiusPerOval * CGFloat(i)
            let path = UIBezierPath(arcCenter: center, radius: subRadius - lineWidth, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            path.lineWidth = lineWidth
            ovalColor.setStroke()
            path.stroke()
        }
        
        // Draw axis
        for i in 0..<ovalCount {
            let angle = 3 * .pi / 2 + CGFloat(i) * anglePerOval
            let radius = max(bounds.width, bounds.height) / 2 - padding
            let next = pointFor(angle: angle, radius: radius)
            let path = UIBezierPath()
            path.move(to: center)
            path.addLine(to: next)
            path.lineWidth = lineWidth
            ovalColor.setStroke()
            path.stroke()
        }
        
        // Draw text
        if attributes.count == ovalCount {
            
            let radius = max(bounds.width, bounds.height) / 2 - padding
            
            for i in 0..<ovalCount {
                let angle = 3 * .pi / 2 + CGFloat(i) * anglePerOval
                let pointOnEdge = pointFor(angle: angle, radius: radius)
                let width: CGFloat = 40.0
                let height: CGFloat = 22.0
                let xOffset = pointOnEdge.x >= center.x ? width/2.0 : -width/2.0
                let yOffset = pointOnEdge.y >= center.y ? height / 2.0 : -height / 2.0
                let textCenter = CGPoint(x: pointOnEdge.x + xOffset, y: pointOnEdge.y + yOffset)
                let text = self.text(with: attributes[i])
                text.frame = CGRect(x: textCenter.x - width / 2.0, y: textCenter.y - height / 2.0, width: width, height: height)
                layer.addSublayer(text)
            }
        }
        
        if datasources.count == ovalCount {
            
            let shapePath = UIBezierPath()
            for i in 0..<ovalCount {
                
                let radius = radiusPerOval * CGFloat(datasources[i])
                let angle = 3 * .pi / 2 + CGFloat(i) * anglePerOval
                let point = pointFor(angle: angle, radius: radius)
                if i == 0 {
                    shapePath.move(to: point)
                } else {
                    shapePath.addLine(to: point)
                }
            }
            shapePath.lineWidth = lineWidth
            shapeColor.setFill()
            shapePath.fill()
        }
    }
    
    fileprivate func pointFor(angle: CGFloat, radius: CGFloat) -> CGPoint {
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let xPos = center.x + radius * cos(angle)
        let yPos = center.y + radius * sin(angle)
        return CGPoint(x: xPos, y: yPos)
    }
    
    fileprivate func text(with string: String?) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.foregroundColor = UIColor.red.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.truncationMode = .end
        textLayer.isWrapped = true
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = 12
        textLayer.string = string
        return textLayer
    }

}
