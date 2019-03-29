
import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning
{
    var presents: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to)
            else {return}
        guard let fromViewController = transitionContext.viewController(forKey: .from)
            else {return}
        let containerView = transitionContext.containerView
        let finalWidth = toViewController.view.bounds.width * 0.418
        let finalHight = toViewController.view.bounds.height
        
        if presents
        { // Combine menu controller and container
            containerView.addSubview(toViewController.view)
            
            //Set the screen size
            toViewController.view.frame=CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHight)
        }
        
        // Show on screen
        let transform={
            toViewController.view.transform=CGAffineTransform(translationX: finalWidth, y: 0)
        }
        
        // Go back to Home screen
        let identify = {fromViewController.view.transform = .identity}
        
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: duration, animations: {self.presents  ? transform() : identify()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
    }
    
}
