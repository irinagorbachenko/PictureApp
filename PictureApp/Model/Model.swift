//
//  Model.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 02.12.2021.
//
import UIKit

struct Hits: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Post]
    
    var hasMore: Bool {
        total > totalHits
    }
}

struct Post: Codable, Equatable {
    let id: Int
    let user: String
    let likes: Int
    let image: String
    let imageHeight: Int
    let imageWidth: Int
    let userImageURL: String
    let tags : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "webformatURL"
        case user
        case likes
        case imageHeight = "webformatHeight"
        case imageWidth = "webformatWidth"
        case userImageURL
        case tags
    }
}

enum Category: String, CaseIterable, Equatable {
    case music, nature, science, backgrounds, fashion, education, feelings, health, people, religion, places, animals, industry, computer, food, sports, travel, buildings, business
}
