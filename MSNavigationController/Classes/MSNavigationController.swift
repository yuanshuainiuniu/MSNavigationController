//
//  MSNavigationController.swift
//
//  Created by Marshal on 2019/10/30.
//  Copyright © 2019 Cocoapod. All rights reserved.
//

import UIKit

@objc public protocol MSNavgationControllerProtocol {
    func ms_backItemDidClicked()
    
    @objc optional
    func ms_willPushViewController()
}

extension UINavigationController {
    @objc public func preInitRoot() {
        if let vc = self.viewControllers.first {
            vc.view.backgroundColor = UIColor.white
        }
    }
}

@objc(MSNavgationController)
open class MSNavgationController: UINavigationController {
    var fullscreenPopGR:UIPanGestureRecognizer!
    var popGestureRecognizerDelegate: MSFullscreenPopGestureRecognizerDelegate!
    var viewControllerBasedNavigationBarAppearanceEnabled = true
    lazy var lineView:UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        return lineView
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UIViewController.initializeOnceMethod()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        UIViewController.initializeOnceMethod()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        UIViewController.initializeOnceMethod()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.shadowImage = UIImage()
        
        fullscreenPopGR = UIPanGestureRecognizer()
        fullscreenPopGR.maximumNumberOfTouches = 1
        
        popGestureRecognizerDelegate = MSFullscreenPopGestureRecognizerDelegate()
        popGestureRecognizerDelegate.navigationController = self
        
        self.navigationBar.addSubview(self.lineView)
        
        
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.lineView.frame = CGRect(x: 0, y: self.navigationBar.frame.size.height - 0.5, width: self.navigationBar.frame.size.width, height: 0.5)
        for subView in self.navigationBar.subviews {
            for ssView in subView.subviews {
                if ssView.bounds.height <= 1 {
                    ssView.isHidden = true
                    break
                }
            }
        }
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let ineractivePopGR =  interactivePopGestureRecognizer,
           let grs = ineractivePopGR.view?.gestureRecognizers{
            if grs.contains(fullscreenPopGR) == false {
                ineractivePopGR.view!.addGestureRecognizer(fullscreenPopGR)
                if let targets = ineractivePopGR.value(forKey: "targets") as? [AnyObject] {
                    if let target = targets.first {
                        let internalTarget = target.value(forKey: "target")!
                        let sel = NSSelectorFromString("handleNavigationTransition:")
                        fullscreenPopGR.delegate = popGestureRecognizerDelegate
                        fullscreenPopGR.addTarget(internalTarget, action: sel)
                        ineractivePopGR.isEnabled = false
                    }
                }
            }
        }
        
        
        if viewControllerBasedNavigationBarAppearanceEnabled == true {
            let callback:(UIViewController, Bool)->() = { [weak self] (vc, animation) in
                if let sself = self {
                    sself.setNavigationBarHidden(vc.ms_navigationBarHidden, animated: animation)
                    if !vc.ms_hiddenNavigationBarLine {
                        sself.lineView.isHidden = false
                    } else {
                        sself.lineView.isHidden = true
                    }
                }
            }
            viewController.ms_ViewControllerWillAppearInjectCallback = callback
            if let vc = viewControllers.last, vc.ms_ViewControllerWillAppearInjectCallback == nil{
                vc.ms_ViewControllerWillAppearInjectCallback = callback
            }
        }
        
        if let vc = self.viewControllers.last {
            if let delegate = vc as? MSNavgationControllerProtocol {
                delegate.ms_willPushViewController?()
            }
        }
        
        if (viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        return  super.popViewController(animated: animated)
    }
    
    @objc func backButtonClicked() {
        
        if let vc = self.viewControllers.last {
            if let delegate = vc as? MSNavgationControllerProtocol {
                delegate.ms_backItemDidClicked()
                return
            }
        }
        
        _ = popViewController(animated: true)
    }
}



extension UIViewController {
    struct AssociatedKeys {
        static var popDisabled: UInt8 = 0
        static var navigationBarHidden: UInt8 = 0
        static var willAppearInjectCallback: UInt8 = 0
        static var hiddenLine: UInt8 = 0
        static var disableFullscreenPopGR:UInt8 = 0
        static var nteractivePopMaxAllowedInitialDistanceToLeftEdge:UInt8 = 0
    }
    ///隐藏导航栏线
    @objc public var ms_hiddenNavigationBarLine:Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.hiddenLine) as? Bool {
                return value
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.hiddenLine, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            if let navigationController = self.navigationController as? MSNavgationController {
                navigationController.lineView.isHidden = newValue
            }
            
        }
    }
    ///设置手势返回识别距离屏幕最小距离，默认全屏
    @objc public var ms_interactivePopMaxAllowedInitialDistanceToLeftEdge:CGFloat {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.nteractivePopMaxAllowedInitialDistanceToLeftEdge) as? CGFloat {
                return value
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.nteractivePopMaxAllowedInitialDistanceToLeftEdge, max(0, newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    ///禁用手势返回
    @objc public var ms_interactivePopDisabled:Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.popDisabled) as? Bool {
                return value
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.popDisabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    ///禁用全屏手势返回
    @objc public var ms_disableFullscreenPopGR:Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.disableFullscreenPopGR) as? Bool {
                return value
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.disableFullscreenPopGR, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            self.ms_interactivePopMaxAllowedInitialDistanceToLeftEdge = newValue ? 44 : 0
        }
    }
    
    @objc public var ms_navigationBarHidden:Bool {
        get {
            if let value = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarHidden) as? Bool {
                return value
            }
            return false
        }
        set {
            if let nav = self.navigationController, nav.viewControllers.count <= 1 {
                nav.setNavigationBarHidden(true, animated: false)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.navigationBarHidden, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}


class MSFullscreenPopGestureRecognizerDelegate :NSObject, UIGestureRecognizerDelegate {
    weak var navigationController:UINavigationController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = navigationController else {
            return false
        }
        
        if nav.viewControllers.count <= 1 {
            return false
        }
        if let top = nav.viewControllers.last, top.ms_interactivePopDisabled {
            return false
        }
        if let _isTransitioning = nav.value(forKey: "_isTransitioning") as? Bool {
            if _isTransitioning {
                return false
            }
        }
        
        if let panGR = gestureRecognizer as? UIPanGestureRecognizer,
            let view = gestureRecognizer.view {
            if panGR.translation(in: view).x < 0 {
                return false
            }
            if let top = nav.viewControllers.last{
                let beginningLocation = panGR.location(in: view)
                let maxAllowedInitialDistance = top.ms_interactivePopMaxAllowedInitialDistanceToLeftEdge
                if maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance{
                    return false
                }
            }
           
            
            
            
        } else {
            return false
        }
        
        return true
    }
}

extension UIViewController {
    var ms_ViewControllerWillAppearInjectCallback:((UIViewController, Bool)->())? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.willAppearInjectCallback, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.willAppearInjectCallback) as? (UIViewController, Bool)->()
        }
    }
    
    static var once = false
    @objc public class func initializeOnceMethod() {
        objc_sync_enter(self)
        if (!once) {
            if let before: Method = class_getInstanceMethod(self, #selector(self.viewWillAppear(_:))),
                let after: Method  = class_getInstanceMethod(self, #selector(self.ms_viewWillAppear(_:))) {
                method_exchangeImplementations(before, after)
                once = true
            }
        }
        objc_sync_exit(self)
    }
    
    @objc func ms_viewWillAppear(_ animated: Bool) {
        self.ms_viewWillAppear(animated) // forward
        
        self.ms_ViewControllerWillAppearInjectCallback?(self, animated)
    }
}

