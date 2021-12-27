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
struct Category {
    
    let name: String
    let isComplete: Bool
      
   init(name: String, isComplete: Bool = false) {
     self.name = name
     self.isComplete = isComplete
      }
      
    func completeToggled() -> Category {
        return Category(name: name, isComplete: !isComplete)
      }
    
}
