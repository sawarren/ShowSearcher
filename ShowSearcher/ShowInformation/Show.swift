//
//  Show.swift
//  ShowSearcher
//
//  Created by Steven A. Warren.
//

import Foundation

struct Show: Decodable, Hashable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case premiered = "premiered"
        case image = "image"
        case originalImageUrl = "original"
    }
    
    let id: Int
    let name: String
    let premiered: String
    let originalImageUrl: String
    
    init(id: Int, name: String, premiered: String, originalImageUrl: String) {
        self.id = id
        self.name = name
        self.premiered = premiered
        self.originalImageUrl = originalImageUrl
    }
    
    // MARK: - Decodable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        premiered = try container.decode(String.self, forKey: .premiered)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
        originalImageUrl = try imageContainer.decode(String.self, forKey: .originalImageUrl)
    }
}

