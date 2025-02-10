//
//  Utility.swift
//  PremierSwift
//
//  Created by Akshay Khamankar on 10/02/25.
//  Copyright © 2025 Deliveroo. All rights reserved.
//

extension Double {
    /// Returns the number rounded to one decimal place.
    var roundedToOneDecimalPlace: Double {
        return (self * 10).rounded() / 10
    }
}
