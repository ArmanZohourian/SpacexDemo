//
//  PasswordLoginView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/24/22.
//

import SwiftUI

struct PasswordLoginView: View {

    @AppStorage("language")
    
    
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    @State var password = ""
    
    @Binding var phoneNumber : String
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var baseViewModel : BaseViewModel
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow-square-left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }

    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 30) {
                    
                    //Top Area Stack
                    ZStack(alignment: .bottom) {
                        
                        Image("passwordReal")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.screenWidth)
                            .overlay(alignment: .center) {
                                Rectangle()
                                    .foregroundColor(colors.imageShadeColor)
                                    .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                            }
                        
                        VStack(alignment: .center, spacing: 30) {
                            
                            //Greeting stack
                            VStack(alignment: .center, spacing: 10){
                                
                                Text("password_header".localized(language))
                                    .environment(\.locale, .init(identifier: "fa"))
                                    .font(.custom("YekanBakhNoEn-Bold", size: 40))
                                
                                Text("password_subheader".localized(language))
                                    .font(.custom("YekanBakhNoEn-Regular", size: 16))
                                
                            }
                            .foregroundColor(colors.whiteColor)
                            
                            Image("login-clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80, alignment: .center)
                            
                        }
                        .padding(.bottom, 50)
                    }
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 2)
                    
                    Spacer()
                    //Login Credintials
                    VStack(alignment: .trailing ,spacing: 5) {
                        
    
                        
                        CustomTextField(colors: colors,labelName: "password_label".localized(language) , placeholder: "password_placeholder".localized(language), text: $password, isPassword: true)
                        
                        Text("forget_password_description".localized(language))
                            .foregroundColor(colors.moderateBlue)
                            .font(.custom("YekanBakhNoEn-Regular", size: 14))
                            .padding(.trailing, 10)
                            .onTapGesture {
                                loginViewModel.selection = "RecoverPassword"
                            }
                    }
                    .padding()
                    
                    Button (action: {
                            //MARK: SIGN IN BUTTON
                        
                        hideKeyboard()
                        Task {
                            await loginViewModel.loginWithPassword(phoneNumber: "98\(phoneNumber)" , password: password, completionHandler: { isSuccessful in
                                if isSuccessful {
                                    baseViewModel.isLoggedIn = true
                                    baseViewModel.appState = UUID()
                                }
                            })
                            

                        }
                    }, label: {
                        GreenFunctionButton(buttonText: "password_button_text".localized(language), isAnimated: $loginViewModel.isRequesting)
                        })
                        .frame(width: UIScreen.screenWidth - 50 , height: 45)
                        .padding(.bottom , 30)
                        .disabled(loginViewModel.isRequesting)
                    
                }
                .padding(.bottom, keyboardResponder.currentHeight)
                
            }

        }
        .popup(isPresented: $loginViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: loginViewModel.errorMessage)

        }, customize: {
            $0
                .animation(.spring())
                .autohideIn(5)
                .position(.bottom)
                .type(.floater())
            
        })
        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: backButton)
        .ignoresSafeArea()
    }
    
    
}
//
//struct PasswordLoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        PasswordLoginView()
//    }
//}
