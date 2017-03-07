//
//  Protocols.swift
//  WebViewBlogPost
//
//  Created by Jeffrey Sherin on 3/7/17.
//  Copyright © 2017 Jeff Sherin. All rights reserved.
//

import UIKit
import MessageUI

/**
 For view controller, will present the system's Mail app
 If no mail account is configured, it will present a popup telling user
 */
protocol SendsEmail {

    func showEmail<T: UIViewController> (_ viewController: T, recipients: [String], subject: String, body: String?) where T:MFMailComposeViewControllerDelegate

}

extension SendsEmail where Self: UIViewController {

    func showEmail<T: UIViewController> (_ viewController: T, recipients: [String], subject: String, body: String?) where T:MFMailComposeViewControllerDelegate {

        if MFMailComposeViewController.canSendMail() {
            // I can't get the status bar text to be white with MFMail so we'll just make the nav bar light

            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = viewController
            mail.setToRecipients(recipients)
            mail.setSubject(subject)

            if let body = body {
                mail.setMessageBody(body, isHTML: false)
            }

            viewController.present(mail, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No e-mail configured", message: "Please configure an e-mail account in the Mail app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}

