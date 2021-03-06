//
//  SceneDelegate.swift
//  Virtual Tourist
//
//  Created by Pierre Younes on 4/4/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let navigationController = window?.rootViewController as! UINavigationController
        let mapVC = navigationController.topViewController as! MapVC
        
        mapVC.dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}

