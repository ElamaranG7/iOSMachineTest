//
//  DetailsHeadLineViewController.swift
//  QuantumInnovation
//
//  Created by mymac on 07/09/23.
//

import UIKit

class DetailsHeadLineViewController: UIViewController {

    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var source = ""
    var titleName = ""
    var date = ""
    var descriptionDetails = ""
    var imagesUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intialLoads()

        // Do any additional setup after loading the view.
    }


    func intialLoads(){
        backButton.addTarget(self, action: #selector(backButtonAction(_ :)), for: .touchUpInside)
        self.sourceNameLabel.text = source
        self.titleNameLabel.text = titleName
        self.descriptionLabel.text = descriptionDetails
          
          let inputDateString = "\(date)"
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
          
          if let date = formatter.date(from: inputDateString) {
              formatter.dateFormat = "yyyy-MM-dd"
              var outputDateString = formatter.string(from: date)
              print(outputDateString)
              self.dateLabel.text = outputDateString
          }
          
          
          self.urlImage.setImage(with: imagesUrl, placeHolder: #imageLiteral(resourceName: "news-placeholder"))
    
}
    @objc func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   

}
