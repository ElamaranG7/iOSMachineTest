//
//  CommonFunction.swift
//  QuantumInnovation
//
//  Created by senthil kumar on 06/09/23.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(with urlString : String?,placeHolder placeHolderImage : UIImage?) {
        self.image = placeHolderImage
        guard urlString != nil, let imageUrl = URL(string: urlString!) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard data != nil, let imagePic = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                return
            }
            DispatchQueue.main.async {
                self.image = imagePic
            }
//            Cache.shared.setObject(imagePic, forKey: responseUrl as AnyObject)
        }.resume()
    }
}

