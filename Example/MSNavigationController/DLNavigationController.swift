//
//  DLNavigationController.swift
//  CloudCity
//
//  Created by marshal on 2021/4/14.
//  Copyright © 2021 CC. All rights reserved.
//

import UIKit
import MSNavigationController
public class DLNavigationController: MSNavgationController ,UINavigationBarDelegate,UINavigationControllerDelegate{

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.dl_color(withHexString: "333333")
        navBar.isTranslucent = false
        let image = UIImage.dl_loadImage("navi_back", module: nil)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white;
            appearance.setBackIndicatorImage(image, transitionMaskImage: image)
            navBar.scrollEdgeAppearance = appearance
            navBar.standardAppearance = appearance
        } else {
            navBar.backIndicatorImage = image
            navBar.backIndicatorTransitionMaskImage = image
            navBar.barTintColor = UIColor.white
            let bgimage = UIImage.imageFromColor(color: UIColor.white, viewSize: CGSize(width: 1 , height: 1))
            navBar.setBackgroundImage(bgimage, for: .defaultPrompt)
        };
        
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, didPush item: UINavigationItem) {
        item.setValue("", forKey: "backButtonTitle")
    }
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            let backVC = self.viewControllers.last
            let backButtonItem = UIBarButtonItem()
            backButtonItem.title = ""
            backVC?.navigationItem.backBarButtonItem = backButtonItem
        }
        super.pushViewController(viewController, animated: animated)
    }
}
