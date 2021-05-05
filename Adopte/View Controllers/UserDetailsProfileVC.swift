//
//  UserDetailsProfileVC.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import UIKit

class UserDetailsProfileVC: UIViewController {

    // @IBOutlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userIDLabel: PaddingLabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var html_urlLabel: UILabel!
    

    // Variables
    var currentUserProfile: UserProfile?
    
    //MARK: - WillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Prepare data
        NetworkManager.getUserProfileFromURL_withUserLogin(login: Constants.currentSelectedUser?.login ?? "login missing") { userProfileFromNetwork in
            print("User profile from network: \(userProfileFromNetwork.login)")
            
            self.currentUserProfile = userProfileFromNetwork
            
            self.designInit(userProfileToBeUsed: userProfileFromNetwork)
            
            // init data
            self.userIDLabel.text = "ID \(userProfileFromNetwork.id ?? 00000000)"
            self.userProfileImageView.downloaded(from: "\(userProfileFromNetwork.avatar_url ?? "avatar url missing")")
            
            // infos at the bottom
            self.followersLabel.text = "Followers: \(userProfileFromNetwork.followers ?? 0)"
            self.companyLabel.text = "Société: \(userProfileFromNetwork.company ?? "'company' is missing")"
            self.locationLabel.text = "Location: \(userProfileFromNetwork.location ?? "'location' is missing")"
            self.html_urlLabel.text = "html_url: \(userProfileFromNetwork.html_url ?? "'html_url' is missing")"
        }
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


extension UserDetailsProfileVC {
    private func designInit(userProfileToBeUsed: UserProfile?) {
        // navigationBar design
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.clear,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-HeavyItalic", size: CGFloat(22))!]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: UIColor.clear), for: .default)
       
        self.title = "\(userProfileToBeUsed?.login ?? "User Profile")"
    }
    
   
}
