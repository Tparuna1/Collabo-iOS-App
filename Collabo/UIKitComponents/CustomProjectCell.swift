//
//  CustomProjectCell.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import UIKit

class CustomProjectCell: UITableViewCell {
    let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let projectNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whiteBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(colorView)
        contentView.addSubview(whiteBackgroundView)
        contentView.addSubview(projectNameLabel)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 20),
            
            whiteBackgroundView.leadingAnchor.constraint(equalTo: colorView.trailingAnchor),
            whiteBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            whiteBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            whiteBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            projectNameLabel.leadingAnchor.constraint(equalTo: whiteBackgroundView.leadingAnchor, constant: 10),
            projectNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setColor(_ color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func setProjectName(_ name: String) {
        projectNameLabel.text = name
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 10)
        contentView.frame = contentView.frame.inset(by: padding)
    }
}


