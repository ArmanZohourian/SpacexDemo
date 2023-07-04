//
//  CreatePasswordView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/3/22.
//

import SwiftUI

struct CreatePasswordView: View {
    
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var loginViewModel : LoginViewModel
    
    var colors: ConstantColors
    @EnvironmentObject var baseViewModel : BaseViewModel
    //Properties
    @StateObject var updatePasswordViewModel : UpdatePasswordViewModel = UpdatePasswordViewModel()
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    @State private var didTap = false
    @State var password = ""
    @State var repeatPassword = ""
    @Binding var accessToken : String
    
    
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 5) {
                    //Top Rectangle
                    VStack(alignment: .trailing, spacing: 10) {
                                        Spacer()
//
                                            
                                        Text("create_new_password_subheader".localized(language))
                                            .font(.custom("YekanBakhNoEn-Regular", size: 16))
                                            .padding()
                                        
        
                                        Image("password-indicator-3")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: UIScreen.screenWidth - 30, height: UIScreen.screenHeight / 22)
                                    }
                            .padding()
                            .foregroundColor(colors.whiteColor)
                            .background(colors.blueColor)
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 4)
                            .ignoresSafeArea()
                        

                        //Scan Label
                        VStack {
                            Image("password-logo")
                            Text("create_new_password_header".localized(language))
                                .font(.custom("YekanBakhNoEn-Bold", size: 36))
                                .foregroundColor(colors.lightGrayColor)
                        }
                        Spacer()
                        //Phone Number View
                        VStack(alignment: .trailing) {
                            
                            CustomTextField(colors: colors, labelName: "create_new_password_label".localized(language), placeholder: "create_new_password_placeholder".localized(language), text: $password, isPassword: true)
                            
                            CustomTextField(colors: colors, labelName: "create_new_password_repeat_label".localized(language), placeholder: "create_new_password_repeat_placeholder".localized(language), text: $repeatPassword, isPassword: true)
                        }
                
                
                Spacer()
            
                //Send Button
                Button (action: {
                    //Send Request to network

                    hideKeyboard()
                    Task {
                        await updatePasswordViewModel.updatePassword(with: password, repeatedPassword: repeatPassword ,accessToken: accessToken)
                    }
   
                }, label: {
                    GreenFunctionButton(buttonText: "create_new_password_button_text".localized(language), isAnimated: $updatePasswordViewModel.isRequesting)
                        .frame(width: UIScreen.screenWidth - 50 , height: 45)
                })
                .padding(.bottom, 20)
                .disabled(updatePasswordViewModel.isRequesting)
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .padding(.bottom , keyboardResponder.currentHeight)
        }
        
        
        .background(content: {
            NavigationLink(destination: SuccessfulPasswordView(colors: colors)
                .environmentObject(loginViewModel)
                .environmentObject(baseViewModel)
                           , isActive: $updatePasswordViewModel.isReceived) {
                
            }
        })
        
        .popup(isPresented: $updatePasswordViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: updatePasswordViewModel.errorMessage)
        }, customize: {
            $0
                .animation(.spring())
                .position(.bottom)
                .autohideIn(5)
                .type(.floater())
        })
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: NavigationItemsView(title: "password_recovery_otp_header".localized(language), isBackButtonHidden: false))
            .edgesIgnoringSafeArea([.top,.bottom])
        .onTapGesture {
            self.didTap.toggle()
            hideKeyboard()
            print("TAPPED!")
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var colors = ConstantColors()
    static var previews: some View {
        CreatePasswordView(colors: colors, accessToken: .constant("Sdsd"))
    }
}
