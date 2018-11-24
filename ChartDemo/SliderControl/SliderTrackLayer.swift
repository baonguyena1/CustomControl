//
//  SliderTrackLayer.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/11/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class SliderTrackLayer: CALayer {
    
    weak var sliderControl: SliderControl?
    
    fileprivate let triangleHeight = CGFloat(5)
    
    fileprivate lazy var triangleWidth = {
       return 2 * triangleHeight / sqrt(3.0)
    }()
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        guard let slider = sliderControl else {
            return
        }
        sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let zizazPath = self.zizazPath()
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = zizazPath.cgPath

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = zizazPath.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9882352941, green: 0.3098039216, blue: 0.03137254902, alpha: 1).cgColor, #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1).cgColor, #colorLiteral(red: 0.9803921569, green: 0.9137254902, blue: 0.8705882353, alpha: 1).cgColor, #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1).cgColor]
        gradientLayer.locations = [0, 0.4, 0.6, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = mask
        addSublayer(gradientLayer)
        
        //------------------------------------------------------//
        
        let path = self.rightPath()
        let rightLayer = CAShapeLayer()
        rightLayer.frame = bounds
        rightLayer.path = path.cgPath
        rightLayer.fillColor = slider.maxTrack.cgColor
        addSublayer(rightLayer)
    }

    fileprivate func zizazPath() -> UIBezierPath {
        guard let slider = self.sliderControl else {
            return UIBezierPath()
        }
        let radius = bounds.height / 2.0
        // Draw ziza
        let itemWidth = bounds.width / CGFloat(slider.segmentNumber)
        
        let zizazPath = UIBezierPath()
        
        zizazPath.move(to: CGPoint(x: radius, y: 0))
        if slider.segmentNumber > 1 {
            for i in 1...(slider.segmentNumber - 1) {
                let xPos = itemWidth * CGFloat(i)
                zizazPath.addLine(to: CGPoint(x: xPos - triangleWidth/2, y: 0))
                zizazPath.addLine(to: CGPoint(x: xPos, y: triangleHeight))
                zizazPath.addLine(to: CGPoint(x: xPos + triangleWidth/2, y: 0))
            }
        }
        zizazPath.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
        zizazPath.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        
        if slider.segmentNumber > 1 {
            for i in (1...(slider.segmentNumber - 1)).reversed() {
                let xPos = itemWidth * CGFloat(i)
                zizazPath.addLine(to: CGPoint(x: xPos + triangleWidth/2, y: bounds.height))
                zizazPath.addLine(to: CGPoint(x: xPos, y: bounds.height - triangleHeight))
                zizazPath.addLine(to: CGPoint(x: xPos - triangleWidth/2, y: bounds.height))
            }            
        }
        zizazPath.addLine(to: CGPoint(x: radius, y: bounds.height))
        zizazPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 3*CGFloat.pi/2, endAngle: .pi/2, clockwise: false)
        return zizazPath
    }
    
    fileprivate func rightPath() -> UIBezierPath {
        guard let slider = self.sliderControl else {
            return UIBezierPath()
        }
        let radius = bounds.height / 2.0
        let itemWidth = bounds.width / CGFloat(slider.segmentNumber)
        
        let currentPosition = slider.positionFor(value: slider.currentValue)
        let startIndex = Int(ceilf(Float(currentPosition / itemWidth)))
        let endIndex = slider.segmentNumber - 1
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: currentPosition, y: 0))
        if startIndex <= endIndex {
            for i in startIndex...endIndex {
                let xPos = itemWidth * CGFloat(i)
                path.addLine(to: CGPoint(x: xPos - triangleWidth/2, y: 0))
                path.addLine(to: CGPoint(x: xPos, y: triangleHeight))
                path.addLine(to: CGPoint(x: xPos + triangleWidth/2, y: 0))
            }
        }
        
        path.addLine(to: CGPoint(x: bounds.width - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: bounds.width - radius, y: radius), radius: radius, startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        
        if startIndex <= endIndex {
            for i in (startIndex...endIndex).reversed() {
                let xPos = itemWidth * CGFloat(i)
                path.addLine(to: CGPoint(x: xPos + triangleWidth/2, y: bounds.height))
                path.addLine(to: CGPoint(x: xPos, y: bounds.height - triangleHeight))
                path.addLine(to: CGPoint(x: xPos - triangleWidth/2, y: bounds.height))
            }
        }
        path.addLine(to: CGPoint(x: currentPosition, y: bounds.height))
        path.addLine(to: CGPoint(x: currentPosition, y: 0.0))
        return path
    }
}
