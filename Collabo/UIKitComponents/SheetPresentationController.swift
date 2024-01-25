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
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentedHeightFraction: CGFloat = 0.30) {
        self.presentedHeightFraction = presentedHeightFraction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect.zero
        }
        let height = containerView.bounds.height * presentedHeightFraction
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let presentedView = presentedView {
            presentedView.layer.cornerRadius = cornerRadius
            presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            presentedView.clipsToBounds = true
        }
    }
}
