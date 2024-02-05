//
//  SheetPresentationController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import UIKit

class SheetPresentationController: UIPresentationController {
    private let presentedHeightFraction: CGFloat
    private let cornerRadius: CGFloat = 16.0
    private var blurEffectView: UIVisualEffectView?
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentedHeightFraction: CGFloat = 0.30) {
        self.presentedHeightFraction = presentedHeightFraction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupBlurView()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        if let containerView = containerView {
            let height = containerView.bounds.height * presentedHeightFraction
            return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
        }
        return CGRect.zero
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let presentedView = presentedView {
            presentedView.layer.cornerRadius = cornerRadius
            presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            presentedView.clipsToBounds = true
            
            let lineView = UIView()
            lineView.backgroundColor = UIColor.gray
            lineView.translatesAutoresizingMaskIntoConstraints = false
            presentedView.addSubview(lineView)
            
            NSLayoutConstraint.activate([
                lineView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: 8),
                lineView.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor),
                lineView.widthAnchor.constraint(equalToConstant: 48),
                lineView.heightAnchor.constraint(equalToConstant: 2)
            ])
        }
        
        if let containerView = containerView {
            containerView.insertSubview(blurEffectView!, at: 0)
            blurEffectView?.frame = containerView.bounds
        }
    }
    
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .light)
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
