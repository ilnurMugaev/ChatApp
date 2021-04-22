//
//  ImageCell.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 22.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let iView = UIImageView()
        iView.translatesAutoresizingMaskIntoConstraints = false
        iView.contentMode = .scaleAspectFill
        iView.clipsToBounds = true
        iView.image = UIImage(named: "noPhoto")
        return iView
    }()
    
    private var cellModel: ImageCellModelProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpFirstLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "noPhoto")
    }
    
    func initModel(cellModel: ImageCellModelProtocol) {
        self.cellModel = cellModel
    }
    
    func setUpFirstLayer() {
        contentView.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func configure(urlString: String) {
        guard let cellModel = cellModel else { return }
        cellModel.loadPhoto(urlString: urlString) { (image) in
            guard let image = image else { return }
            self.imageView.image = image
        }        
    }
}
