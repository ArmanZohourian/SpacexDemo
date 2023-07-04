//
//  UserRegisterView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI
import ExytePopupView

struct BusinessRegisterView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var registerViewModel: BusinessRegister
    
    var colors: ConstantColors
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var cityId: String
    @Binding var sexSelection: String
    @Binding var isShwoingSexSelection: Bool
    @Binding var password: String
    @Binding var repPassword: String
    
    var body: some View {
        
        VStack(alignment: .trailing ,spacing: 10) {
            
            CustomRegisterField(colors: colors, labelName: "business_register_name_label".localized(language), placeholder: "business_register_name_placeholder".localized(language), text: $firstName, errorMessage: $registerViewModel.firstNameError, hasError: $registerViewModel.firstNameHasError, isPassword: false)
            
            
            
            CustomRegisterField(colors: colors, labelName: "business_register_last_name_label".localized(language), placeholder: "business_register_last_name_placeholder".localized(language), text: $lastName, errorMessage: $registerViewModel.lastNameError, hasError: $registerViewModel.lastNameHasError, isPassword: false)

            
            CustomSelectionPicker(colors: colors, options: ["business_register_male_sex".localized(language), "business_register_female_sex".localized(language)], selectedValue: $sexSelection, labelText: "business_register_sex_label".localized(language), errorMessage: $registerViewModel.sexError , hasError: $registerViewModel.sexHasError)
                .overlay(alignment: .trailing, content: {
                    Text("select_your_sex".localized(language))
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        .foregroundColor(Color.gray)
                        .padding()
                        .opacity(sexSelection == "" ? 1.0 : 0.0)
                })
                .onTapGesture {
                    withAnimation {
                        hideKeyboard()
                        isShwoingSexSelection.toggle()
                    }
                }
                .onChange(of: sexSelection) { newValue in
                    registerViewModel.sexHasError = false
                }
            
            CustomRegisterField(colors: colors, labelName: "business_register_password_label".localized(language), placeholder: "business_register_password_placeholder".localized(language), text: $password,errorMessage: $registerViewModel.passwordError, hasError: $registerViewModel.passwordHasError, isPassword: true)
            
            
            CustomRegisterField(colors: colors, labelName: "business_register_repeat_password_label".localized(language), placeholder: "business_register_repeat_password_placeholder".localized(language), text: $repPassword ,errorMessage: $registerViewModel.repeatPasswordError, hasError: $registerViewModel.repeatPasswordHasError, isPassword: true)

            
                
                
            
        }
        
        

        
        
    }
}
