import UIKit

class VRootListReview:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    weak var controller:CRootListReview!
    weak var collection:UICollectionView!
    var model:[MRootPoemsListItem]
    private let attributesText:[String:AnyObject]
    private let kHeaderHeight:CGFloat = 90
    private let kFooterHeight:CGFloat = 70
    private let kCellMarginHorizontal:CGFloat = 10
    private let kCellMarginVertical:CGFloat = 20
    
    init(controller:CRootListReview)
    {
        model = []
        attributesText = [NSFontAttributeName:UIFont.regular(16)]
        
        super.init(frame:CGRectZero)
        clipsToBounds = true
        backgroundColor = UIColor(white:0.95, alpha:1)
        translatesAutoresizingMaskIntoConstraints = false
        self.controller = controller
        
        let flow:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flow.headerReferenceSize = CGSizeMake(0, kHeaderHeight)
        flow.footerReferenceSize = CGSizeMake(0, kFooterHeight)
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        flow.scrollDirection = UICollectionViewScrollDirection.Vertical
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
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
        
        let views:[String:AnyObject] = [
            "collection":collection]
        
        let metrics:[String:AnyObject] = [:]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[collection]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[collection]-0-|",
            options:[],
            metrics:metrics,
            views:views))
    }
    
    required init?(coder:NSCoder)
    {
        fatalError()
    }
    
    override func layoutSubviews()
    {
        collection.collectionViewLayout.invalidateLayout()
        super.layoutSubviews()
    }
    
    //MARK: private
    
    private func modelAtIndex(index:NSIndexPath) -> MRootPoemsListItem
    {
        let item:MRootPoemsListItem = model[index.section]
        
        return item
    }
    
    //MARK: public
    
    func removeItem(item:MRootPoemsListItem)
    {
        let totalItems:Int = model.count
        var indexSet:NSIndexSet?
        
        for index:Int in 0 ..< totalItems
        {
            let anItem:MRootPoemsListItem = model[index]
            
            if anItem === item
            {
                indexSet = NSIndexSet(index:index)
                model.removeAtIndex(index)
                
                break
            }
        }
        
        if indexSet != nil
        {
            collection.deleteSections(indexSet!)
        }
    }
    
    //MARK: col del
    
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        let width:CGFloat = collectionView.bounds.maxX
        let item:MRootPoemsListItem = modelAtIndex(indexPath)
        
        if item.cellWidth != width
        {
            item.measureString(attributesText, cellWidth:width, marginHorizontal:kCellMarginHorizontal, marginVertical:kCellMarginVertical)
        }
        
        return item.cellSize!
    }
    
    func numberOfSectionsInCollectionView(collectionView:UICollectionView) -> Int
    {
        let count:Int = model.count
        
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
            footer.config(item, parent:self)
            
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