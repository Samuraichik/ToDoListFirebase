//
//  ViewController.swift
//  toDoListFirebase2
//
//  Created by User on 11.04.2021.
//

import UIKit
import FBSDKLoginKit
import Firebase
import FacebookCore
import FacebookLogin
import GoogleSignIn

class RootViewController: UIViewController{
    // MARK: - IBOutlets
    
    @IBOutlet private var sighnInButton: GIDSignInButton!
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  ((AccessToken.current == nil) && (GIDSignIn.sharedInstance()?.currentUser == nil)) {
            logInWithFacebook()
            loginWithGoogle()
        } else {
            performSegue(withIdentifier: "todoListSegue", sender: nil)
            logInWithFacebook()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction private func logOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        
        let fireBase = Auth.auth()
        do{
            try fireBase.signOut()
        }catch {
            print(error)
            return
        }
        
        print("SignOut")
    }
    
    @IBAction private func doneButton(_ sender: Any) {
        if  ((AccessToken.current != nil)
            || (GIDSignIn.sharedInstance()?.currentUser != nil)) {
            performSegue(withIdentifier: "todoListSegue", sender: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "First you need to Sign In", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - Extensions

extension RootViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let accessToken = AccessToken.current?.tokenString else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (user, err) in
            if let err = err{
                print(err.localizedDescription)
                return
            }
            print("Succesfully authenticated in facebook")
        }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseProvider.shared.getData(userId: userId)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {}
    
    func logInWithFacebook() {
        let loginButton = FBLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 120 , y: 420, width: view.frame.width - 250, height: 40)
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
    }
    
    func loginWithGoogle()  {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseProvider.shared.getData(userId: userId)
    }
}
