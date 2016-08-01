import UIKit

class MMainTransitionFade:MMainTransition
{
    private let kAnimationDuration:NSTimeInterval = 0.3
    
    init()
    {
        super.init(animationDuration:kAnimationDuration)
    }
}