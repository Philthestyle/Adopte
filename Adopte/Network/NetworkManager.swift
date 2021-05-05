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
                // Prepare data from User url profile infos
                completion(users)
            }
        }
        .resume()
    }
    
    static func getUserProfileFromURL_withUserLogin(login: String, completion:@escaping (UserProfile) -> ()) {
        
        
        guard let url = URL(string: "https://api.github.com/users/" + login) else { return }
        
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let userProfile = try! JSONDecoder().decode(UserProfile.self, from: data!)
            print(userProfile)
            DispatchQueue.main.async {
                completion(userProfile)
            }
        }
        .resume()
    }
    
}
