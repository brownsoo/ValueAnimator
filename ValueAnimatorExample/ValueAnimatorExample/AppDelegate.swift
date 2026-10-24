//
//  AppDelegate.swift
//  ValueAnimatorExample
//
//  Created by hyonsoo han on 2018. 5. 3..
//  Copyright © 2018년 Hansoolabs. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Info.plist 의 UIApplicationSceneManifest 에 정의된 "Default Configuration" 을 사용한다.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
