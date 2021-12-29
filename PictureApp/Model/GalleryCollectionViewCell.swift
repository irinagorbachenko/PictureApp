//
//  GalleryCollectionViewCell.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 26.11.2021.
//
import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    static let identifier = "GalleryCollectionViewCell"
    
    public let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
       
        return imageView
    }()
    
    public let tagsLabel :UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.contentMode = .top
        tagsLabel.clipsToBounds = true
        return tagsLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(tagsLabel)
                
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
}
