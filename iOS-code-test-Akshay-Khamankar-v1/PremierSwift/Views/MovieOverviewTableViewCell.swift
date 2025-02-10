//
//  MovieOverviewTableViewCell.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import UIKit
import Foundation

final class MovieOverviewTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieOverviewTableViewCell"
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Body.small         // Assumes you have this custom font extension.
        label.textColor = UIColor.Text.grey      // Assumes custom color definitions.
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with overview: String) {
        overviewLabel.text = overview
    }
}
