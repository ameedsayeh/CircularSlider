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
    
    let plusButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("+", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let minusButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("-", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let valueLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "0.0"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let unitLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "KG"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var progressLayer: CAShapeLayer?
    
    
    let radius = UIScreen.main.bounds.width / 4
    
    // Starting Angle in Radians
    var sliderAngle: CGFloat = -CGFloat.pi / 2
    
    // Plus & Minus Step in degrees
    let step: CGFloat = 0.2
    
    // Slider start and end values
    let interval: [CGFloat] = [20, 200]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#353766")
        
        self.drawSlider()
        self.setupLayout()
        self.addActions()
        self.updateSlider()
    }
    
    private func setupLayout() {
        
        self.view.addSubview(self.circularSlider)
        self.view.addSubview(self.plusButton)
        self.view.addSubview(self.minusButton)
        self.view.addSubview(self.valueLabel)
        self.view.addSubview(self.unitLabel)
        
        let constraints = [
            
            self.plusButton.widthAnchor.constraint(equalToConstant: 40),
            self.plusButton.heightAnchor.constraint(equalToConstant: 40),
            self.plusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.plusButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            
            self.minusButton.widthAnchor.constraint(equalToConstant: 40),
            self.minusButton.heightAnchor.constraint(equalToConstant: 40),
            self.minusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.minusButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            
            self.valueLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.valueLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.unitLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.unitLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -48)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.circularSlider.frame.size = CGSize(width: 40, height: 40)
        var center = self.view.center
        center.y -=  self.radius
        self.circularSlider.center = center
    }
    
    private func drawSlider() {
        
        // Drawing the path
        
        let circlePath = UIBezierPath(arcCenter: view.center, radius: self.radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let circularPathLayer = CAShapeLayer()
        circularPathLayer.path = circlePath.cgPath
        
        circularPathLayer.fillColor = UIColor.clear.cgColor
        circularPathLayer.strokeColor = UIColor(hexString: "#6D7598").cgColor
        
        circularPathLayer.lineWidth = 20.0
        self.view.layer.addSublayer(circularPathLayer)
        
        // Drawing the initial progress
        
        let progressCirclePath = UIBezierPath(arcCenter: view.center, radius: self.radius, startAngle: -CGFloat.pi / 2, endAngle: self.sliderAngle, clockwise: true)
        
        self.progressLayer = CAShapeLayer()
        self.progressLayer?.path = progressCirclePath.cgPath
        
        self.progressLayer?.fillColor = UIColor.clear.cgColor
        self.progressLayer?.strokeColor = UIColor(hexString: "#14D1E0").cgColor
        
        self.progressLayer?.lineWidth = 20.0
        self.progressLayer?.lineCap = .round
        
        self.view.layer.addSublayer(self.progressLayer!)
    }
    
    private func addActions() {
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circularSliderDragged(_:)))
        self.circularSlider.addGestureRecognizer(gestureRecognizer)
        
        self.plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        self.minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
    }
    
    private func updateSlider() {
        
        print(self.sliderAngle * 180 / CGFloat.pi)
        
        let newX = self.view.center.x + (cos(self.sliderAngle) * self.radius)
        let newY = self.view.center.y + (sin(self.sliderAngle) * self.radius)
        
        self.circularSlider.center = CGPoint(
            x: newX,
            y: newY
        )
        
        let progressCirclePath = UIBezierPath(arcCenter: self.view.center, radius: self.radius, startAngle: -CGFloat.pi / 2, endAngle: self.sliderAngle, clockwise: true)
        
        self.progressLayer?.path = progressCirclePath.cgPath
        
        let ratio = ((self.sliderAngle * 180 / CGFloat.pi) + 90) / 360
        let newValue = Double(ratio * (self.interval[1] - self.interval[0]) + self.interval[0]).rounded(toPlaces: 1)
        self.valueLabel.text = "\(newValue)"
    }
    
    @objc func plusButtonPressed() {
        
        self.sliderAngle += self.step * CGFloat.pi / 180
        
        if self.sliderAngle >= (1.5 * CGFloat.pi) {
            
            self.sliderAngle = self.sliderAngle - (2 * CGFloat.pi)
        }
        
        self.updateSlider()
    }
    
    @objc func minusButtonPressed() {
        
        self.sliderAngle -= self.step * CGFloat.pi / 180
        
        if self.sliderAngle < (0.5 * -CGFloat.pi) {
            
            self.sliderAngle = self.sliderAngle + (2 * CGFloat.pi)
        }
        
        self.updateSlider()
    }
    
    @objc func circularSliderDragged(_ gesture: UIPanGestureRecognizer) {
        
        let gesturePoint = gesture.location(in: self.view)
        
        let tangent = (self.view.center.y - gesturePoint.y) / (self.view.center.x - gesturePoint.x)
        
        if tangent.isInfinite {
            
            if gesturePoint.y > self.view.center.y {
                self.sliderAngle = CGFloat.pi / 2
            } else {
                self.sliderAngle = -CGFloat.pi / 2
            }
            
        } else {
            
            var angle = gesturePoint.x < view.center.x ? CGFloat.pi + atan(tangent) : atan(tangent)
            
            var degreesAngle = angle * 180 / CGFloat.pi
            degreesAngle = floor(degreesAngle / 0.2) * 0.2
            angle = degreesAngle * CGFloat.pi / 180
            
            self.sliderAngle = angle
        }
        
        self.updateSlider()
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

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
