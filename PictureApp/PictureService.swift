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
    
    func fetch(order: Order, selectedCategory: [Category], currentPage: Int, completion: @escaping (Result<([Post], Int), Error>) -> ()) {
        
        var components = [
            "key": "8630898-e092bf16cb1dd9ff6a483dabf",
            "image_type": "photo",
            "per_page": 20,
            "safesearch": "true",
            "page": currentPage,
            "order": order,
        ] as [String : Any]
        
        if let selectedCategory = selectedCategory.first{
            components["category"] = selectedCategory.rawValue
        }
        
        var urlComponents = URLComponents(string: "https://pixabay.com/api")!
        // urlComponents.queryItems = components.map({ URLQueryItem(name: $0, value: "\($1)")})
        var queryItems = [URLQueryItem]()
        for (key,value) in components {
            queryItems.append(URLQueryItem.init(name: key, value: "\(value)"))
        }
        urlComponents.queryItems = queryItems
        
        session.get(from: urlComponents.url!) { (result) in
            switch result {
            case let .success(data, response):
                var totalFromData  = try! JSONDecoder().decode(Hits.self, from: data)
                completion(.success((totalFromData.hits, totalFromData.totalHits)))
            case let .failure(error):
                completion ( .failure(error))
                break
            }
        }
    }
    
}


