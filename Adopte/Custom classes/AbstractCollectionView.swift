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
            return 138
            

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
    func showCellDetailsVC(userID: String?)
}

class AbstractCollectionView: UICollectionView, AbstractCellDelegate {
    func showCellDetailsVC(userID: String?) {
        print("Type: \(cellType)")
        if let del = self.abstractCellDelegate {
            del.showUserDetailsVC(userID: String?)
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
    func showUserDetailsVC(cellType: CellType, infoType: String, stringValue: String, workoutID: String?, runningID: String?)
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
            return UIEdgeInsets(top: 20.0, left: 0.0, bottom: 35.0, right: 0.0)
        }
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    private func _collectionViewCellWidth(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> CGFloat {
        let minPaddingSpace = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        let itemsPerRow = _itemsPerRow()
        let paddingSpace = minPaddingSpace * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.size.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        

        return widthPerItem
    }
    

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.restorationIdentifier == "HomeUsersCollectionView" {
            return CGSize(width: CGFloat(110), height: CGFloat(140))
        }
        
        let widthPerItem = _collectionViewCellWidth(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let height = (UIDevice.current.userInterfaceIdiom == .pad) ? widthPerItem * 1.1 : widthPerItem * 1.2
        guard let currentData = data?[indexPath.row] else {
            return CGSize(width: widthPerItem, height: height)
        }
        return CGSize(width: widthPerItem, height: CGFloat(currentData.type.getHeightForCell()))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return _defaultSectionInsets().left
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}

