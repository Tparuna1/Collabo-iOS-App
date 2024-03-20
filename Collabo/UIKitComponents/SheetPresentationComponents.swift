//
//  CustomTextfield.swift
//  Collabo
//
//  Created by tornike <parunashvili on 20.03.24.
//

import UIKit

///Cutstom label for sheet presentation Controllers

final class CustomLabelForSheetPresentationController: UILabel {
    init(text: String, font: UIFont = UIFont.boldSystemFont(ofSize: 20), textColor: UIColor = .systemCyan, alignment: NSTextAlignment = .center) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

///Cutstom Textfield for sheet presentation Controllers
final class CustomTextFieldForSheetPresentationController: UITextField {
    init(placeholder: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setup(placeholder: placeholder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(placeholder: "")
    }
    
    private func setup(placeholder: String) {
        self.placeholder = placeholder
        borderStyle = .roundedRect
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
    }
}

///Cutstom Button for sheet presentation Controllers
final class CustomButtonFOrSheetPresentationController: UIButton {
    init(title: String, backgroundColor: UIColor = .systemCyan, cornerRadius: CGFloat = 5) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
