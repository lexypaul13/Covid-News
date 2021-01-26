//
//  ArticleError.swift
//  Covid News
//
//  Created by Alex Paul on 1/25/21.
//  Copyright © 2021 Alexander Paul. All rights reserved.
//

import Foundation
enum ArticleError: String, Error {
    case invalidURL         = "The URL used created an invalid request. Please try again."
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case invalidData        = "The data received from the server was invalid. Please try again."
}
