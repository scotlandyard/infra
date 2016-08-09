import UIKit

class VRootListReview:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    weak var controller:CRootListReview!
    weak var collection:UICollectionView!
    private let kHeaderHeight:CGFloat = 100
    private let kFooterHeight:CGFloat = 80
    private let kCollectionBottom:CGFloat = 30
    private(set) var model:[MRootPoemsListItem]
    
    init(controller:CRootListReview)
    {
        model = []
        
        super.init(frame:CGRectZero)
        clipsToBounds = true
        backgroundColor = UIColor.whiteColor()
        translatesAutoresizingMaskIntoConstraints = false
        self.controller = controller
        
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flow.headerReferenceSize = CGSizeMake(0, kHeaderHeight)
        flow.footerReferenceSize = CGSizeMake(0, kFooterHeight)
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        flow.sectionInset = UIEdgeInsetsMake(0, 0, kCollectionBottom, 0)
        
        let collection:UICollectionView = UICollectionView(frame:CGRectZero, collectionViewLayout:flow)
        collection.backgroundColor = UIColor.clearColor()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.clipsToBounds = true
        collection.alwaysBounceVertical = true
        collection.dataSource = self
        collection.delegate = self
        collection.registerClass(
            VRootListReviewCell.self,
            forCellWithReuseIdentifier:
            VRootListReviewCell.reusableIdentifier())
        collection.registerClass(
            VRootListReviewHeader.self,
            forSupplementaryViewOfKind:
            UICollectionElementKindSectionHeader,
            withReuseIdentifier:
            VRootListReviewHeader.reusableIdentifier())
        collection.registerClass(
            VRootListReviewFooter.self,
            forSupplementaryViewOfKind:
            UICollectionElementKindSectionFooter,
            withReuseIdentifier:
            VRootListReviewFooter.reusableIdentifier())
        self.collection = collection
        
        addSubview(collection)
    }
    
    required init?(coder:NSCoder)
    {
        fatalError()
    }
    
    //MARK: private
    
    private func modelAtIndex(index:NSIndexPath) -> MRootPoemsListItem
    {
        let item:MRootPoemsListItem = model[index.section]
        
        return item
    }
    
    //MARK: public
    
    //MARK: col del
    
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        let item:MRootPoemsListItem = modelAtIndex(indexPath)
        
        if item.cellSize == nil
        {
            let width:CGFloat = collectionView.bounds.maxX
            item.cellSizeFor(width)
        }
        
        return item.cellSize!
    }
    
    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int
    {
        let count:Int = controller.model.items.count
        
        return count
    }
    
    func collectionView(collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView:UICollectionView, viewForSupplementaryElementOfKind kind:String, atIndexPath indexPath:NSIndexPath) -> UICollectionReusableView
    {
        let item:MRootPoemsListItem = modelAtIndex(indexPath)
        let reusable:UICollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader
        {
            let header:VRootListReviewHeader = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier:
                VRootListReviewHeader.reusableIdentifier(),
                forIndexPath:indexPath) as! VRootListReviewHeader
            header.config(item)
            
            reusable = header
        }
        else
        {
            let footer:VRootListReviewFooter = collectionView.dequeueReusableSupplementaryViewOfKind(
                kind,
                withReuseIdentifier:
                VRootListReviewFooter.reusableIdentifier(),
                forIndexPath:indexPath) as! VRootListReviewFooter
            footer.config(item)
            
            reusable = footer
        }
        
        return reusable
    }
    
    func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
    {
        let item:MRootPoemsListItem = modelAtIndex(indexPath)
        let cell:VRootListReviewCell = collectionView.dequeueReusableCellWithReuseIdentifier(
            VRootListReviewCell.reusableIdentifier(),
            forIndexPath:
            indexPath) as! VRootListReviewCell
        cell.config(item)
        
        controller.pullItems(indexPath)
        
        return cell
    }
}