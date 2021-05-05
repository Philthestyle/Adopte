//
//  HomeVC.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import UIKit

class HomeVC: UIViewController, AbstractCollectionViewDelegate {
    // delegates method
    func showUserDetailsVC(login: String?) {
        self.goToWithEffect(.userDetailsProfileVC, effect: .coverVertical)
    }
    
    // refresh data management
    private let refreshControl = UIRefreshControl()
    @objc
    private func didPullToRefresh(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            NetworkManager.getUsers { users in
                print("Users: \(users?.description ?? "")")
                guard users != nil else {
                    print("Error - users list is empty")
                    return
                }
                
                self.prepareDataForCollectionView(usersList: users!, userProfiles: [])
            }
            refreshControl.endRefreshing()
        } else {
            
            DispatchQueue.main.async {
                self.showNoConnectionAlertView()
               
            }
            self.usersCollectionView.refreshControl?.endRefreshing()
        }
        

    }
    
    
    //MARK: - @IBOutlets
    @IBOutlet weak var usersCollectionView: AbstractCollectionView!
    
    
    // MARK: - Variables
    var usersCells: [Collectionable] = []
    
    
    //MARK: - WillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        self.usersCollectionView.alwaysBounceVertical = true
        self.usersCollectionView.refreshControl = refreshControl
        
        // design init
        self.designInit()
        
        
        // Prepare data
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            NetworkManager.getUsers { users in
                print("Users: \(users?.description ?? "")")
                guard users != nil else {
                    print("Error - users list is empty")
                    return
                }
                
                self.prepareDataForCollectionView(usersList: users!, userProfiles: [])
            }
            refreshControl.endRefreshing()
        } else {
            print("Internet Connection not Available!")
            
           
            DispatchQueue.main.async {
                self.showNoConnectionAlertView()
                
            }
            self.usersCollectionView.refreshControl?.endRefreshing()
            
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
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-HeavyItalic", size: CGFloat(22))!]
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1563185453, green: 0.200453192, blue: 0.2403710783, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: #colorLiteral(red: 0.1563185453, green: 0.200453192, blue: 0.2403710783, alpha: 1)), for: .default)
       
        self.title = "Home"
        
        
        
    }
    
   
}


extension HomeVC {
    // if user is not connected to the internet
    private func showNoConnectionAlertView() {
        let alert = UIAlertController(title: "Aucun réseau", message: "Vous n'êtes pas connecté à Internet - vérifier votre réseau pour recharger", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: {(action: UIAlertAction) in
        }))
        alert.view.tintColor = UIColor.black
        self.present(alert, animated: true, completion: nil)
    }
}
