//
//  UIViewController+Extension.swift
//  On The Map
//
//  Created by Pierre Younes on 3/15/21.
//

import UIKit


extension UIViewController {
    
    // MARK: Show alerts
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    //MARK: - Open URLs
    func openLink(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showAlert(message: "Cannot open the link", title: "Error")
        }
    }
    
    // MARK: Push LocationVC
    func pushImageCollectionVC(images: [Image]) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ImageCollectionVC") as ImageCollectionVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Show Spinner
    func showSpinnerView() {
        let child = SpinnerVC()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
