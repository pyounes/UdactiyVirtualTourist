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
    
    // MARK: Push LocationVC
    func pushImageCollectionVC(pin: Pin, dataController: DataController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ImageCollectionVC") as ImageCollectionVC
        vc.pin = pin
        vc.dataController = dataController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
