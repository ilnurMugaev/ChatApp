//
//  AvatarView.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 19.03.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let initialsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUpSubviews()
    }
    
    func setUpSubviews() {
        self.addSubview(imageView)
        self.addSubview(initialsLabel)
        
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        initialsLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        initialsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        initialsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        initialsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func configure(image: UIImage? = nil, name: String? = nil, fontSize: CGFloat = 0, cornerRadius: CGFloat = 0) {
        imageView.layer.cornerRadius = cornerRadius
        
        if let image = image {
            imageView.isHidden = false
            initialsLabel.isHidden = true
            imageView.image = image
        } else if let name = name, !name.isEmpty {
            
            imageView.isHidden = true
            initialsLabel.isHidden = false
            let userInitials: String = {
                let nameComponents = name.capitalized.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
                let userInitials = nameComponents.reduce("") { ($0 == "" ? "" : "\($0.first ?? Character(" "))") + "\($1.first ?? Character(" "))" }
                return userInitials.trimmingCharacters(in: .whitespacesAndNewlines)
            }()
            initialsLabel.text = userInitials
            initialsLabel.font = UIFont.systemFont(ofSize: fontSize)
        } else {
            imageView.isHidden = true
            initialsLabel.isHidden = true
        }
    }
}
