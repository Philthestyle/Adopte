//
//  NavigationHelper.swift
//  Blast
//
//  Created by Jeoffrey Thirot on 12/04/2019.
//  Copyright © 2019 FJ Studios. All rights reserved.
//

import UIKit
//import CocoaLumberjack

enum Navigation {
	case lost
	
    case userDetailsProfileVC
}

extension Navigation: RawRepresentable {
	typealias RawValue = StoryboardInfo
    
    //MARK: SWITCH CASES
    init(rawValue: RawValue) {
        switch rawValue.name {
        
        case "userDetailsProfileVC" : self = .userDetailsProfileVC
            
        case "404": self = .lost
        default: self = .lost
        }
    }
    

    // MARK: RAW VALUE
    var rawValue: RawValue {
        switch self {
     
        case .userDetailsProfileVC:
            return StoryboardInfo(
                name: "UserDetailsProfileVC",
                storyboardID: "UserDetailsProfileVC",
                type: UserDetailsProfileVC.self,
                bundleName: "Main")
        
        
        // LOST
        case .lost:
            return StoryboardInfo(
                name: "404",
                storyboardID: "404VCID",
                type: UIViewController.self,
                bundleName: nil)
            
        default:
            return StoryboardInfo(name: "404",
                                  storyboardID: "404VCID",
                                  type: UIViewController.self,
                                  bundleName: nil)
        }
    }
}


typealias StoryboardInfo = (name: String, storyboardID: String, type: UIViewController.Type, bundleName: String?)

extension UIViewController {
	
	func goTo(_ info: Navigation) -> Bool {
		let storyboardInfo = info.rawValue
		return goTo(storyboardInfo.storyboardID, typeVC: storyboardInfo.type, bundleName: storyboardInfo.bundleName)
	}
	
	func goToWithEffect(_ info: Navigation, effect: UIModalTransitionStyle) {
		let storyboardInfo = info.rawValue
		goToWithEffect(storyboardInfo.storyboardID, typeVC: storyboardInfo.type, bundleName: storyboardInfo.bundleName, effect: effect)
	}
    
    func goToFromModal(_ info: Navigation, effect: UIModalTransitionStyle) -> Bool {
        let storyboardInfo = info.rawValue
        return goToFromModal(storyboardInfo.storyboardID, typeVC: storyboardInfo.type, bundleName: storyboardInfo.bundleName, effect: effect)
    }
    

	func backToRoot(_ info: Navigation) -> Bool {
		let storyboardInfo = info.rawValue
		return backToRoot(with: storyboardInfo.storyboardID, typeVC: storyboardInfo.type, bundleName: storyboardInfo.bundleName)
	}
	
	func goTo<T: UIViewController>(_ storyboardID: String, typeVC: T.Type, bundleName: String? = nil) -> Bool {
		guard let moduleVC = self._getVC(with: storyboardID, typeVC: typeVC, bundleName: bundleName) else {
			return false
		}
		//        self.navigationController?.pushViewController(moduleVC, animated: true)
		var modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.coverVertical
		moduleVC.modalTransitionStyle = .crossDissolve
		self.navigationController?.pushViewController(moduleVC, animated: true)
		//		self.navigationController?.present(moduleVC, animated: true, completion: nil)
		return true
	}
	
	func goToWithEffect<T: UIViewController>(_ storyboardID: String, typeVC: T.Type, bundleName: String? = nil, effect: UIModalTransitionStyle) -> Bool {
		guard let moduleVC = self._getVC(with: storyboardID, typeVC: typeVC, bundleName: bundleName) else {
			return false
		}
		
        
		moduleVC.modalTransitionStyle = effect
        moduleVC.modalPresentationStyle = .popover
		//		self.navigationController?.pushViewController(moduleVC, animated: true)
		self.navigationController?.present(moduleVC, animated: true, completion: nil)
		return true
	}
    
    func goToFromModal<T: UIViewController>(_ storyboardID: String, typeVC: T.Type, bundleName: String? = nil, effect: UIModalTransitionStyle) -> Bool {
        guard let moduleVC = self._getVC(with: storyboardID, typeVC: typeVC, bundleName: bundleName) else {
            return false
        }
        
        present(UIViewController(), animated: true, completion: nil)
        moduleVC.modalTransitionStyle = effect
        moduleVC.modalPresentationStyle = .popover
      
        present(moduleVC, animated: true, completion: nil)
        return true
    }
	
	func backToRoot<T: UIViewController>(with storyboardID: String, typeVC: T.Type, bundleName: String? = nil) -> Bool {
		guard let moduleVC = self._getVC(with: storyboardID, typeVC: typeVC, bundleName: bundleName) else {
			return false
		}
		self.navigationController?.viewControllers = [moduleVC]
		self.navigationController?.popToViewController(moduleVC, animated: true)
		return true
	}
	
	private func _getVC<T: UIViewController>(with storyboardID: String, typeVC: T.Type, bundleName: String? = nil) -> T? {
		let currentStoryboard: UIStoryboard?
		// Create a reference to the the appropriate storyboard or get the current one
		if let bundleName = bundleName {
			currentStoryboard = UIStoryboard(name: bundleName, bundle: nil)
		} else {
			currentStoryboard = self.storyboard
		}
		
		guard let moduleVC = currentStoryboard?.instantiateViewController(withIdentifier: storyboardID) as? T else {
			return nil
		}
		return moduleVC
	}
}
