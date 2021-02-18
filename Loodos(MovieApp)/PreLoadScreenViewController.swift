//
//  PreLoadScreenViewController.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Connectivity

class PreLoadScreenViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    let connectivity = Connectivity()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingActivityIndicator.startAnimating()
        checkInternetConnectionStatus()
        companyNameLabel.text = ""
    }
    
    func checkInternetConnectionStatus() {
        connectivity.checkConnectivity { connectivity in
            
            switch connectivity.status {
            case .notConnected,
                 .connectedViaWiFiWithoutInternet,
                 .connectedViaCellularWithoutInternet:
                
                self.showError(messageTitle: connectivity.status.description,
                               messageAlert: "Error!",
                               messageBoxStyle: .alert,
                               alertActionStyle: .default,
                               completionHandler: self.checkInternetConnectionStatus)
                
            case .connected,
                 .connectedViaCellular,
                 .connectedViaWiFi:
                self.goToMainPage()
            case .determining:
                break
            }
        }
    }
    
    func showError(messageTitle: String, messageAlert: String, messageBoxStyle: UIAlertController.Style, alertActionStyle: UIAlertAction.Style, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: messageTitle, message: messageAlert, preferredStyle: messageBoxStyle)
        
        let okAction = UIAlertAction(title: "Retry", style: alertActionStyle) { _ in
            completionHandler()
        }
        
        //        let closeAction = UIAlertAction(title: "Close App", style: .destructive) { _ in
        //            // DO IT LATER!
        //            var a: String?
        //            print(a!.count)
        //        }
        
        alert.addAction(okAction)
        //        alert.addAction(closeAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func goToMainPage() {
        showCompanyName()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.changeRootViewController()
        })
    }
    
    func showCompanyName() {
        loadingActivityIndicator.isHidden = true
        //            ref.child("companyTitle").observeSingleEvent(of: .value) { (snapshot) in
        //                let companyTitle = snapshot.value as? String
        //                self.companyNameLabel.text = companyTitle
        //            }
        companyNameLabel.text = "Esay"
        companyNameLabel.isHidden = false
    }
    
    func changeRootViewController() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let navController = mainStoryBoard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = navController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
}


