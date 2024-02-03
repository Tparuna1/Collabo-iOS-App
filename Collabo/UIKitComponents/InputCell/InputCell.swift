//
//  InputCell.swift
//  Collabo
//
//  Created by tornike <parunashvili on 03.02.24.
//

import UIKit

class SubtaskInputCell: UITableViewCell {
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var inputModel: InputCellModel? {
        didSet {
            textField.placeholder = inputModel?.placeholder
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
