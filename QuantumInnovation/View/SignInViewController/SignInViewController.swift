//
//  SignInViewController.swift
//  QuantumInnovation
//
//  Created by senthil kumar on 06/09/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isSignIn = UserDefaults.standard.bool(forKey: "signIn")
        if isSignIn {
            
            self.pushHeadLineVC()
            
        }
    }
    
    func initialLoads() {
        googleLoginButton.addTarget(self, action: #selector(googleLoginButtonAction(_ :)), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonAction(_ :)), for: .touchUpInside)
    }
    
    @objc func googleLoginButtonAction(_ sender: UIButton) {
        createAuthcredential()
    }
    @objc func appleLoginButtonAction(_ sender: UIButton) {
        
    }
    func pushHeadLineVC(){
        
        let headLineViewController = self.storyboard!.instantiateViewController(withIdentifier: "HeadLineViewController") as! HeadLineViewController
        self.navigationController?.pushViewController(headLineViewController, animated: true)
    }
    
}

//MARK: Google Sign In
extension SignInViewController {
    
    func createAuthcredential(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let Credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: Credential) { result, error in
                
                let username = result?.user.displayName ?? ""
                let emailID = result?.user.email ?? ""
                let userimg = result?.user.photoURL
                
                UserDefaults.standard.set(true, forKey: "signIn")
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set("\(userimg)", forKey: "userimg")
                UserDefaults.standard.set(emailID, forKey: "emailID")
                self.pushHeadLineVC()
            }
            
        }
        
    }
}
