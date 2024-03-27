//
//  SheetPresentationController.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import UIKit

/// Custom UIPresentationController for presenting a view controller as a sheet.
class SheetPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    
    private let presentedHeightFraction: CGFloat
    private let cornerRadius: CGFloat = 24
    private var blurEffectView: UIVisualEffectView?
    private var dismissButtonSize: CGFloat = 32
    
    // MARK: - Initializers
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentedHeightFraction: CGFloat = 0.30) {
        self.presentedHeightFraction = presentedHeightFraction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupBlurView()
    }
    
    // MARK: - UIPresentationController Overrides
    
    override var frameOfPresentedViewInContainerView: CGRect {
        if let containerView = containerView {
            let height = containerView.bounds.height * presentedHeightFraction
            return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
        }
        return CGRect.zero
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let containerView = containerView {
            let overlayView = UIView(frame: containerView.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.insertSubview(overlayView, at: 0)
            
            if let presentedView = presentedView {
                presentedView.backgroundColor = UIColor(hex: "f2f4f7")
                presentedView.alpha = 0.0
                presentedView.layer.cornerRadius = cornerRadius
                presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                presentedView.clipsToBounds = true
                
                let lineView = UIView()
                lineView.backgroundColor = UIColor.gray
                lineView.translatesAutoresizingMaskIntoConstraints = false
                presentedView.addSubview(lineView)
                
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 48, weight: .bold, scale: .large)
                let dismissButtonImage = UIImage(systemName: "x.circle.fill", withConfiguration: largeConfig)

                let dismissButton = UIButton(type: .custom)
                dismissButton.translatesAutoresizingMaskIntoConstraints = false
                dismissButton.setImage(dismissButtonImage, for: .normal)
                dismissButton.tintColor = UIColor.red
                dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
                presentedView.addSubview(dismissButton)

                NSLayoutConstraint.activate([
                    dismissButton.widthAnchor.constraint(equalToConstant: dismissButtonSize),
                    dismissButton.heightAnchor.constraint(equalToConstant: dismissButtonSize),
                    dismissButton.leadingAnchor.constraint(equalTo: presentedView.leadingAnchor, constant: 8),
                    dismissButton.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: 8)
                ])
                
                UIView.animate(withDuration: 0.2) {
                    presentedView.alpha = 1.0
                }
            }
            
            UIView.animate(withDuration: 0.1) {
                overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView?.alpha = 0.8
    }
    
    @objc private func dismissButtonTapped() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Background Color Extension

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


