//
//  SliderControl.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/10/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class SliderControl: UIControl {
    
    @IBInspectable var minValue: CGFloat = 0.0 {
        didSet {
            updateLayerFrame()
        }
    }
    
    @IBInspectable var maxValue: CGFloat = 1.0 {
        didSet {
            updateLayerFrame()
        }
    }
    
    @IBInspectable var currentValue: CGFloat = 0.5 {
        didSet {
            updateLayerFrame()
        }
    }
    
    @IBInspectable var minTrack: UIColor = .green {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var maxTrack: UIColor = .lightGray {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbTint: UIColor = .white {
        didSet {
            thumbLayer.setNeedsDisplay()
        }
    }
    
    fileprivate var thumbWidth: CGFloat {
        return self.bounds.height * thumbRatio
    }
    fileprivate let trackRatio: CGFloat = 0.45
    fileprivate let thumbRatio: CGFloat = 0.8
    
    fileprivate let trackLayer = SliderTrackLayer()
    fileprivate let thumbLayer = SliderThumbLayer()
    
    fileprivate var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override var frame: CGRect {
        didSet {
            setup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerFrame()
    }

    fileprivate func setup() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        trackLayer.contentsScale = UIScreen.main.scale
        trackLayer.sliderControl = self
        layer.addSublayer(trackLayer)
        
        thumbLayer.contentsScale = UIScreen.main.scale
        thumbLayer.sliderControl = self
        layer.addSublayer(thumbLayer)
        
        updateLayerFrame()
    }
    
    fileprivate func updateLayerFrame() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let xPosTrack = CGFloat(0.0)
        let trackHeight = bounds.height * trackRatio
        let yPosTrack = (bounds.height - trackHeight) / 2.0
        trackLayer.frame = CGRect(x: xPosTrack, y: yPosTrack, width: bounds.width, height: trackHeight)
        trackLayer.setNeedsDisplay()
        
        let xPosThumb = positionFor(value: currentValue) - thumbWidth / 2.0
        let yPosThumb = (bounds.height - thumbWidth) / 2.0
        thumbLayer.frame = CGRect(x: xPosThumb, y: yPosThumb, width: thumbWidth, height: thumbWidth)
        thumbLayer.setNeedsDisplay()
        CATransaction.commit()
    }
    
    func positionFor(value: CGFloat) -> CGFloat {
        return CGFloat(bounds.width - thumbWidth) * (value - minValue) / (maxValue - minValue) + CGFloat(thumbWidth / 2.0)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        if thumbLayer.frame.contains(previousLocation) {
            thumbLayer.highlighted = true
            return true
        }
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let detalLocation = location.x - previousLocation.x
        let detalValue = (maxValue - minValue) * detalLocation / (bounds.width - thumbWidth)
        
        previousLocation = location
        if thumbLayer.highlighted {
            currentValue += detalValue
            currentValue = boundValue(value: currentValue, lowerValue: minValue, upperValue: maxValue)
        }
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumbLayer.highlighted = false
    }
    
    fileprivate func boundValue(value: CGFloat, lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }

}
