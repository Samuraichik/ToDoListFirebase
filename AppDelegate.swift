//
//  AppDelegate.swift
//  toDoListFirebase2
//
//  Created by User on 11.04.2021.
//

import UIKit
import FBSDKCoreKit
import Firebase
import FacebookCore
import FacebookLogin
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
var window: UIWindow?
let userDefaults = UserDefaults()
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance()?.delegate = self
    ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: launchOptions)
    return true
}
      
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
        app,
        open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        GIDSignIn.sharedInstance()?.handle(url)
    return true
}
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, err) in
            if let err = err{
                print(err.localizedDescription)
                return
            }

            print("Succesfully authenticated in google")
        }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseProvider.shared.getData(userId: userId)
        print("OUTFB")
    }
    
    
}




