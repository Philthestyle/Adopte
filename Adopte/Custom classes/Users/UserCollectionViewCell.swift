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
}

class UserCollectionViewCell: UICollectionViewCell, CollectionableCell {
    
    @IBOutlet weak var totalKMRunLabel: PaddingLabel!
    //    @IBOutlet weak var kmDoneLabel: UILabel!
    @IBOutlet weak var lottiesAnimContainerView: UIView!
    /* @IBOutlets */
    @IBOutlet weak var mainViewContainer: UIView!
    
    @IBOutlet weak var nameLabel: MarqueeLabel!
    @IBOutlet weak var friendProfilePicImageView: UIImageView!
    @IBOutlet weak var imageViewContainerMain: UIView!
    
    //    @IBOutlet weak var isOnlineRoundView: UIView!
    /* Delegate */
    weak var delegate: AbstractCellDelegate?
    var collectionableDelegate: AbstractCellDelegate?
    var data: String?
    
    var uidValue: String?
    
    var currentFriendValue: Friend?
    
    var animation: Animation = Animation.named("miniManRunningAnimation") ??  Animation.named("") as! Animation
    
    var animationView: AnimationView?
    
    
    var usernameValue: String = ""
    
    //MARK: - Delegates
    func showUserDetailsVC(informationType: String) {
        
        FirestoreManager.getUser(userUID: self.uidValue ?? "") { (selectedFriend) in
            print("SelectedFriend UID: ------>  \(selectedFriend.basicProfile?.email ?? "email echec :'(((((")")
            
            Constants.currentSelectedFriendAsUserClass = selectedFriend
            Constants.currentSelectedFriendUID = selectedFriend.basicProfile?.firestoreUID ?? "uid missing"
            Constants.currentSelectedFriendTotalKM = self.currentFriendValue?.totalKMRun ?? 888888888888
            
            
            
            
            if let del = self.collectionableDelegate {
                del.showAllItemsOfSection(cellType: .movementCell, infoType: "friendsProfileVC", stringValue: "", workoutID: "", runningID: "")
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.isHidden = true
        self.friendProfilePicImageView.isHidden = true
        self.imageViewContainerMain.isHidden = true
        
    
    }
    
    @IBAction func acceptFriendsRequestButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func refuseFriendsRequestButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func addAndFollowFriendButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func showUserProfileVC(_ sender: Any) {
        self.showUserDetailsVC(informationType: "userDetailsProfileVC")
    }
    
    
    
    // MARK: - Public methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        self.nameLabel.labelize = true
       
        /* Data management */
        data = nil
        self.nameLabel.text = ""
        self.nameLabel.isHidden = true
        self.friendProfilePicImageView.isHidden = true
        self.imageViewContainerMain.isHidden = true
        
    }
    
    func color(from hexString : String) -> CGColor
    {
        if let rgbValue = UInt(hexString, radix: 16) {
            let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255
            let green =  CGFloat((rgbValue >>  8) & 0xff) / 255
            let blue  =  CGFloat((rgbValue      ) & 0xff) / 255
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        } else {
            return UIColor.black.cgColor
        }
    }
    
    
    
    
    
    // MARK:- UPDATE DATA
    func update(data: Codable) {
        guard let typedData = data as? FriendStoryRound else {
            print("Error! you pass the wrong type to this cell.")
            return
        }
        
        self.currentFriendValue = typedData.friend
        
        print("UserUID: \(typedData.friend.firebaseUserUID ?? ""): \(typedData.friend.totalKMRun / 1000) km")
        self.totalKMRunLabel.text = "\(typedData.friend.totalKMRun / 1000) km"
        self.playRunningAnimation(isRunning: typedData.friend.isRunning)
        
        self.friendProfilePicImageView.isHidden = false
        self.imageViewContainerMain.isHidden = false
       
        
        print("FRIEND TITIN CELLULE --> \(typedData.friend.lastConnectionMillisecondsFormat)")
        
        if (Auth.auth().currentUser?.uid ?? "") == "z93i16tHxQUdNjbPqZdI9sNw4TF2" && typedData.friend.username ?? "" == "z93i16tHxQUdNjbPqZdI9sNw4TF2" {
           
            self.nameLabel.isHidden = false
            self.imageViewContainerMain.addInstagramStyleRainbowCircle(2)
            let version: String = "\(Bundle.main.releaseVersionNumber ?? "")"
            let build: String = "\(Bundle.main.buildVersionNumber ?? "")"
            self.nameLabel.text = "v\(version) • b\(build)"
            print("TESTFLIGHT: \(version)")
            print("TESTFLIGHT: \(build)")

        } else {
            
            
            self.usernameValue = typedData.friend.username ?? ""
            self.nameLabel.isHidden = false
           
            self.imageViewContainerMain.addInstaGradientCircle(2)
            if typedData.friend.isOnline {
            
                //  ONLINE
                self.nameLabel.labelize = true
                let usernameAttr: [NSAttributedString.Key: Any] =
                    [NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 13.0) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
                let usernameStrg = NSMutableAttributedString(string: "\(typedData.friend.username?.capitalized ?? "")", attributes: usernameAttr)
                self.nameLabel.attributedText = usernameStrg
                
            } else {
                //  OFFLINE
                self.nameLabel.labelize = false
                
                let usernameAttr: [NSAttributedString.Key: Any] =
                    [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 12.0) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
                
                let lastConnectionAtt1: [NSAttributedString.Key: Any] =
                    [NSAttributedString.Key.font: UIFont(name: "AvenirNext-MediumItalic", size: 10.0) as Any, NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.1490196078, green: 0.3450980392, blue: 0.6156862745, alpha: 1)]

               
                
                let lastConnectionStrg1 = NSMutableAttributedString(string: "\(TimeFormatHelper.timeAgoStringFR(date: (typedData.friend.lastConnectionMillisecondsFormat).toDate)) ", attributes: usernameAttr)
                
                let lastConnectionStrg2 = NSMutableAttributedString(string: " •  \(typedData.friend.lastConnectionMillisecondsFormat.toDate.toStringFR())", attributes: lastConnectionAtt1)
                
                lastConnectionStrg1.append(lastConnectionStrg2)
                self.nameLabel.attributedText = lastConnectionStrg1
                
            }
            
        }
        
       
        
        
       
        
        
        
        if typedData.friend.profilePicURL == "" {
            self.friendProfilePicImageView.image = UIImage(named: "maya")
            self.friendProfilePicImageView.contentMode = .scaleAspectFill
        } else {
            let processor = DownsamplingImageProcessor(size: CGSize(width: 500, height: 500))
            self.friendProfilePicImageView.kf.indicatorType = .activity
            self.friendProfilePicImageView.kf.setImage(with: URL(string: typedData.friend.profilePicURL ?? ""), options: [.processor(processor)])
            self.friendProfilePicImageView.contentMode = .scaleAspectFill
        }
        
        
        
        self.friendProfilePicImageView.layer.cornerRadius = self.friendProfilePicImageView.layer.bounds.width / 2
        self.friendProfilePicImageView.clipsToBounds = true
        
        self.uidValue = typedData.friend.firebaseUserUID
        print("update in cell: \(data)")
        
        
        
        
    }
    

    private func playRunningAnimation(isRunning: Bool) {
        
        if self.lottiesAnimContainerView?.isHidden == false {
            self.lottiesAnimContainerView?.isHidden = true
            return
        }
        
        self.lottiesAnimContainerView.clipsToBounds = true
        self.lottiesAnimContainerView.layer.cornerRadius = self.lottiesAnimContainerView.bounds.height / 2
        
        switch isRunning {
        case false:
            // Play the animation
            
            self.lottiesAnimContainerView?.isHidden = true
            
            
        case true:
            
            
            
            // Play the animation
            let animV: AnimationView = AnimationView(animation: self.animation)
            
            
            animV.frame = CGRect(center: CGPoint(x: self.lottiesAnimContainerView.bounds.width / 2, y: self.lottiesAnimContainerView.bounds.height / 2), size: CGSize(width: self.imageViewContainerMain.bounds.width, height: self.imageViewContainerMain.bounds.height))
            
            self.lottiesAnimContainerView?.addSubview(animV)
            
            animV.contentMode = .center
            
            
            animV.backgroundColor = #colorLiteral(red: 0.07944549912, green: 0.1851495324, blue: 0.3306822297, alpha: 1).withAlphaComponent(0.7)
            animV.clipsToBounds = true
            animV.layer.cornerRadius = animV.bounds.height / 2
            
            self.lottiesAnimContainerView.isHidden = false
            
            animV.play(fromProgress: 0,
                       toProgress: 1,
                       loopMode: LottieLoopMode.repeat(50),
                       completion: { (finished) in
                        if finished {
                            print("Animation Complete")
                        } else {
                            print("Animation cancelled")
                        }
                       })
        default:
            // Play the animation
            self.lottiesAnimContainerView?.isHidden = true
            
            animationView?.stop()
            
        }
        
        
        
    }
    
}

