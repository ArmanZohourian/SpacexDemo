//
//  BiometricCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/22/22.
//

import SwiftUI

struct BiometricCellView: View {
    
    @Binding var isActivated: Bool
    
    var logo: String
    
    var name: String
    
    var colors: ConstantColors
    
    var type: AuthenticationType
    
    var userDefaults = UserDefaults.standard
    
    @Binding var isShowingPasscodeSheet: Bool
    
    var body: some View {
        
        
        VStack {
                
            Toggle(isOn: $isActivated) {
                    HStack(spacing: 10) {
                        
                        Image(logo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(name)
                            .foregroundColor(colors.blueColor)
                            .font(.custom("YekanBakhNoEn-SemiBold", size: 16))

                        
                    }
                    .frame(alignment: .leading)
                }
                .environment(\.layoutDirection, .leftToRight)
                .padding()
                .onChange(of: isActivated) { newValue in
                    // save into the userdefault
                    updateBiometric(bioType: type, newValue: newValue)
                }
                    
     
        }
        .frame(width: UIScreen.screenWidth - 10 , height: 50)
        .background(colors.cellColor)
        
        
    }
    
    
    private func updateBiometric(bioType: AuthenticationType, newValue: Bool) {
        
        
        switch type {
            
        case .faceId:
            
            userDefaults.setBiometricStatus(value: newValue)
            
        case .touchId:
            
            userDefaults.setBiometricStatus(value: newValue)
            
        case .passcode:
            //If is passcode activate just turn in off
            if newValue == false {
                //MARK: Deactivating passcode
                
                userDefaults.setPasscodeStatus(value: newValue)
                //Clearing the old passcode from device
                userDefaults.setPasscode(value: "")
            } else {
                //MARK: Activating passcode
                isShowingPasscodeSheet = true
                
            }
    
        default:
            break
            
        }
    }
    
    
}


enum AuthenticationType: String {
    case faceId
    case touchId
    case passcode
}
