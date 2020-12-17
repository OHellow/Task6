//
//  Transition_Driver.swift
//  TODO
//
//  Created by Satsishur on 16.12.2020.
//

import Foundation
import UIKit

enum TransitionDirection {
    case present, dismiss
}

class TransitionDriver: UIPercentDrivenInteractiveTransition {
    func link(to controller: UIViewController) {
        presentedController = controller
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }
    
    // MARK: - Override
    override var wantsInteractiveStart: Bool {
        get {
            switch direction {
            case .present:
                return false
            case .dismiss:
                let gestureIsActive = panRecognizer?.state == .began
                return gestureIsActive
            }
        }
        
        set { }
    }
    
    // MARK: - Direction
    var direction: TransitionDirection = .present
    
    @objc private func handle(recognizer r: UIPanGestureRecognizer) {
        switch direction {
        case .present:
            handlePresentation(recognizer: r)
        case .dismiss:
            handleDismiss(recognizer: r)
        }
    }

    private var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?
    
    private func handlePresentation(recognizer r: UIPanGestureRecognizer) {
        switch r.state {
        case .began:
            pause()
        case .changed:
            let increment = -r.incrementToBottom(maxTranslation: maxTranslation)
            update(percentComplete + increment)
            
        case .ended, .cancelled:
            if r.isProjectedToDownHalf(maxTranslation: maxTranslation) {
                cancel()
            } else {
                finish()
            }
            
        case .failed:
            cancel()
            
        default:
            break
        }
    }
    
    private func handleDismiss(recognizer r: UIPanGestureRecognizer) {
        switch r.state {
        case .began:
            pause() // Pause allows to detect isRunning
            
            if !isRunning {
                presentedController?.dismiss(animated: true) // Start the new one
            }
        
        case .changed:
            update(percentComplete + r.incrementToBottom(maxTranslation: maxTranslation))
            
        case .ended, .cancelled:
            if r.isProjectedToDownHalf(maxTranslation: maxTranslation) {
                finish()
            } else {
                cancel()
            }

        case .failed:
            cancel()
            
        default:
            break
        }
    }
    
    var maxTranslation: CGFloat {
            return presentedController?.view.frame.height ?? 0
    }
    
    /// `pause()` before call `isRunning`
    private var isRunning: Bool {
        return percentComplete != 0
    }
}

private extension UIPanGestureRecognizer {
    func incrementToBottom(maxTranslation: CGFloat) -> CGFloat {
        let translation = self.translation(in: view).y
        setTranslation(.zero, in: nil)

        let percentIncrement = translation / maxTranslation
        return percentIncrement
    }
    
    func isProjectedToDownHalf(maxTranslation: CGFloat) -> Bool {
        let endLocation = projectedLocation(decelerationRate: .fast)
        let isPresentationCompleted = endLocation.y > maxTranslation / 2

        return isPresentationCompleted
    }

    func projectedLocation(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        let velocityOffset = velocity(in: view).projectedOffset(decelerationRate: .normal)
        let projectedLocation = location(in: view!) + velocityOffset
        return projectedLocation
    }
}

extension CGPoint {
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGPoint {
        return CGPoint(x: x.projectedOffset(decelerationRate: decelerationRate),
                      y: y.projectedOffset(decelerationRate: decelerationRate))
    }
}

extension CGFloat { // Velocity value
    func projectedOffset(decelerationRate: UIScrollView.DecelerationRate) -> CGFloat {
        // Magic formula from WWDC
        let multiplier = 1 / (1 - decelerationRate.rawValue) / 1000
        return self * multiplier
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x,
                      y: left.y + right.y)
    }
}
