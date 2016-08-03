import UIKit

class MMainTransitionScrollRight:MMainTransition
{
    private let kAnimationDuration:NSTimeInterval = 0.3
    
    init()
    {
        super.init(animationDuration:kAnimationDuration)
    }
    
    override func before(parent:CMainParent, current:UIViewController?, next:UIViewController)
    {
        let width:CGFloat
        let barHeight:CGFloat
        
        if current == nil
        {
            width = 0
        }
        else
        {
            width = current!.view.bounds.maxX
        }
        
        if parent.bar == nil
        {
            barHeight = 0
        }
        else
        {
            barHeight = parent.kBarHeight
        }
        
        parent.layoutTopTemporal = NSLayoutConstraint(
            item:next.view,
            attribute:NSLayoutAttribute.Top,
            relatedBy:NSLayoutRelation.Equal,
            toItem:parent.view,
            attribute:NSLayoutAttribute.Top,
            multiplier:1,
            constant:barHeight)
        parent.layoutBottomTemporal = NSLayoutConstraint(
            item:next.view,
            attribute:NSLayoutAttribute.Bottom,
            relatedBy:NSLayoutRelation.Equal,
            toItem:parent.view,
            attribute:NSLayoutAttribute.Bottom,
            multiplier:1,
            constant:0)
        parent.layoutLeftTemporal = NSLayoutConstraint(
            item:next.view,
            attribute:NSLayoutAttribute.Left,
            relatedBy:NSLayoutRelation.Equal,
            toItem:parent.view,
            attribute:NSLayoutAttribute.Left,
            multiplier:1,
            constant:width)
        parent.layoutRightTemporal = NSLayoutConstraint(
            item:next.view,
            attribute:NSLayoutAttribute.Right,
            relatedBy:NSLayoutRelation.Equal,
            toItem:parent.view,
            attribute:NSLayoutAttribute.Right,
            multiplier:1,
            constant:width)
        
        parent.view.addConstraint(parent.layoutLeftTemporal!)
        parent.view.addConstraint(parent.layoutRightTemporal!)
        parent.view.addConstraint(parent.layoutTopTemporal!)
        parent.view.addConstraint(parent.layoutBottomTemporal!)
    }
    
    override func after(parent:CMainParent, current:UIViewController?, next:UIViewController)
    {
        if current != nil
        {
            let width:CGFloat = current!.view.bounds.maxX
            parent.layoutLeft!.constant = -width
            parent.layoutRight!.constant = -width
        }
        
        parent.layoutLeftTemporal!.constant = 0
        parent.layoutRightTemporal!.constant = 0
    }
}