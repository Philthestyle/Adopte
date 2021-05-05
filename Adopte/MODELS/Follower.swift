//
//  Follower.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import Foundation

class Follower: Codable, Serializable {
    private enum CodingKeys: String, CodingKey {
        case id
        case avatar_url
        case login
        case url
    }
    
    
    var id: Int?
    
    var avatar_url: String = "username"
    var login: String = "firstName"
    var url: String = "lastName"
  
   
    // MARK: - INIT AUTO
    init() {
        self.id         = 00000000
        self.avatar_url   = ""
        self.login  = ""
        self.url   = ""
    }
    
    // MARK: - INIT WITH PARAMS
    init(id: Int,
         avatar_url: String,
         login: String,
         url: String) {
        
        self.id          = id
        self.avatar_url  = avatar_url
        self.login       = login
        self.url         = url
    }
    
    // MARK: - DECODER
    required init(from decoder: Decoder) throws {
        let values: KeyedDecodingContainer<CodingKeys>
        do {
            values = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id          = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0000000
            self.avatar_url         = try values.decodeIfPresent(String.self, forKey: .avatar_url) ?? "avatar_url missing"
            self.login          = try values.decodeIfPresent(String.self, forKey: .login) ?? "login missing"
            self.url             = try values.decodeIfPresent(String.self, forKey: .url) ?? "url missing"
        } catch let error {
            let className = "Follower"
            fatalError("Error! When you want to decode your model: <\(className)> > \(error)")
        }
        
       
    }
    
    // MARK: - ENCODER
    func encode(to encoder: Encoder) throws {
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encodeIfPresent(id, forKey: .id)
            try container.encodeIfPresent(avatar_url, forKey: .avatar_url)
            try container.encodeIfPresent(login, forKey: .login)
            try container.encodeIfPresent(url, forKey: .url)
        } catch let error {
            fatalError("Error! When you want to encode your model: \(type(of: self)) > \(self) :: \(error)")
        }
    }
    
    
  
}
