//
//  Circle.swift
//  COIndicatorCircle
//
//  Created by Chris Orcutt on 8/24/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit
import QuartzCore

class COIndicatorCircle: UIView {

    @IBOutlet var view: UIView!

    var radius: Float!
    let thickness: Float = 5
    let foregroundCircleColor: UIColor = UIColor.blackColor()
    let backgroundCircleColor: UIColor = UIColor.whiteColor()
    
    private var backgroundCircleLayer: CAShapeLayer!
    private var foregroundCircleLayer: CAShapeLayer!
    private var backgroundPath: UIBezierPath!
    private var foregroundPath: UIBezierPath!
    
    //MARK: Initialization
    func baseInit() {
        NSBundle.mainBundle().loadNibNamed("COIndicatorCircle", owner: self, options: nil)
        
        if frame.width > frame.height {
            radius = Float(frame.height) / 2.0
        } else {
            radius = Float(frame.width) / 2.0
        }
        
        let x = center.x / 2
        let y = center.y / 2
        let width = radius * 2
        let height = radius * 2
        
        let arcCenter = CGPoint(x: CGFloat(radius), y: CGFloat(radius))
        self.backgroundPath = UIBezierPath(arcCenter: arcCenter, radius: CGFloat(radius - (thickness / 2)), startAngle: 0, endAngle: 2 * pi, clockwise: true)
        self.foregroundPath = UIBezierPath(arcCenter: arcCenter, radius: CGFloat(radius - (thickness / 2)), startAngle: 0, endAngle: 0.83 * 2 * pi, clockwise: true)
        
        self.backgroundCircleLayer = createCircleLayer(view.bounds, path: backgroundPath.CGPath, lineWidth: CGFloat(thickness), strokeColor: backgroundCircleColor.CGColor, fillColor: UIColor.clearColor().CGColor, backgroundColor: UIColor.clearColor().CGColor)
        self.view.layer.addSublayer(backgroundCircleLayer)

        self.foregroundCircleLayer = createCircleLayer(view.bounds, path: foregroundPath.CGPath, lineWidth: CGFloat(thickness), strokeColor: foregroundCircleColor.CGColor, fillColor: UIColor.clearColor().CGColor, backgroundColor: UIColor.clearColor().CGColor)
        self.view.layer.addSublayer(foregroundCircleLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 2.0
        animation.repeatCount = 1.0
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        foregroundCircleLayer.addAnimation(animation, forKey: "foreGroundCircleAnimation")
        
        backgroundColor = UIColor.clearColor()
        self.view.frame = CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height))
        self.view.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        self.addSubview(self.view)
    }
    
    func createCircleLayer(frame: CGRect, path: CGPath, lineWidth: CGFloat, strokeColor: CGColor, fillColor: CGColor, backgroundColor: CGColor) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = frame
        circleLayer.path = path
        circleLayer.lineWidth = lineWidth
        circleLayer.strokeColor = strokeColor
        circleLayer.fillColor = fillColor
        circleLayer.backgroundColor = backgroundColor
        return circleLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseInit()
    }
}
