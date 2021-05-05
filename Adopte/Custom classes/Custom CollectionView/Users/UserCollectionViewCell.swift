//
//  UserCollectionViewCell.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import UIKit

/* Data to be displayed */
struct UserCard: Codable {
    var user: User
    var userProfile: UserProfile
}

class UserCollectionViewCell: UICollectionViewCell, CollectionableCell {
    
    /* Delegate */
    weak var delegate: AbstractCellDelegate?
    var collectionableDelegate: AbstractCellDelegate?
    
    /* Data */
    var data: String?
    
    
    
    /* Variables */
    var currentUser: User?
    
    @IBOutlet weak var usernameLabel: PaddingLabel!
    @IBOutlet weak var cityLabel: PaddingLabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    //MARK: - Delegates
    func showUserDetailsVC(informationType: String) {
        if let del = self.collectionableDelegate {
            del.showCellDetailsVC(userLogin: self.currentUser?.login ?? "login is missing for 'self.currentUser'")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.usernameLabel.isHidden   = true
        self.cityLabel.isHidden       = true
        self.avatarImageView.isHidden = true
    }
    
  
    @IBAction func showUserProfileVC(_ sender: Any) {
        
        
        Constants.currentSelectedUser = self.currentUser ?? User()
        self.showUserDetailsVC(informationType: "userDetailsProfileVC")
    }
    
    
    
    // MARK: - Public methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        /* Data management */
        data = nil
        self.usernameLabel.text = ""
        self.cityLabel.text = ""
        self.avatarImageView.image = nil
    }
    
    
    // MARK:- UPDATE DATA
    func update(data: Codable) {
        guard let typedData = data as? UserCard else {
            print("Error! you pass the wrong type to this cell.")
            return
        }
        
        
        
        
        // main data init
        self.currentUser = typedData.user
        
        // fill data with cells contents items
        self.usernameLabel.text = "\(typedData.user.login.uppercased())"
        self.cityLabel.text = "\(typedData.userProfile.location)"
        self.avatarImageView.downloaded(from: typedData.user.avatar_url ?? "")
        
        // display everything now data is ready
        self.usernameLabel.isHidden   = false
        self.cityLabel.isHidden       = false
        self.avatarImageView.isHidden = false
    }
    
    

    
}

// Image from url management extension
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
