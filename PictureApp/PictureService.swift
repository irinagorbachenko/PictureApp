//
//  PictureService.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 01.12.2021.
//

import UIKit
import NetworkLayer


public struct PictureService {

    let session: HTTPClient

   public init(with session: HTTPClient) {
        self.session = session
    }

    func fetch(completion: @escaping ([Post], Int) -> (),order : Order ,selectedCategory:[String],currentPage:Int) {

        var urlComponents = URLComponents(string: "https://pixabay.com/api")!
        urlComponents.queryItems = [
            "key": "8630898-e092bf16cb1dd9ff6a483dabf",
            "image_type": "photo",
            "per_page": 20,
            "safesearch": "true",
            "page": currentPage,
            "order": order,
            "category": selectedCategory.joined(separator: ",")
        ].map({ URLQueryItem(name: $0, value: "\($1)")})
        

        
        session.get(from: urlComponents.url!) { (result) in
            switch result {
            case let .success(data, response):
                var totalFromData  = try? JSONDecoder().decode(Hits.self, from: data)
                completion((try? JSONDecoder().decode(Hits.self, from: data).hits) ?? [] , totalFromData?.totalHits ?? 0)
            case let .failure(error):
                break
            }
        }
     
        
    }

}


