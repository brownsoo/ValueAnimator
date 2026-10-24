//
//  SceneDelegate.swift
//  ValueAnimatorExample
//
//  Copyright © 2026년 Hansoolabs. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // Info.plist 의 UISceneStoryboardFile(Main) 로 window 와 루트 뷰컨트롤러가 자동 생성된다.
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard scene is UIWindowScene else { return }
    }
}
