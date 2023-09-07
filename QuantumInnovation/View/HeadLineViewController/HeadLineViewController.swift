//
//  HeadLineViewController.swift
//  QuantumInnovation
//
//  Created by senthil kumar on 06/09/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class HeadLineViewController: UIViewController {
    
    var newsApiResponse:  NewsApiResponse!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableveiw: UITableView!
    var google = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialLoads()
    }
    
    private func intialLoads(){
        self.navigationController?.navigationBar.isHidden = true
        self.newsApiIntegration()
        self.registerTableView()
        self.logoutButton.addTarget(self, action: #selector(logoutButtonAction(_ :)), for: .touchUpInside)
    }
    
    // MARK: RegisterTableView
    private func registerTableView() {
        tableveiw.delegate = self
        tableveiw.dataSource = self
        tableveiw.separatorStyle = .none
        tableveiw.backgroundColor = .clear
        tableveiw.register(UINib(nibName: "HeadLineTableViewCell", bundle: nil), forCellReuseIdentifier: "HeadLineTableViewCell")
    }
    @objc private func logoutButtonAction(_ sender: UIButton) {
        
        if google{
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                DispatchQueue.main.async {
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    UserDefaults.standard.set(false, forKey: "signIn")
                    UserDefaults.standard.setValue(nil, forKey: "username")
                    UserDefaults.standard.setValue(nil, forKey: "userimg")
                    UserDefaults.standard.setValue(nil, forKey: "emailID")
                    self.navigationController?.popViewController(animated: true)
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }else{
            
            KeychainItem.deleteUserIdentifierFromKeychain()
            // Display the login controller again.
            DispatchQueue.main.async {
                self.showLoginViewController()
            }
        }
        
    }

}
//MARK: TableView
extension HeadLineViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.newsApiResponse?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeadLineTableViewCell", for: indexPath) as? HeadLineTableViewCell
        cell?.selectionStyle = .none
        cell?.setData(articles: self.newsApiResponse.articles?[indexPath.row])
        return cell ?? UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let vc  = storyboard?.instantiateViewController(withIdentifier: "DetailsHeadLineViewController") as! DetailsHeadLineViewController
        vc.titleName = newsApiResponse?.articles?[indexPath.row].title ?? ""
        vc.source = newsApiResponse?.articles?[indexPath.row].source?.name ?? ""
        vc.descriptionDetails = newsApiResponse?.articles?[indexPath.row].description ?? ""
        vc.date = newsApiResponse?.articles?[indexPath.row].publishedAt ?? ""
        vc.imagesUrl = newsApiResponse?.articles?[indexPath.row].urlToImage ?? ""
        
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//MARK: NEWS APi Integration
extension HeadLineViewController {
    
    func newsApiIntegration(){
        
        let apiUrl = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=c9b781a27afe41a59f9f6fe9cdc806ec"
        
        if let url = URL(string: apiUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(NewsApiResponse.self, from: data)
                        self.newsApiResponse = user
                        DispatchQueue.main.async {
                            self.tableveiw.reloadData()
                        }
                        
                    } catch {
                        print("JSON Parsing Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
}
