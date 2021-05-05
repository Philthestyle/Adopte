//
//  AbstractCollectionView.swift
//  Adopte
//
//  Created by Faustin Veyssiere on 05/05/2021.
//

import Foundation
import UIKit

class CellPresentation: NSObject, Collectionable {
    var type: CellType
    var cellData: Codable
    
    init(type: CellType, cellData: Codable) {
        self.type      = type
        self.cellData  = cellData
    }
}

//MARK: - Eum --> 'CellType'
enum CellType : String, CaseIterable {
    case `default` = "AbstractDefaultCollectionViewCell"
    
    case userCollectionViewCell = "UserCollectionViewCell"
    
    //MARK: - STATIC VAR --> 'allCases'
    static var allCases: [CellType] {
        return [
            .userCollectionViewCell
        ]
    }
    
    func getHeightForCell() -> Float {
        switch self {
      
        case .userCollectionViewCell:
            return 250
            

        default:
            return 20
        }
    }
}

protocol Collectionable {
    var type: CellType { get set }
    var cellData: Codable { get set }
}



protocol CollectionableCell {
    func update(data: Codable)
    var collectionableDelegate: AbstractCellDelegate? { get set }
}


protocol AbstractCellDelegate: class {
    func showCellDetailsVC(userLogin: String?)
}

class AbstractCollectionView: UICollectionView, AbstractCellDelegate {
    func showCellDetailsVC(userLogin: String?) {
        if let del = self.abstractCellDelegate {
            del.showUserDetailsVC(login: userLogin)
        }
    }
    

    
    var shouldAnimate: Bool = true
    
    var data: [Collectionable]?
    var computeItemsPerRow: (() -> Float)?
    weak var abstractCellDelegate: AbstractCollectionViewDelegate?
    
    var isLoading: Bool = false
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        for item in CellType.allCases {
            let nib = UINib(nibName: item.rawValue, bundle: nil)
            self.register(nib, forCellWithReuseIdentifier: item.rawValue)
        }
        self.delegate = self
        self.dataSource = self
    }
}

protocol AbstractCollectionViewDelegate: class {
    func showUserDetailsVC(login: String?)
}



extension AbstractCollectionView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let currentData = data?[indexPath.row] else {
                print("Not happy :(")
                return collectionView.dequeueReusableCell(withReuseIdentifier: CellType.default.rawValue, for: indexPath)
            }
            if var collectionableCell = collectionView.dequeueReusableCell(withReuseIdentifier: currentData.type.rawValue, for: indexPath) as? CollectionableCell {
                collectionableCell.update(data: currentData.cellData)
                collectionableCell.collectionableDelegate = self
                
                let cell = collectionableCell as! UICollectionViewCell
              
                
                return cell
            }
            return collectionView.dequeueReusableCell(withReuseIdentifier: CellType.default.rawValue, for: indexPath)
        }
    
}

extension AbstractCollectionView: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func _itemsPerRow() -> CGFloat {
        
        if computeItemsPerRow != nil {
            return CGFloat(computeItemsPerRow!())
        }
        
        // need to adapt if you have an iPad or iPhone and for different orientation
        var num: CGFloat = 1
        let isIPhone = (UIDevice.current.userInterfaceIdiom == .phone)
        let screenBounds = UIScreen.main.bounds
        if isIPhone {
            
            num = screenBounds.width > screenBounds.height ? 2 : 1
        } else {
            
            num = screenBounds.width > screenBounds.height ? 4 : 3
        }
        return num
    }
    
    
    
    private func _defaultSectionInsets() -> UIEdgeInsets {
        if self.restorationIdentifier == "homeUsersCollectionView" {
            return UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        }
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    
    private func _collectionViewCellWidth(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> CGFloat {
        let minPaddingSpace = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        let itemsPerRow = _itemsPerRow()
        let paddingSpace = minPaddingSpace * (itemsPerRow)
        let availableWidth = collectionView.frame.size.width
        let widthPerItem = availableWidth / itemsPerRow
        

        return widthPerItem
    }
    

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem = _collectionViewCellWidth(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let height = (UIDevice.current.userInterfaceIdiom == .pad) ? widthPerItem * 1 : widthPerItem * 1
        guard let currentData = data?[indexPath.row] else {
            return CGSize(width: widthPerItem, height: height)
        }
        return CGSize(width: widthPerItem, height: CGFloat(currentData.type.getHeightForCell()))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    

}

