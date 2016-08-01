import UIKit

class MMainTransitionFade:MMainTransition
{
    private let kAnimationDuration:NSTimeInterval = 0.3
    
    init()
    {
        super.init(animationDuration:kAnimationDuration)
    }
    
    override func before(parent:CMainParent, current:UIViewController?, next:UIViewController)
    {
        parent.view.addSubview(next.view)
        next.view.alpha = 0
        
        let barHeight:CGFloat
        
        if parent.bar == nil
        {
            barHeight = 0
        }
        else
        {
            barHeight = parent.bar!.bounds.maxY
        }
        
        let views:[String:AnyObject] = [
            "nextView":next.view]
        
        let metrics:[String:AnyObject] = [
            "barHeight":barHeight]
        
        parent.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-0-[nextView]-0-|",
            options:[],
            metrics:metrics,
            views:views))
        parent.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(barHeight)-[nextView]-0-|",
            options:[],
            metrics:metrics,
            views:views))
    }
    
    override func after(parent:CMainParent, current:UIViewController?, next:UIViewController)
    {
        current?.view.alpha = 0
        next.view.alpha = 1
    }
}