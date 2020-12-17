//
//  Note_Presenation_C.swift
//  TODO
//
//  Created by Satsishur on 16.12.2020.
//

import UIKit

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    //private let driver = TransitionDriver()
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        //driver.link(to: presented)

        let presentationController = DimmPresentationController(presentedViewController: presented, presenting: presenting)
        //presentationController.driver = driver
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation()
    }
    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return driver
//    }
    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return driver
//    }
}

class PresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = containerView!.bounds
        let halfHeight = bounds.height / 3
        return CGRect(x: 15,
                      y: halfHeight,
                      width: bounds.width - 30,
                      height: halfHeight)
    }
    
    override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.addSubview(presentedView!)
        
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    //var driver: TransitionDriver!
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
//        if completed {
//            driver.direction = .dismiss
//        }
    }
}

class DimmPresentationController: PresentationController {
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        containerView?.insertSubview(dimmView, at: 0)
        
        
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        dimmView.frame = containerView!.frame
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
    
    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }
            
        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }
    
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.alpha = 0
        view.addGestureRecognizer(
                    UITapGestureRecognizer(target: self, action: #selector(didTap(tap:)))
                )
        return view
    }()
    
    @objc func didTap(tap: UITapGestureRecognizer) {
           presentedViewController.dismiss(animated: true, completion: nil)
       }
}
