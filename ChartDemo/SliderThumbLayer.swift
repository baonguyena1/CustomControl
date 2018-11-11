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
        let shadowColor = UIColor.gray
        ctx.setShadow(offset: CGSize(width: 0, height: 1), blur: 1, color: shadowColor.cgColor)
        let corderRadius = bounds.height / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: corderRadius)
        ctx.setFillColor(slider.thumbTint.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // Stroke
        ctx.setStrokeColor(shadowColor.cgColor)
        ctx.setLineWidth(0.5)
        ctx.addPath(path.cgPath)
        ctx.strokePath()
        
        if highlighted {
            ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
        }
    }

}
