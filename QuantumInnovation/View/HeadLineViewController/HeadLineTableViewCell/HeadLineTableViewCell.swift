//
//  HeadLineTableViewCell.swift
//  QuantumInnovation
//
//  Created by senthil kumar on 06/09/23.
//

import UIKit

class HeadLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var TitleNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(articles: Articles?) {
        self.TitleNameLabel.text = articles?.title ?? ""

        let inputDateString = "\(articles?.publishedAt ?? "")"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: inputDateString) {
            formatter.dateFormat = "yyyy-MM-dd"
            var outputDateString = formatter.string(from: date)
            print(outputDateString)
            self.dateLabel.text = outputDateString
        }

        self.sourceNameLabel.text = articles?.source?.name ?? ""
        self.urlImage.setImage(with: articles?.urlToImage, placeHolder: #imageLiteral(resourceName: "google"))
    }
    
}
