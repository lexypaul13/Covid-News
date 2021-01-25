//
//  ImageDownloader.swift
//  Covid News
//
//  Created by Alex Paul on 12/28/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit


extension UIImageView {
    
    func downloadImage(from urlString: String ) { //downloads image(2)
        let cache   = NSCache<NSString, UIImage>()
        let cacheKey = NSString(string: urlString) //creates cacheKey to store in image variable
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            //check for errors
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            cache.setObject(image, forKey: cacheKey) //stores image in cache
            DispatchQueue.main.async { self.image = image } //shows image on main thread
        }
        task.resume()
    }

}
