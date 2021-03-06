import UIKit

class VRootListReviewFooterOption:UICollectionViewCell
{
    weak var image:UIImageView!
    
    override init(frame:CGRect)
    {
        super.init(frame:frame)
        clipsToBounds = true
        backgroundColor = UIColor.clearColor()
        
        let image:UIImageView = UIImageView()
        image.clipsToBounds = true
        image.contentMode = UIViewContentMode.Center
        image.translatesAutoresizingMaskIntoConstraints = false
        image.userInteractionEnabled = false
        self.image = image
        
        addSubview(image)
        
        let views:[String:AnyObject] = [
            "image":image]
        
        let metrics:[String:AnyObject] = [:]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[image]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-0-[image]-20-|",
            options:[],
            metrics:metrics,
            views:views))
    }
    
    required init?(coder:NSCoder)
    {
        fatalError()
    }
    
    override var selected:Bool
    {
        didSet
        {
            hover()
        }
    }
    
    override var highlighted:Bool
    {
        didSet
        {
            hover()
        }
    }
    
    //MARK: private
    
    private func hover()
    {
        if selected || highlighted
        {
            alpha = 0.1
        }
        else
        {
            alpha = 1
        }
    }
    
    //MARK: public
    
    func config(model:MRootPoemsListItemAction)
    {
        image.image = UIImage(named:model.image)
        hover()
    }
}