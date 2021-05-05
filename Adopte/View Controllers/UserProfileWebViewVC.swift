//
//  UserProfileWebViewVC.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import UIKit
import WebKit


class UserProfileWebViewVC: UIViewController {
    
    @IBOutlet weak var wkwebview: WKWebView!
    
    var currentUserProfileURl: String = Constants.currentSelectedUser?.html_url ?? "url is missing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.currentUserProfileURl = Constants.currentSelectedUser?.html_url ?? "url is missing"
        
        
        let request = URLRequest(url: URL(string: "\(self.currentUserProfileURl ?? "")")!)
        wkwebview?.load(request)
        
    }
    
}
