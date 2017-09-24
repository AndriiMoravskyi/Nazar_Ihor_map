//
//  GradientView.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/16/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {
    
    // MARK: - View Life Cycle
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = [UIColor.purple.cgColor,UIColor.blue.cgColor, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor , UIColor.white.cgColor, UIColor.yellow.cgColor,UIColor.orange.cgColor, UIColor.red.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
}
