//
//  User.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 30/09/2022.
//

import Foundation

/// The class holds data about a user.
class User: Encodable, Decodable{
    
    var username: String = ""
    var password: String = ""
    
    
    
}

extension Encodable{
    /// An extension that  converts any Encodable object to a dictionary.
    var toDictionary: [String: Any]?{
        guard let data = try? JSONEncoder().encode(self) else{
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
