//
//  PreLoadScreenViewController.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Connectivity
import FirebaseDatabase

class PreLoadScreenViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var companyNameLabel: UILabel!
    
    let connectivity = Connectivity()
    let ref = Database.database().reference()
    
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
                self.showCompanyName()
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
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func goToMainPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.changeRootViewController()
        })
    }
    
    func showCompanyName() {
        ref.child("companyTitle").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            self.loadingActivityIndicator.isHidden = true
            let companyTitle = snapshot.value as? String
            self.companyNameLabel.text = companyTitle
            self.companyNameLabel.isHidden = false
            self.goToMainPage()
        }
    }
    
    func changeRootViewController() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let navController = mainStoryBoard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = navController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
}


