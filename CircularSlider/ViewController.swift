//
//  ViewController.swift
//  CircularSlider
//
//  Created by Ameed Sayeh on 9/22/20.
//

import UIKit

class ViewController: UIViewController {
    
    let circularSlider: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    var progressLayer: CAShapeLayer?
    var initial = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(hexString: "#353766")
        
        
        // Drawing the path
        
        let circlePath = UIBezierPath(arcCenter: view.center, radius: UIScreen.main.bounds.width / 4, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let circularPathLayer = CAShapeLayer()
        circularPathLayer.path = circlePath.cgPath
        
        circularPathLayer.fillColor = UIColor.clear.cgColor
        circularPathLayer.strokeColor = UIColor(hexString: "#6D7598").cgColor
        
        circularPathLayer.lineWidth = 20.0
        view.layer.addSublayer(circularPathLayer)
        
        // Drawing the initial progress
        
        let progressCirclePath = UIBezierPath(arcCenter: view.center, radius: UIScreen.main.bounds.width / 4, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(Double.pi), clockwise: true)
        
        self.progressLayer = CAShapeLayer()
        progressLayer?.path = progressCirclePath.cgPath
        
        progressLayer?.fillColor = UIColor.clear.cgColor
        progressLayer?.strokeColor = UIColor(hexString: "#14D1E0").cgColor
        
        progressLayer?.lineWidth = 20.0
        progressLayer?.lineCap = .round
        
        view.layer.addSublayer(progressLayer!)
        
        self.view.addSubview(self.circularSlider)
        
        self.circularSlider.frame.size = CGSize(width: 40, height: 40)
        var center = self.view.center
        center.y -=  UIScreen.main.bounds.width / 4
        self.circularSlider.center = center
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circularSliderDragged(_:)))
        self.circularSlider.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circularSliderDragged(_ gesture: UIPanGestureRecognizer) {
        
        guard let gestureView = gesture.view else {
            return
        }
        
        let radius = UIScreen.main.bounds.width / 4
        let gesturePoint = gesture.location(in: view)
        
        let newX = gesturePoint.x
        let newY = gesturePoint.y
        
        let factor: CGFloat
        if newX < view.center.x {
            factor = -1
        } else {
            factor = 1
        }
        
        let tangent = (view.center.y - newY) / (view.center.x - newX)
        if tangent.isInfinite {
            return
        }

        let angle = atan(tangent)
        
        let newXPivot = view.center.x + factor * (cos(angle) * radius)
        let newYPivot = view.center.y + factor * (sin(angle) * radius)
        
        gestureView.center = CGPoint(
            x: newXPivot,
            y: newYPivot
        )
        gesture.setTranslation(.zero, in: view)
        
        let rotatedAngle =  factor * (CGFloat(Double.pi / 2) + factor * angle)
        
        let progressCirclePath = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: CGFloat(-Double.pi/2), endAngle: CGFloat(-Double.pi/2) + rotatedAngle, clockwise: true)
        
        var newPercentage = rotatedAngle / CGFloat(2 * Double.pi)
        if newPercentage < 0  {
            newPercentage = 1 + newPercentage
        }
        print(newPercentage)
        
        self.progressLayer?.path = progressCirclePath.cgPath
    }
    
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
