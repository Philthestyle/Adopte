//
//  HomeVC.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import UIKit

class HomeVC: UIViewController, AbstractCollectionViewDelegate {
    func showUserDetailsVC(login: String?) {
        self.goToWithEffect(.userDetailsProfileVC, effect: .coverVertical)
    }
    
    //MARK: - @IBOutlets
    @IBOutlet weak var usersCollectionView: AbstractCollectionView!
    
    
    // MARK: - Variables
    var usersCells: [Collectionable] = []
    
    
    //MARK: - WillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Prepare data
        NetworkManager.getUsers { users in
            print("Users: \(users?.description ?? "")")
            guard users != nil else {
                print("Error - users list is empty")
                    return
            }
            
            self.prepareDataForCollectionView(usersList: users!, userProfiles: [])
        }
        
        
       
        
        
    }
    
    // MARK: - DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}



extension HomeVC {
    private func prepareDataForCollectionView(usersList: [User], userProfiles: [UserProfile]) {
       
        
        // reset 'self.usersCells'
        self.usersCells.removeAll()
        
        for i in 0...usersList.count - 1 {
            let userForCell: User = usersList[i]
//            let userProfileForCell: UserProfile = userProfiles[i]
            let userCell: Collectionable = CellPresentation(type: .userCollectionViewCell, cellData: UserCard(user: userForCell, userProfile: UserProfile()))
            self.usersCells.append(userCell)
        }

        // init collectionView params
        self.usersCollectionView.data = nil
        self.usersCollectionView.abstractCellDelegate = self
//        self.usersCollectionView.computeItemsPerRow   = { return 2 }
        self.usersCollectionView.data = self.usersCells
        self.usersCollectionView.performBatchUpdates(nil, completion : {
            (result) in
            self.usersCollectionView.reloadItems(at: self.usersCollectionView.indexPathsForVisibleItems)
            // avoid blinking when data is loading and display preparing to display cells with data
            self.usersCollectionView.layoutIfNeeded()
        })
    }
}






extension HomeVC {
    private func designInit() {
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
       
        self.title = "Home"
    }
    
   
}
