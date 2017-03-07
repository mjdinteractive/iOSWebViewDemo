//
//  Extensions.swift
//  WebViewBlogPost
//
//  Created by Jeffrey Sherin on 3/7/17.
//  Copyright © 2017 Jeff Sherin. All rights reserved.
//

import Foundation

extension URL {

    /**
     This is just for the mainBundle
     */
    static func urlForPath(_ path: String, isDirectory: Bool = false) -> URL? {
        guard let resourcePath = Bundle.main.resourcePath else {
            return nil
        }

        return URL(fileURLWithPath: resourcePath + path, isDirectory: isDirectory)
    }
    
}
