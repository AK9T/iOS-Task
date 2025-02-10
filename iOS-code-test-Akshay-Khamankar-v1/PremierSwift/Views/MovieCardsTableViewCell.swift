//
//  MovieCardsTableViewCell.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

final class MovieCardsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieCardsTableViewCell"
    private var cardData: [SimilarMovieDetailsResult] = []  // Assuming 'CardModel' holds your card data
    
    // A fixed number of red cards. Adjust as needed.
    private let cardCount = 1
    
    // Create a collection view with a horizontal flow layout.
    private lazy var collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           layout.itemSize = CGSize(width: 144, height: 340)
           layout.minimumLineSpacing = 3
           layout.minimumInteritemSpacing = 3
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.backgroundColor = .clear
           collectionView.showsHorizontalScrollIndicator = false
           collectionView.dataSource = self
           collectionView.delegate = self
           collectionView.register(RedCardCollectionViewCell.self, forCellWithReuseIdentifier: RedCardCollectionViewCell.reuseIdentifier)
           return collectionView
       }()
    
    // Reference to the height constraint
    private var collectionViewHeightConstraint: Constraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           contentView.addSubview(collectionView)
           collectionView.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(8)
               make.left.right.equalToSuperview().inset(8)
               make.bottom.equalToSuperview().offset(-8)
               self.collectionViewHeightConstraint = make.height.equalTo(300).priority(.low).constraint  // Initially set an estimated height
           }
       }
    
    /// "" **Added This Getter**
      var exposedCollectionView: UICollectionView {
          return collectionView
      }
    
    func configure(similarMovies: [SimilarMovieDetailsResult]) {
           self.cardData = similarMovies
       }
    
    private func updateCollectionViewHeight() {
          let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
          collectionViewHeightConstraint?.update(offset: contentHeight)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
           super.layoutSubviews()
           // Update the height constraint based on the content size of the collection view
           let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
           collectionViewHeightConstraint?.update(offset: contentHeight)
       }
}

extension MovieCardsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cardModel = cardData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RedCardCollectionViewCell.reuseIdentifier, for: indexPath) as! RedCardCollectionViewCell
        
        // Configure the cell if needed.
        
        cell.configure(
            rating: cardModel.voteAverage ?? 0.0,
            title: cardModel.title ?? "",
            description: cardModel.releaseDate ?? "",
            image: cardModel.posterPath ?? "",
            starImage: UIImage(named: "Star")!
        )
        return cell
    }
}
