//
//  ImageDownloader.swift
//  Covid News
//
//  Created by Alex Paul on 12/28/20.
//  Copyright © 2020 Alexander Paul. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString,AnyObject>()

extension UIImageView {
    
    func downloadImage(from urlString: String ) {
        guard let url = URL(string: urlString) else { return }
        storeCache(url: url)
    }
    
    func storeCache(url:URL){
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
        }else {
            let _: Void = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if error != nil { return }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                        self.image = downloadedImage
                    }
                }
            }.resume()
        }
    }
    
}
