//
//  AppDelegate.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import Foundation
import UIKit


func application(_ application: UIApplication, didFinishLaunchingWithOptions launchoptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
    if #available(iOS 13.0, *){
        window?.overrideUserInterfaceStyle = .light
    }
    return true
}
