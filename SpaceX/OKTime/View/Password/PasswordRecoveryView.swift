//
//  passwordRecovery.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/3/22.
//

import SwiftUI
import ExytePopupView

struct PasswordRecoveryView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var colors: ConstantColors
    
    //Properties
    @EnvironmentObject var loginViewModel : LoginViewModel
    @StateObject var recoverPasswordVm = RecoverPasswordViewModel()
    @State var phoneNumber: String = ""
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    @State private var didTap = false
    
    @State var go = false
    
    
    
    
    var body: some View {
        
            ScrollView {
                VStack(spacing: 20) {
                    
                    //Top Rectangle
                    
                    CustomFlowView(colors: colors, flowDescription: "password_recovery_subheader".localized(language), flowImage: "password-indicator-1", flowBgImage: "")
                        
                            
                        Spacer()
                    
                    
                        //Scan Label
                        VStack {
                            Image("password-logo")
                            Text("password_recovery_header".localized(language))
                                .font(.custom("YekanBakhNoEn-Bold", size: 36))
                                .foregroundColor(colors.lightGrayColor)
                        }
                                        
                            Spacer()
                            //Phone Number View
                    VStack(alignment: .trailing) {
                        
                        
                        PhonenumberView(phoneNumber: $phoneNumber, colors: colors, hasDescription: true, description: "password_recovery_phone_number_description".localized(language))
                        
                    }
                
                        //Send Button
                        Spacer()
                        
                        Button (action: {
                            //Send Request to network
                            hideKeyboard()
                            go = true
                            Task {
                                await recoverPasswordVm.recoverPassword(with: ("98\(phoneNumber)"))
                            }
                        }, label: {
                            GreenFunctionButton(buttonText: "password_recovery_button_text" .localized(language), isAnimated: $recoverPasswordVm.isRequesting)
                                .frame(width: UIScreen.screenWidth - 50 , height: 45)
                            
                        })
                        .padding(.bottom, 10)
                        .padding(.bottom, keyboardResponder.currentHeight)
                        .disabled(recoverPasswordVm.isRequesting)
                }
            }
        
        
            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        
 
            .popup(isPresented: $recoverPasswordVm.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: recoverPasswordVm.errorMessage)
            }, customize: {
                $0
                    .type(.floater())
                    .animation(.spring())
                    .autohideIn(3)
                    .position(.bottom)
            })
        
        
            .background(
                NavigationLink(destination: PasswordRecoveryOTPView(colors: colors, verifyKey: $recoverPasswordVm.accessToken, phoneNumber: $phoneNumber)
                    .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                    .environmentObject(keyboardResponder)
                    .environmentObject(loginViewModel)
                    , isActive: $recoverPasswordVm.isReceived)
                    {
                        EmptyView()
                }
            )
            .ignoresSafeArea(.keyboard , edges: .bottom)
            .edgesIgnoringSafeArea(.top)
        
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: NavigationItemsView(title: "password_recovery_header".localized(language), isBackButtonHidden: false))
        
    }
}

struct passwordRecovery_Previews: PreviewProvider {
    static var constantColors = ConstantColors()
    static var previews: some View {
        PasswordRecoveryView(colors: constantColors)
    }
}
