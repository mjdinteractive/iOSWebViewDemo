//
//  ViewController.swift
//  WebViewBlogPost
//
//  Created by Jeffrey Sherin on 3/7/17.
//  Copyright © 2017 Jeff Sherin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)

        // pin the webView edges to the containerView edges
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

        loadLocal()
    }

    fileprivate func loadLocal() {
        let html = getAgencyTemplate()
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }


}

extension ViewController {

    /**
     Gets the HTML Template where values will be substituted into
     */
    func getAgencyTemplate() -> String {
        guard let fileURL = URL.urlForPath("/FightClub.html") else {
            return ""
        }

        do {
            return try String(contentsOf: fileURL)
        } catch {
            return ""
        }
    }


}

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

