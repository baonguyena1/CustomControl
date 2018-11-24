//
//  LineChart.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/9/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class LineChart: UIView {
    
    @IBInspectable var bottomSpace: CGFloat = 40.0
    @IBInspectable var topSpace: CGFloat = 40.0
    @IBInspectable var leadingSpace: CGFloat = 40.0
    @IBInspectable var trailingSpace: CGFloat = 40.0
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    fileprivate var mainLayer = CALayer()
    fileprivate var scrollView = UIScrollView()
    
    fileprivate let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    fileprivate let levels = ["", "A1", "A2", "B1", "B2", ">B2"]
    
    var datas: [BarEntry]? = nil {
        didSet {
            
            drawChart()
        }
    }
    
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
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        drawChart()
    }
    
    fileprivate func setup() {
        scrollView.layer.addSublayer(mainLayer)
        self.addSubview(scrollView)
    }
    
    fileprivate func drawChart() {
        mainLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        drawGirdView()
        drawBottomBar()
        drawLeadingBar()
        drawLine()
        drawBar()
    }
    
    fileprivate func removeCAShapeLayer() {
        self.layer.sublayers?.forEach {
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    fileprivate func drawHorizontalLines() {
        for i in 0..<levels.count {
            let xPos = leadingSpace
            let yPos = (self.frame.size.height - bottomSpace - topSpace) / CGFloat(levels.count - 1) * CGFloat(i) + topSpace
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: self.frame.size.width - trailingSpace, y: yPos))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            lineLayer.lineWidth = 0.5
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }
    
    fileprivate func drawVerticalLines() {
        for i in 0..<months.count + 1 {
            let xPos = (self.frame.size.width - leadingSpace - trailingSpace) / CGFloat(months.count) * CGFloat(i) + leadingSpace
            let yPos = topSpace
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: xPos, y: self.frame.size.height - bottomSpace))
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.strokeColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
            lineLayer.lineWidth = 0.5
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }
    
    fileprivate func drawGirdView() {
        removeCAShapeLayer()
        drawHorizontalLines()
        drawVerticalLines()
    }
    
    fileprivate func drawBottomBar() {
        for i in 0..<months.count {
            let width = (self.frame.size.width - leadingSpace - trailingSpace) / CGFloat(months.count)
            let xPos = width * CGFloat(i) + leadingSpace
            let yPos = self.frame.size.height - bottomSpace + 2.0
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: 22)
            textLayer.foregroundColor = UIColor.red.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = .center
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 14
            textLayer.string = months[i]
            mainLayer.addSublayer(textLayer)
        }
    }
    
    fileprivate func drawLeadingBar() {
        for i in 0..<levels.count {
            let xPos =  CGFloat(0.0) - 2.0
            let height = (self.frame.size.height - bottomSpace - topSpace) / CGFloat(levels.count - 1)
            let yPos = height * CGFloat(levels.count - i - 1) - 22.0 / 2 + topSpace
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: xPos, y: yPos, width: leadingSpace, height: 22)
            textLayer.foregroundColor = UIColor.red.cgColor
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.alignmentMode = .right
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
            textLayer.fontSize = 14
            textLayer.string = levels[i]
            mainLayer.addSublayer(textLayer)
        }
    }
    
    fileprivate func drawLine() {
        guard let datas = datas else {
            return
        }
        for i in 0..<datas.count - 1 {
            let point1 = datas[i]
            let point2 = datas[i+1]
            let width = (self.frame.size.width - leadingSpace - trailingSpace) / CGFloat(months.count)
            let xPos1 = width * CGFloat(point1.month - 1) + leadingSpace + width/2.0
            let yPos1 = (self.frame.size.height - bottomSpace - topSpace) / CGFloat(levels.count - 1) * CGFloat(levels.count-point1.level) + topSpace
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos1, y: yPos1))
            
            let xPos2 = width * CGFloat(point2.month - 1) + leadingSpace + width/2.0
            let yPos2 = (self.frame.size.height - bottomSpace - topSpace) / CGFloat(levels.count - 1) * CGFloat(levels.count-point2.level) + topSpace
            path.addLine(to: CGPoint(x: xPos2, y: yPos2))
            
            let lineShape = CAShapeLayer()
            lineShape.path = path.cgPath
            lineShape.lineWidth = lineWidth
            lineShape.strokeColor = point1.color.cgColor
            mainLayer.addSublayer(lineShape)
        }
    }
    
    fileprivate func drawBar() {
        guard let datas = datas else {
            return
        }
        for item in datas {
            let month = item.month
            let index = item.level
            let width = (self.frame.size.width - leadingSpace - trailingSpace) / CGFloat(months.count)
            let xPos = width * CGFloat(month - 1) + leadingSpace + width/2.0 - 10.0/2
            let yPos = (self.frame.size.height - bottomSpace - topSpace) / CGFloat(levels.count - 1) * CGFloat(levels.count-index) + topSpace - 10.0/2
            let path = UIBezierPath(ovalIn: CGRect(x: xPos, y: yPos, width: 10, height: 10))
            let shape = CAShapeLayer()
            shape.path = path.cgPath
            shape.fillColor = item.color.cgColor
            mainLayer.addSublayer(shape)
        }
    }
    
    fileprivate func translateHeightValueToYPosition(value: CGFloat) -> CGFloat {
        return 0
    }
}
