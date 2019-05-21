# RLWaterfallFlowlayout

#### Usage

1. Init flowLayout and setup some params.

```swift
 let waterFlowLayout = RLWaterfallFlowLayout()
        waterFlowLayout.columnCount = 3
        waterFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        waterFlowLayout.columSpacing = 10
        waterFlowLayout.rowSpacing = 10
        waterFlowLayout.delegate = self
```
2.Make ViewController extends RLWaterfallFlowLayoutDelegate and implement delegate methods

```swift
 func itemHeight(_ collectionView: UICollectionView?, indexPath: IndexPath) -> CGFloat {
        return itemHeight[indexPath.item]
    }
```

3.ScreenShot
![](http://ww3.sinaimg.cn/large/006tNc79gy1g39675hwx4j30q81g074i.jpg)


