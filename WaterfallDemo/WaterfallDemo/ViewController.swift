//
//  ViewController.swift
//  WaterfallDemo
//
//  Created by 梁炜杰 on 2019/5/21.
//  Copyright © 2019 richard. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, RLWaterfallFlowLayoutDelegate {

    var collectionView: UICollectionView?
    
    var itemHeight:[CGFloat] = []
    let itemColor: [UIColor] = [UIColor.yellow, UIColor.blue, UIColor.lightGray, UIColor.red, UIColor.green]
    
    let kItemCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let waterFlowLayout = RLWaterfallFlowLayout()
        waterFlowLayout.columnCount = 3
        waterFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        waterFlowLayout.columSpacing = 10
        waterFlowLayout.rowSpacing = 10
        waterFlowLayout.delegate = self
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: waterFlowLayout)
        collectionView?.register(RLItemCell.classForCoder(), forCellWithReuseIdentifier: "RLItemCell")
        collectionView?.dataSource = self
        
        if let collectionView = collectionView{
            collectionView.backgroundColor = UIColor.white
            view.backgroundColor = UIColor.white
            view.addSubview(collectionView)
        }
        
        randomData()
    }
    
    private func randomData(){

        for _ in 0..<kItemCount{

            itemHeight.append(CGFloat(arc4random() % 200 + 50))

        }
        
    }

    func itemHeight(_ collectionView: UICollectionView?, indexPath: IndexPath) -> CGFloat {
        return itemHeight[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RLItemCell", for: indexPath)
        if let cell = cell as? RLItemCell{
            cell.bgColor = itemColor[indexPath.item % 3]
        }
        return cell
    }
}

class RLItemCell: UICollectionViewCell{

    private let view = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var bgColor: UIColor?{
        didSet{
            view.backgroundColor = bgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
    
}

