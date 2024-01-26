//
//  CustomProjectCell.swift
//  Collabo
//
//  Created by tornike <parunashvili on 25.01.24.
//

import UIKit

class CustomProjectCell: UITableViewCell {
    let projectIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let projectNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(projectIconImageView)
        contentView.addSubview(projectNameLabel)
        
        NSLayoutConstraint.activate([
            projectIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            projectIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            projectIconImageView.widthAnchor.constraint(equalToConstant: 24),
            projectIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            projectNameLabel.leadingAnchor.constraint(equalTo: projectIconImageView.trailingAnchor, constant: 10),
            projectNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProjectIcon(_ image: UIImage?) {
        projectIconImageView.image = image
    }
    
    func setProjectName(_ name: String) {
        projectNameLabel.text = name
    }
}

