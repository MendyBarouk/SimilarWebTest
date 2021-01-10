//
//  UnsplashUser.swift
//  SimilarWebTest
//
//  Created by Mendy Barouk on 08/01/2021.
//

import Foundation

struct UnsplashUser: Codable {
    enum ProfileImageSize: String, Codable {
        case small
        case medium
        case large
    }
    
    let identifier  : String
    let username    : String
    let firstName   : String?
    let lastName    : String?
    let name        : String?
    let profileImage: [ProfileImageSize: URL]
    let bio         : String?
    
    private enum CodingKeys: String, CodingKey {
        case identifier   = "id"
        case username
        case firstName    = "first_name"
        case lastName     = "last_name"
        case name
        case profileImage = "profile_image"
        case bio
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier   = try container.decode(String.self, forKey: .identifier)
        username     = try container.decode(String.self, forKey: .username)
        firstName    = try? container.decode(String.self, forKey: .firstName)
        lastName     = try? container.decode(String.self, forKey: .lastName)
        name         = try? container.decode(String.self, forKey: .name)
        profileImage = try container.decode([ProfileImageSize: URL].self, forKey: .profileImage)
        bio          = try? container.decode(String.self, forKey: .bio)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(username, forKey: .username)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(name, forKey: .name)
        try container.encode(profileImage.convert({ ($0.key.rawValue, $0.value.absoluteString) }), forKey: .profileImage)
        try container.encode(bio, forKey: .bio)
    }
}

extension UnsplashUser {
    var displayName: String {
        if let name = name {
            return name
        }

        if let firstName = firstName {
            if let lastName = lastName {
                return "\(firstName) \(lastName)"
            }
            return firstName
        }

        return username
    }
}
