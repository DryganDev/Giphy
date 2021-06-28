//
//  GiphyRequestFactory.swift
//  GiphyApp
//
//  Created by Artsiom Sazonau on 2.05.21.
//

import Foundation

final class GiphyRequestFactory {
    
    let apiKey = "YZFsew3W6CEwbiyrHin85I9EJfMT5Vxu"
    let baseUrl = URL(string: "https://api.giphy.com/v1/")!
    
    func getTrendingRequest() -> URLRequest? {
        let url = baseUrl
            .appendingPathComponent("gifs")
            .appendingPathComponent("trending")
        var urlComponent = URLComponents(string: url.absoluteString)
        urlComponent?.queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                                    URLQueryItem(name: "limit", value: "25"),
                                    URLQueryItem(name: "rating", value: "g")]
        guard let finalUrl = urlComponent?.url else {
            return nil
        }
        let urlRequest = URLRequest(url: finalUrl)
        return urlRequest
    }
    
}
