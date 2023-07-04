//
//  PasswordPopupView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/24/22.
//

import SwiftUI
import ExytePopupView

struct PasswordPopupView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @State var currentPassword = ""
    
    @State var newPassword = ""
    
    @State var repeatedNewPassword = ""
    
    @Binding var isPresented : Bool
    
    @EnvironmentObject var resetPasswordViewModel: ResetPasswordViewModel
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    var colors: ConstantColors
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 10) {
                VStack(spacing: 20) {
                    Image("shield-security")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 85, height: 85)
                    
                    Text("change_password".localized(language))
                        .foregroundColor(colors.blueColor)
                        .font(.system(size: 18, weight: .heavy))
                    
                }
                
                
                CustomTextFieldPopUp(colors: colors, labelName: "current_password".localized(language), placeholder: "current_password_description".localized(language), text: $currentPassword, isPassword: true)
        
                CustomTextFieldPopUp(colors: colors, labelName: "new_password".localized(language), placeholder: "new_password_description".localized(language), text: $newPassword, isPassword: true)
                
                CustomTextFieldPopUp(colors: colors, labelName: "repeat_new_password".localized(language), placeholder: "repeat_new_password_description".localized(language), text: $repeatedNewPassword, isPassword: true)
                

                
                HStack(spacing: 5) {

                    Button {
                        isPresented = false
                    } label: {
                        Text("cancel".localized(language))
                            .foregroundColor(Color.white)
                        
                    }
                    .frame(width: UIScreen.screenWidth / 2.5, height: 45)
                    .background(colors.redColor)
                    .cornerRadius(5)
                    
                    
                    Button {
                        //Start action (send request to server)
                        Task {
                            await resetPasswordViewModel.resetPassword(oldPassword: currentPassword, newPassword: newPassword, repeatedPassword: repeatedNewPassword, completionHandler: { isSuccessful in
                                if isSuccessful {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        isPresented.toggle()
                                    }
                                }
                            })
                        

                        }
                        
                    } label: {
                        Text("confirm".localized(language))
                            .foregroundColor(Color.white)
                    }
                    .frame(width: UIScreen.screenWidth / 2.5, height: 45)
                    .background(colors.darkGreenColor)
                    .cornerRadius(5)
                    


                }
                .padding()
                
                
                

                
            }
            
        }
        
        .popup(isPresented: $resetPasswordViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: resetPasswordViewModel.errorMessage)
        }, customize: {
            $0
                .animation(.spring())
                .autohideIn(3)
                .position(.bottom)
                .type(.floater())
        })
        
        
        
        .padding(.bottom, keyboardResponder.currentHeight / 2)
        .frame(width: UIScreen.screenWidth - 30)
        .frame(height: UIScreen.screenHeight - 250)
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
        
        .background(
            Color.white
        )
        
    }
    
    
    
}

