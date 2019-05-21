//
//  RLWaterfallFlowLayout.swift
//  WaterfallDemo
//
//  Created by 梁炜杰 on 2018/11/28.
//  Copyright © 2018 DCN. All rights reserved.
//

import UIKit

@objc
protocol RLWaterfallFlowLayoutDelegate {
    
    func itemHeight(_ collectionView: UICollectionView?, indexPath: IndexPath) -> CGFloat
    
    @objc optional
    func sizeForSupplementaryElementOfKind(_ kind: String, at indexPath: IndexPath, _ collectionView: UICollectionView?) -> CGSize
}

class RLWaterfallFlowLayout: UICollectionViewLayout {

    weak var delegate: RLWaterfallFlowLayoutDelegate?
    
    var columnCount: Int = 0
    var columSpacing: CGFloat = 0
    var rowSpacing: CGFloat = 0
    var sectionInset: UIEdgeInsets = UIEdgeInsets.zero
    
    private var maxYsArray: [NSNumber] = []
    
    private var attributesArray: [UICollectionViewLayoutAttributes] = []

    override func prepare() {
        super.prepare()
        
        maxYsArray.removeAll()
        attributesArray.removeAll()
        
        let itemCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        let sectionCount = collectionView?.numberOfSections ?? 0

        var layoutMaxY: CGFloat = 0
        
        for section in 0..<sectionCount {
            if let supplementaryViewAttributes = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)){
                var supplementaryViewSize: CGSize = CGSize.zero
                if let delegate = delegate{
//                    supplementaryViewSize = delegate.sizeForSupplementaryElementOfKind(UICollectionView.elementKindSectionHeader, at: IndexPath(row:0, section: section), collectionView)
                }
                supplementaryViewAttributes.frame = CGRect(x: 0, y: layoutMaxY, width: supplementaryViewSize.width, height: supplementaryViewSize.height)
                layoutMaxY += supplementaryViewSize.height
                attributesArray.append(supplementaryViewAttributes)
            }
        }
        
        for _ in 0..<columnCount{
            maxYsArray.append(NSNumber(value: Float(sectionInset.top + layoutMaxY)))
        }
        
        for index in 0..<itemCount{
            if let attribute = layoutAttributesForItem(at: IndexPath(item: index, section: 0)){
                attributesArray.append(attribute)
            }
        }
    }
    
    override var collectionViewContentSize: CGSize{
        var maxValue: Float = 0
        for i in 0..<maxYsArray.count{
            let value = maxYsArray[i].floatValue
            if maxValue < value{
                maxValue = value
            }
        }
        
        return CGSize(width: 0, height: CGFloat(maxValue) + sectionInset.bottom)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView else { return nil }
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let columnTotalSpacing: CGFloat = CGFloat(columnCount - 1) * columSpacing
        
        let itemWidth = ((collectionView.frame.size.width - sectionInset.left - sectionInset.right) - columnTotalSpacing) / CGFloat(columnCount)

        //通过代理获取当前需要的item height
        var itemHeight:CGFloat = 0
        if let delegate = delegate{
            itemHeight =  delegate.itemHeight(collectionView, indexPath: indexPath)
        }
        //找出最短Y的位置
        var minValue: Float = maxYsArray.first?.floatValue ?? 0
        var minIndex: Int = 0
        for i in 0..<maxYsArray.count{
            let value = maxYsArray[i].floatValue
            if minValue >= value{
                minValue = value
                minIndex = i
            }
        }

        let itemX: CGFloat = sectionInset.left + (columSpacing + itemWidth) * CGFloat(minIndex)
        
        let itemY: CGFloat = CGFloat(minValue) + rowSpacing
        
        attributes.frame = CGRect(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        
        maxYsArray[minIndex] = NSNumber(value: Float(attributes.frame.maxY))
        
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let supplementaryViewattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

        return supplementaryViewattributes
    }
    
}
