//
//  UnsplashPhoto.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation

struct UnsplashPhoto: Codable, Equatable {
    
    static func == (lhs: UnsplashPhoto, rhs: UnsplashPhoto) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    enum URLKind: String, Codable {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    let identifier : String
    let height     : Int
    let width      : Int
    let user       : UnsplashUser
    let urls       : [URLKind: URL]
    let blurHash   : String?
    let description: String?
    let likesCount : Int
    
    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case height
        case width
        case user
        case urls
        case blurHash   = "blur_hash"
        case description
        case likesCount = "likes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        identifier  = try container.decode(String.self, forKey: .identifier)
        height      = try container.decode(Int.self, forKey: .height)
        width       = try container.decode(Int.self, forKey: .width)
        user        = try container.decode(UnsplashUser.self, forKey: .user)
        urls        = try container.decode([URLKind: URL].self, forKey: .urls)
        blurHash    = try container.decode(String?.self, forKey: .blurHash)
        description = try container.decode(String?.self, forKey: .description)
        likesCount  = try container.decode(Int.self, forKey: .likesCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encode(user, forKey: .user)
        try container.encode(urls.convert({ ($0.key.rawValue, $0.value.absoluteString) }), forKey: .urls)
        try container.encode(blurHash, forKey: .blurHash)
        try container.encode(description, forKey: .description)
        try container.encode(likesCount, forKey: .likesCount)
    }
}
