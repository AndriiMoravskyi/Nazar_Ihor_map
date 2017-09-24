//
//  CircleView.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/16/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class ThermometerView: UIView {
    
    // MARK: - Parameters
    let temperature : Double? = nil
    let shapeLayer = CAShapeLayer()
    private let pi = CGFloat(M_PI)
    
    // MARK: - View Life Cycle
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x:18, y: 75)
        let startAngle: CGFloat = 7 * pi / 4
        let endAngle: CGFloat = 5 * pi / 4
        
        /// thermomether top bulb
        let bulbPath = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width:16, height: 75), cornerRadius: 8)
        UIColor.black.setStroke()
        bulbPath.lineWidth = 2
        bulbPath.stroke()
        
        /// thermomether bottom circle bulb
        let circlePath = UIBezierPath(arcCenter: center,
                                 radius: 12,
                                 startAngle: startAngle,
                                 endAngle: endAngle,
                                 clockwise: true)
        UIColor.black.setStroke()
        circlePath.lineWidth = 2
        circlePath.stroke()
        
        /// thermomether bottom fill bulb
        let circleFillPath = UIBezierPath(arcCenter: center,
                                 radius: 11,
                                 startAngle: startAngle,
                                 endAngle: endAngle,
                                 clockwise: true)
        circleFillPath.move(to: center)
        circleFillPath.lineWidth = 24
        UIColor.blue.setFill()
        circleFillPath.fill()
    }
    
    // MARK: - Extra functions
    /**
     Animates temperature mercury rasing
      - Parameter value: temperature for mercury rising animation
     */
    func animateTemperature(value: Double) {
        /// thermomether temperature rise path
        let fillPath = UIBezierPath()
        fillPath.move(to: CGPoint(x: 18, y: 75))
        fillPath.addLine(to: CGPoint(x: 18, y: 20))
        UIColor.red.setStroke()
        fillPath.lineWidth = 21
        fillPath.stroke()

        self.shapeLayer.path = fillPath.cgPath
        self.shapeLayer.bounds = self.layer.bounds
        self.shapeLayer.strokeColor = #colorLiteral(red: 0.9090855013, green: 0.02552536813, blue: 0, alpha: 1).cgColor
        self.shapeLayer.lineWidth = 15
        self.shapeLayer.lineCap = kCALineJoinRound
        self.shapeLayer.position = CGPoint(x: 45, y:45)
        self.shapeLayer.fillColor = nil
        self.layer.addSublayer(self.shapeLayer)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = fillPath.bounds
        gradientLayer.bounds = self.shapeLayer.bounds
        gradientLayer.position = CGPoint(x: 45, y:45)
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.blue.cgColor, #colorLiteral(red: 0.9090855013, green: 0.02552536813, blue: 0, alpha: 1).cgColor, UIColor.red.cgColor]
        gradientLayer.mask = self.shapeLayer
        self.layer.addSublayer(gradientLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 2
        animation.fromValue = 0
        animation.toValue = (value + 40)/80
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        self.shapeLayer.add(animation, forKey: "strokeEnd")
    }
    
    
}

