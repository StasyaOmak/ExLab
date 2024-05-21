//
//  Photo.swift
//  ExLabTest
//
//  Created by Anastasiya Omak on 21/05/2024.
//

import Foundation

struct Photo: Codable, Identifiable {
    var id: Int
    var title: String
    var url: String
}
