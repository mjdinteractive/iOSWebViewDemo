//
//  ViewController.swift
//  WebViewBlogPost
//
//  Created by Jeffrey Sherin on 3/7/17.
//  Copyright © 2017 Jeff Sherin. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class ViewController: UIViewController, SendsEmail {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        containerView.addSubview(webView)

        // pin the webView edges to the containerView edges
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

        // toggle these to switch between local and network
//        loadNetwork()
        loadLocal()
    }

    fileprivate func loadNetwork() {
        APIClient.getRemoteHTML { [weak self] (html, error) in
            guard let html = html else {
                self?.showErrorAlert(error: error)
                return
            }

            self?.showHTML(html: html)
        }

    }

    fileprivate func showErrorAlert(error: Error?) {
        let errorText = error?.localizedDescription ?? ""
        let alert = UIAlertController(title: "Error loading HTML", message: errorText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)

    }

    fileprivate func loadLocal() {
        let html = getAgencyTemplate()
        showHTML(html: html)
    }

    fileprivate func showHTML(html: String) {
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
        spinner.stopAnimating()
    }

    /**
     Gets the HTML Template where values will be substituted into
     */
    fileprivate func getAgencyTemplate() -> String {

        // refer to Extensions.swift for 'urlForPath'
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

extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - WKWebView Delegate Methods

extension ViewController: WKNavigationDelegate {

    /**
     Handles all requests from inside the embeddedWebView.
     Note, this is in case the HTML content has any hyperlinks. In our case, these are phone numbers and emails, so we detect them and handle them.
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                let app = UIApplication.shared
                // we only allow tel and mailto
                if url.scheme == "tel" && app.canOpenURL(url) {
                    // It's a telephone, so just let iOS handle it
                    app.open(url, options: [:], completionHandler: nil)
                } else if url.scheme == "mailto" {
                    // It's an email, so extract the email address from the URL, then fire up our email service view
                    let emailAddress = url.absoluteString.replacingOccurrences(of: url.scheme! + ":", with: "")
                    showEmail(self,
                              recipients: [emailAddress],
                              subject: "Changing my fight club details",
                              body: "I would like to change these fight club details:")
                }
            }
            // Regardless of the LINK it was, we cancel the WKWebView action since we either will ignore OR we handled above via app.openUrl
            decisionHandler(.cancel)

        } else {

            // It's not a link, so we allow whatever this is (could be refresh, page load, etc)
            decisionHandler(.allow)
        }
    }
    
}

