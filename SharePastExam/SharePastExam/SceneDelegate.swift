//
//  SceneDelegate.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/15.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var authListener:AuthStateDidChangeListenerHandle?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        autoLogtin()
        //guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    //MARK: - Autologin
    func autoLogtin(){
        //アタッチしたタイミングと、認証状態が変わる毎に呼ばれるListenerをセット
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            //その後呼ばれないようにデタッチする
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            if user != nil {
                DispatchQueue.main.async {
                    //ログインされているのでメインのViewへ
                    self.gotoApp()
                }
            }else{
                //認証されていなければ初期画面表示
                guard let _ = (self.scene as? UIWindowScene) else { return }
            }
        })
    }

    func gotoApp(){
        //認証されていればメインのViewに遷移
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
        window?.rootViewController = vc
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

