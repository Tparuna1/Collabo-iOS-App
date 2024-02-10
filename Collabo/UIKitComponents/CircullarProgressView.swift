//
//  CircullarProgressView.swift
//  Collabo
//
//  Created by tornike <parunashvili on 10.02.24.
//

import UIKit

class CircularProgressView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var percentageLabel = UILabel()
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var progress: Float = 0 {
        didSet {
            var pathMoved = progress - oldValue
            if pathMoved < 0 {
                pathMoved = 0 - pathMoved
            }
            
            setProgress(duration: timeToFill * Double(pathMoved), to: progress)
        }
    }
    
    var timeToFill = 3.43
    var rounded: Bool
    var filled: Bool
    var lineWidth: CGFloat?
    
    override init(frame: CGRect) {
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(frame: frame)
        filled = false
        createProgressView()
        setupPercentageLabel()
    }
    
    required init?(coder: NSCoder) {
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(coder: coder)
        createProgressView()
        setupPercentageLabel()
    }
    
    init(frame: CGRect, lineWidth: CGFloat?, rounded: Bool) {
        progress = 0
        
        if lineWidth == nil {
            self.filled = true
            self.rounded = false
        } else {
            if rounded {
                self.rounded = true
            } else {
                self.rounded = false
            }
            self.filled = false
        }
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        createProgressView()
        setupPercentageLabel()
    }
    
    fileprivate func createProgressView() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = frame.size.width / 2
        let circularPath = UIBezierPath(arcCenter: center, radius: frame.width / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = .none
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = filled ? frame.width : lineWidth!
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = .none
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = filled ? frame.width : lineWidth!
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = rounded ? .round : .butt
        layer.addSublayer(progressLayer)
    }
    
    fileprivate func setupPercentageLabel() {
        percentageLabel.textColor = .white
        percentageLabel.font = UIFont.systemFont(ofSize: 14)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            percentageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            percentageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11)
        ])
    }
    
    func trackColorToProgressColor() {
        trackColor = progressColor
        trackColor = UIColor(red: progressColor.cgColor.components![0], green: progressColor.cgColor.components![1], blue: progressColor.cgColor.components![2], alpha: 0.2)
    }
    
    func setProgress(duration: TimeInterval = 3, to newProgress: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = newProgress
        
        progressLayer.strokeEnd = CGFloat(newProgress)
        progressLayer.add(animation, forKey: "animationProgress")
        
        let percentage = Int(newProgress * 100)
        updatePercentageLabel(to: percentage)
    }
    
    private func updatePercentageLabel(to percentage: Int) {
        percentageLabel.text = "\(percentage)%"
    }
}
