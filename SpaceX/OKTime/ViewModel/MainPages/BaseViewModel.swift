//
//  BaseViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/23/22.
//

import Foundation
import LocalAuthentication
import CoreTelephony

///Base ViewModel :
///Intiiates when app runs and get injected throught the main views of the app
///as an environment object
///check authentication , the token and the carrier 
open class BaseViewModel: ObservableObject {
    
    
    
    
    @Published var isUnlocked = false {
        didSet {
            print("isUnlocked has been changed to: \(isUnlocked)")
        }
    }
    
    @Published var isPasscodeActivated = UserDefaults.standard.getPasscodeStatus()
    
    var isBiometricActivated = UserDefaults.standard.getBiometricStatus()
    
    @Published var isLoggedIn : Bool = false {
        didSet {
            print("New value of login state is:\(isLoggedIn)")
        }
    }
    
    @Published var isIRCarrier = false
    
    @Published var networkWatchtower = NetworkMonitor.shared
    
    
    @Published var appState = UUID() {
        didSet {
            print("New value of app state is: \(appState)")
        }
    }
    
    
    
    init() {
        isToken()

    }
    
    private func isToken() {
        
        if UserDefaults.standard.getToken() != "" {
            isLoggedIn = true
            
            
        } else {
            isLoggedIn = false
            
        }

    }
    
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    DispatchQueue.main.async { [weak self] in
                        self?.isPasscodeActivated = false
                        self?.isUnlocked = true
                    }

                } else {
                    // there was a problem
                    //Throw error and ask for passcode
                }
            }
        } else {
            // no biometrics
        }
    }

    
    func isIR() -> Bool {
    
    let carriers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders?.values
    
    return carriers?.contains { $0.isoCountryCode?.lowercased() == "ir" } ?? false
    
}
    
    func isPasswordValid(withPassword password: String) -> Bool {
        
        
        let valiadator = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&]).{8,}$")

        return valiadator.evaluate(with: password) // True else False
        
    }
    
    func isFieldValid(with fieldCridential: String) -> Bool {
        
        if fieldCridential == "" {
            return false
        } else {
            return true
        }
        
    }
    
    
    
    
    
    
    
}


