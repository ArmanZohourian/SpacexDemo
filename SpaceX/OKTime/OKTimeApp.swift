//
//  OKTimeApp.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI
import IQKeyboardManager

@main
struct OKTimeApp: App {
    
    
    
    init() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }

    @AppStorage("language")
    
    
    private var language = LocalizationService.shared.language
    
    static var colors = ConstantColors()
    
    @StateObject var baseViewModel = BaseViewModel()
    
    var body: some Scene {
 
        WindowGroup {


                if baseViewModel.isLoggedIn {

                    //If passcode is activated
                    if baseViewModel.isPasscodeActivated {
                        //Check if it is unlocked
                        if baseViewModel.isUnlocked {
                            RootHomeView(colors: OKTimeApp.colors)
                                .id(baseViewModel.appState)
                                .environmentObject(baseViewModel)
                                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)


                        } else {
                            PasscodeField(isLoginView: true, isAuthenticated: $baseViewModel.isUnlocked, isPresented: $baseViewModel.isPasscodeActivated)
                                .onAppear {
                                    if UserDefaults.standard.getBiometricStatus() {
                                        baseViewModel.authenticate()
                                    }
                                    
                                }
                        }


                    } else {

                        RootHomeView(colors: OKTimeApp.colors)
                            .id(baseViewModel.appState)
                            .environmentObject(baseViewModel)
                            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)

                    }


                    //if not activate show the home view
                } else {

                    LoginView()
                        .environmentObject(baseViewModel)
                        .id(baseViewModel.appState)

                }






        }
        
        
        
    }
}



