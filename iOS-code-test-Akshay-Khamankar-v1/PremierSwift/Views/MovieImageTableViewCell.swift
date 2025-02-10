//
//  Untitled.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import UIKit
import Foundation

final class MovieImageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieImageTableViewCell"
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backdropImageView)
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 11.0/16.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with backdropPath: String?) {
        // Replace with your actual image-loading code.
        backdropImageView.dm_setImage(backdropPath: backdropPath ?? "")
    }
}
