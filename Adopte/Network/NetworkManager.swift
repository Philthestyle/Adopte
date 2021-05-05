//
//  NetworkManager.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import Foundation

public class NetworkManager {
    static func getUsers(completion:@escaping ([User]?) -> ()) {
        guard let url = URL(string: "https://api.github.com/repos/JetBrains/kotlin/contributors") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let users = try! JSONDecoder().decode([User].self, from: data!)
            print(users)
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
    
    static func getUserInfosFromURL_withUserLogin(login: String, completion:@escaping (User) -> ()) {
        guard let url = URL(string: "https://api.github.com/users/" + login) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let users = try! JSONDecoder().decode(User.self, from: data!)
            print(users)
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
    
    static func getUserFollowersFromURL_withUserLogin(login: String, completion:@escaping (User) -> ()) {
        guard let url = URL(string: "https://api.github.com/users/" + login) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let users = try! JSONDecoder().decode([User].self, from: data!)
            print(users)
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
}
