//
//  Login.swift
//  OKTime
//
//  Created by Arman on 10/10/22.
//

import SwiftUI
import ExytePopupView
import IQKeyboardManager


struct LoginView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @State var selectedLanguage = "English" {
        didSet {
            print(selectedLanguage)
            switch selectedLanguage {
                
            case "English":
                LocalizationService.shared.language = .english
                
    
            case "فارسی":
                LocalizationService.shared.language = .persian
                
    
            default:
                break
            }
        }
    }
    
    var colors : ConstantColors = ConstantColors()
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    
    @StateObject var loginViewModel = LoginViewModel()
    
    @StateObject var bussinessInfoViewModel = BusinessRegister()
    
    @State var phoneNumber : String = ""
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    @State private var didTap = false
    
    @State var isClicked = false
    
    @State var isLanguageSelectionPresented = false
    
    @State var isShowingLanguagePicker = false
    
    private var yOffset: CGFloat = 0.0

    var body: some View {
       
        //Main Stack
        NavigationView(content: {
            VStack {
                ScrollView {
                    VStack(spacing: 30) {
                        
                        
                        //Top Area Stack
                        ZStack(alignment: .bottom) {
                            
                            Image("loginReal")
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
                                    
                                    
                                    Text("login_header".localized(language))
                                        .font(.custom("YekanBakhNoEn-Bold", size: 40))
                                    
                                    Text("login_subheader".localized(language))
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
                        VStack(spacing: 5) {
                            
                            CustomLanguagePickerView(colors: colors)
                                .onTapGesture {
                                    hideKeyboard()
                                    withAnimation {
                                        isShowingLanguagePicker.toggle()
                                    }
                                }
                                .padding([.leading, .trailing])
                                
                            PhonenumberView(phoneNumber: self.$phoneNumber, colors: colors, hasDescription: true, description: "phone_number_description".localized(language))

                        
                        }
                            .padding()
                        
                        
                        
                        Button (action: {
                                //MARK: SIGN IN BUTTON
                                
                            self.isClicked.toggle()
                            hideKeyboard()

                            Task {
                                
                                await loginViewModel.VerifyPhoneNumber(with: phoneNumber, countryCode: "98", isResendCode: false)
                            }
                        }, label: {
                            GreenFunctionButton(buttonText: "sign_in".localized(language), isAnimated: $loginViewModel.isRequesting)
                            
                            })
                            .frame(width: UIScreen.screenWidth - 50 , height: 45)
                            .padding(.bottom , 30)
                            .disabled(loginViewModel.isRequesting)
    
                    }
                    
                    
                }
                
                .popup(isPresented: $isLanguageSelectionPresented, view: {
                    
                    CustomOptionPickerView(selectedItem: $selectedLanguage, options: ["فارسی", "English"])
                                .padding(.bottom, 30)
                                .padding(.bottom, KeyboardResponder().currentHeight)

                }, customize: {
                    $0
                        .type(.toast)
                        .position(.bottom)
                        .closeOnTapOutside(false)
                        .backgroundColor(.black.opacity(0.4))
                })
                
            
                
                
  
                
                    .onTapGesture {
                        self.didTap.toggle()
                        hideKeyboard()
                        print("TAPPED!")
                    }


                //MARK: Login Flow
                //OTP
                NavigationLink(destination:
                                OTPView(colors: colors, phoneNumber: $phoneNumber, verifyKey: $loginViewModel.accesstoken)
                                    .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                                    .environmentObject(loginViewModel)
                                    .environmentObject(keyboardResponder)
                                    .environmentObject(baseViewModel)
                                    , tag: "OTP", selection: $loginViewModel.selection) {
                    
                }
                

                
                NavigationLink(
                    destination: PasswordLoginView(colors: colors, phoneNumber: $phoneNumber)
                        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                        .environmentObject(keyboardResponder)
                        .environmentObject(loginViewModel)
                        .environmentObject(baseViewModel)
                               , tag: "PASSWORD", selection: $loginViewModel.selection) {

                }
                
                
                NavigationLink(
                    destination: PasswordRecoveryView(colors: colors)
                        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                        .environmentObject(baseViewModel)
                        .environmentObject(keyboardResponder)
                        .environmentObject(loginViewModel)
                        
                               , tag: "RecoverPassword", selection: $loginViewModel.selection) {

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

            .padding(.bottom, keyboardResponder.currentHeight)
            .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
            .ignoresSafeArea()
            
            
            
            
            
        })
        
        .navigationViewStyle(.stack)
        
        .ignoresSafeArea()
        
        .overlay(alignment: .bottom) {
            
            if isShowingLanguagePicker {
                CustomLanguagePicker(isPresented: $isShowingLanguagePicker, selectedValue: "setting_language".localized(language), selectionTitle: "App Language", options: ["English", "فارسی"])
            }
            
        }
        
        }
    //MARK: View functions
    
    func limitText(_ upper: Int) {
        if phoneNumber.count > upper {
            phoneNumber = String(phoneNumber.prefix(upper))
        }
    }
        
    }

//struct LoginView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        LoginView()
//    }
//}
