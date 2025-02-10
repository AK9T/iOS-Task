//
//  RedCardCollectionViewCell.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import SnapKit
import UIKit
import Foundation

final class RedCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "RedCardCollectionViewCell"
    
    // MARK: - UI Components
    
    /// Outermost vertical stack view that holds the poster image and the detail area.
    private let mainView: UIView = UIView()
    
    
    private var posterImageURL: String = ""
    
    /// Poster image view (the card image) with fixed size.
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    /// Title label.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0  // Allow dynamic height.
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        // Increase vertical compression resistance so it doesn’t collapse.
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    /// Description label.
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 0  // Allow dynamic height.
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        // Increase vertical compression resistance so it doesn’t collapse.
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let ratingContainer: UIView = UIView()

    /// Rating label.
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Star image view.
    private let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        return iv
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup View Hierarchy and Constraints
    
    private func setupView() {
        // Add the main stack view to the cell's contentView.
        contentView.addSubview(mainView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 8.0
        mainView.addSubview(posterImageView)
        posterImageView.layer.cornerRadius = 8.0
        posterImageView.clipsToBounds = true
        mainView.addSubview(titleLabel)
        mainView.addSubview(descriptionLabel)
        
        mainView.addSubview(ratingContainer)
        ratingContainer.addSubview(starImageView)
        ratingContainer.addSubview(ratingLabel)
    }
    
    private func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()  // instead of mainView.snp.bottom
            make.leading.trailing.equalToSuperview() // if you want full width; adjust as needed
            make.height.equalTo(212.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.leading.centerX.equalToSuperview().offset(3.0)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(250)  // Lower priority to allow more flexibility
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6.0)
            make.leading.centerX.equalToSuperview().offset(3.0)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(250)  // Lower priority to allow more flexibility
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        ratingContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10.0)
            make.leading.equalToSuperview().offset(4.0) // Adjust to desired leading space
            make.width.equalTo(60.0) // Fixed width
            make.height.equalTo(32.0)
        }
        
        // Star ImageView constraints
        starImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10) // Leading space inside the container
            make.width.height.equalTo(16) // Maintain size as before
        }

        // Rating Label constraints
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starImageView)
            make.leading.equalTo(starImageView.snp.trailing).offset(4) // Space between star and label
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        
        ratingContainer.backgroundColor = .black
        ratingContainer.layer.cornerRadius = 4.0
        ratingContainer.clipsToBounds = true
    }
        
    // MARK: - Configuration
    func configure(
        rating: Double,
        title: String,
        description: String,
        image: String,
        starImage: UIImage
    ) {
        ratingLabel.text = "\(rating.roundedToOneDecimalPlace)"
        titleLabel.text = title
        descriptionLabel.text = description
        posterImageURL = image
        starImageView.image = starImage
        posterImageView.dm_setImage(posterPath: posterImageURL)
    }
}
