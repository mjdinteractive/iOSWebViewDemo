//
//  APIClient.swift
//  WebViewBlogPost
//
//  Created by Jeffrey Sherin on 3/7/17.
//  Copyright © 2017 Jeff Sherin. All rights reserved.
//

import Foundation

struct APIClient {


    static func getRemoteHTML(_ completion: @escaping (_ html: String?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/mjdinteractive/iOSWebViewDemo/master/WebViewBlogPost/FightClub.html") else {
            completion(nil, nil)
            return
        }

        let request = URLRequest(url: url)

        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data,
                let html = String(data: data, encoding: .utf8) {
                completion(html, nil)
            } else {
                completion(nil, error)
            }
        }

        dataTask.resume()
    }



}
