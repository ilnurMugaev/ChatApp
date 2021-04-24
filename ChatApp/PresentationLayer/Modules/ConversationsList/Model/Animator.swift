//
//  Animator.swift
//  ChatApp
//
//  Created by Ilnur Mugaev on 25.04.2021.
//  Copyright © 2021 Ilnur Mugaev. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration: TimeInterval = 1.0
    
    private let conversationListVC: ConversationListViewController
    private let profileVC: ProfileViewController
    private let fromImageViewSnapshot: UIView
    private let fromImageViewRect: CGRect
    private let navigationBarFrame: CGRect
    
    init?(conversationListVC: ConversationListViewController,
          profileVC: ProfileViewController,
          fromViewSnapshot: UIView,
          navigationBarFrame: CGRect) {
        self.conversationListVC = conversationListVC
        self.profileVC = profileVC
        self.fromImageViewSnapshot = fromViewSnapshot
        self.navigationBarFrame = navigationBarFrame
        
        guard let window = conversationListVC.view.window,
              let userAvatarView = conversationListVC.navigationItem.rightBarButtonItems?[0].customView else { return nil }
        self.fromImageViewRect = userAvatarView.convert(userAvatarView.bounds, to: window)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = profileVC.view else {
            transitionContext.completeTransition(false)
            return
        }
        
        toView.frame = containerView.frame
        toView.alpha = 0
        containerView.addSubview(toView)
        
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = conversationListVC.currentTheme.colors.backgroundColor
        fadeView.alpha = 0
        containerView.addSubview(fadeView)
        
        let navigationBarView = createNavigationBarView()
        navigationBarView.alpha = 0
        containerView.addSubview(navigationBarView)
        
        let navigationBar = createNavigationBar()
        navigationBar.alpha = 0
        containerView.addSubview(navigationBar)

        fromImageViewSnapshot.frame = fromImageViewRect
        containerView.addSubview(fromImageViewSnapshot)

        let toImageViewRect = calculateAvatarViewFrame()
        
        let saveWithGCDButton = createSaveButton(type: .gcd)
        let gcdButtonToFrame = saveWithGCDButton.frame
        let gcdButtonFromFrame = CGRect(x: saveWithGCDButton.center.x, y: saveWithGCDButton.center.y, width: 0, height: 0)
        saveWithGCDButton.frame = gcdButtonFromFrame
        containerView.addSubview(saveWithGCDButton)
        
        let saveWithOperationButton = createSaveButton(type: .operation)
        let operationButtonToFrame = saveWithOperationButton.frame
        let operationButtonFromFrame = CGRect(x: saveWithOperationButton.center.x, y: saveWithOperationButton.center.y, width: 0, height: 0)
        saveWithOperationButton.frame = operationButtonFromFrame
        containerView.addSubview(saveWithOperationButton)
        
        UIView.animateKeyframes(withDuration: Self.duration,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                                        self.fromImageViewSnapshot.frame = toImageViewRect
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                                        fadeView.alpha = 1
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7) {
                                        navigationBarView.alpha = 1
                                        navigationBarView.frame = CGRect(x: 0, y: 0,
                                                                         width: self.navigationBarFrame.width,
                                                                         height: self.navigationBarFrame.height + self.profileVC.view.safeAreaInsets.top)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                                        navigationBar.alpha = 1
                                        saveWithGCDButton.frame = gcdButtonToFrame
                                        saveWithOperationButton.frame = operationButtonToFrame
                                    }
        }, completion: { _ in
            self.fromImageViewSnapshot.removeFromSuperview()
            fadeView.removeFromSuperview()
            navigationBarView.removeFromSuperview()
            navigationBar.removeFromSuperview()
            saveWithGCDButton.removeFromSuperview()
            saveWithOperationButton.removeFromSuperview()
            
            toView.alpha = 1
            
            transitionContext.completeTransition(true)
        })

    }
    
    // MARK: private functions
    private func calculateAvatarViewFrame() -> CGRect {
        let avatarViewWidth: CGFloat = profileVC.backgroundView.avatarViewWidth
        let avatarViewX: CGFloat = profileVC.view.center.x - avatarViewWidth / 2
        let avatarViewY: CGFloat = profileVC.view.safeAreaInsets.top + navigationBarFrame.height + 7
        return CGRect(x: avatarViewX, y: avatarViewY, width: avatarViewWidth, height: avatarViewWidth)
    }
    
    private func createNavigationBarView() -> UIView {
        let navigationBarView = UIView()
        navigationBarView.backgroundColor = conversationListVC.currentTheme.colors.UIElementColor
        
        let navigationBarFrame = conversationListVC.navigationController?.navigationBar.frame ?? CGRect()
        let navigationBarViewHeight = profileVC.view.safeAreaInsets.top + navigationBarFrame.height
        navigationBarView.frame = CGRect(x: 0, y: 0, width: navigationBarFrame.width, height: navigationBarViewHeight)
        
        return navigationBarView
    }
    
    private func createNavigationBar() -> UINavigationBar {
        let navigationBar = UINavigationBar()
        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = .clear
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "My Profile"
        navigationBar.setItems([navigationItem], animated: false)
        
        let navigationBarFrame = conversationListVC.navigationController?.navigationBar.frame ?? CGRect()
        navigationBar.frame = CGRect(x: 0, y: profileVC.view.safeAreaInsets.top, width: navigationBarFrame.width, height: navigationBarFrame.height)
        
        return navigationBar
    }
    
    private func createSaveButton(type: SaveButtonType) -> UIButton {
        let button = UIButton()

        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        button.setTitleColor(conversationListVC.currentTheme.colors.secondaryFontColor, for: .normal)
        button.backgroundColor = conversationListVC.currentTheme.colors.UIElementColor
        
        let buttonY: CGFloat
        switch type {
        case .gcd:
            button.setTitle("Save with GCD", for: .normal)
            buttonY = profileVC.view.frame.maxY - 30 - 40 - 10 - 40
        case .operation:
            button.setTitle("Save with Operation", for: .normal)
            buttonY = profileVC.view.frame.maxY - 30 - 40
        }
        
        let buttonX: CGFloat = 56
        let buttonWidth = profileVC.view.frame.width - 56 * 2
        let buttonHeight: CGFloat = 40
        let buttonFrame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        
        button.frame = buttonFrame
        return button
    }
}

enum SaveButtonType {
    case gcd
    case operation
}
