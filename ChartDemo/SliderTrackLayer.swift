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
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        guard let slider = sliderControl else {
            return
        }
        
        let current = slider.positionFor(value: slider.currentValue)
        // Corner radius
        let cornerRadius = bounds.height / 2.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: current, y: 0))
        path.addLine(to: CGPoint(x: bounds.width - cornerRadius, y: 0))
        path.addArc(withCenter: CGPoint(x: bounds.width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: -.pi/2, endAngle: .pi/2, clockwise: true)
        path.addLine(to: CGPoint(x: current, y: bounds.height))
        path.addLine(to: CGPoint(x: current, y: 0.0))
        
        ctx.addPath(path.cgPath)
        
        // Fill color
        ctx.setFillColor(slider.maxTrack.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // Draw zizac
        let itemWidth = bounds.width / 5.0
        let triangle = CGFloat(5)
        let numberOfItem = Int(current/itemWidth)
        let zizacPath = UIBezierPath()
        zizacPath.move(to: CGPoint(x: cornerRadius, y: 0))
        if numberOfItem > 0 {
            for i in 1...numberOfItem {
                let xPos = itemWidth * CGFloat(i)
                zizacPath.addLine(to: CGPoint(x: xPos - triangle/2, y: 0))
                zizacPath.addLine(to: CGPoint(x: xPos, y: triangle))
                zizacPath.addLine(to: CGPoint(x: xPos + triangle/2, y: 0))
            }
        }
        zizacPath.addLine(to: CGPoint(x: current, y: 0))
        zizacPath.addLine(to: CGPoint(x: current, y: bounds.height))
        if numberOfItem > 0 {
            for i in (1...numberOfItem).reversed() {
                let xPos = itemWidth * CGFloat(i)
                zizacPath.addLine(to: CGPoint(x: xPos + triangle/2, y: bounds.height))
                zizacPath.addLine(to: CGPoint(x: xPos, y: bounds.height - triangle))
                zizacPath.addLine(to: CGPoint(x: xPos - triangle/2, y: bounds.height))
            }            
        }
        zizacPath.addLine(to: CGPoint(x: cornerRadius, y: bounds.height))
        zizacPath.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: 3*CGFloat.pi/2, endAngle: .pi/2, clockwise: false)
        ctx.addPath(zizacPath.cgPath)
        
        ctx.setFillColor(slider.minTrack.cgColor)
        ctx.addPath(zizacPath.cgPath)
        ctx.fillPath()
        
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = zizacPath.cgPath
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [#colorLiteral(red: 0.9882352941, green: 0.3098039216, blue: 0.03137254902, alpha: 1).cgColor, #colorLiteral(red: 0.9803921569, green: 0.9137254902, blue: 0.8705882353, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.mask = mask
//        self.addSublayer(gradientLayer)
        
    }

}
