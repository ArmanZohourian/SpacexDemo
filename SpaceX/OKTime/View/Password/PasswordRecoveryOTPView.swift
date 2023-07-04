//
//  passwordRecoveryOTPView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/3/22.
//

import SwiftUI
import ExytePopupView

struct PasswordRecoveryOTPView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var loginViewModel : LoginViewModel
    @EnvironmentObject var baseViewModel : BaseViewModel
    var colors: ConstantColors
    let textBoxWidth = UIScreen.main.bounds.width / 8
          let textBoxHeight = UIScreen.main.bounds.width / 8
          let spaceBetweenBoxes: CGFloat = 10
          let paddingOfBox: CGFloat = 1
          var textFieldOriginalWidth: CGFloat {
              (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
          }
    
    //Properties
    @StateObject var passRecoveryOtpViewModel = OTPViewModel()
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    @State private var didTap = false
    @State private var timeRemaining = 60
    
    
    
    @State var isFocused = false
    @Binding var verifyKey : String
    @Binding var phoneNumber : String
    
    var body: some View {
        
    
            
        ScrollView {
            
                
            VStack {
                
                //Top Rectangle
                VStack(alignment: .trailing, spacing: 10) {
                    Spacer()
                    Text("password_recovery_otp_subheader".localized(language))
                        .font(.custom("YekanBakhNoEn-Regular", size: 16))
                        .padding()
                    
                    
                    Image("password-indicator-2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.screenWidth - 30, height: UIScreen.screenHeight / 22)
    
                }
                .padding()
                .foregroundColor(colors.whiteColor)
                .background(colors.blueColor)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 4)
    
                
                Spacer()
                //Scan Label
                VStack {
                    Image("password-logo")
                    Text("password_recovery_header".localized(language))
                        .font(.system(size: 30,weight: .heavy))
                        .foregroundColor(colors.lightGrayColor)
                }

                
            
            
                //OTPView
                VStack(alignment: .trailing, spacing: -10){
                    
                    //OTP LABEL
                    HStack {
                        
                        
                        Button {
                            //Go Back To Edit View
                        } label: {
                            Text("edit_phone_number_label".localized(language))
                                .foregroundColor(Color(red: 0 / 255, green: 223 / 255, blue: 150 / 255 ))
                                .font(.custom("YekanBakhNoEn-Regular", size: 10))
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                        
                        
                        Text("otp_label".localized(language))
                            .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                            .font(.custom("YekanBakhNoEn-Bold", size: 14))
                            .environment(\.layoutDirection, language == .persian ? .rightToLeft : .leftToRight)
                            
                    }
                    .padding()
                    
                    
                    //MARK: OTPView
                    VStack {
                        OTPCustomField(colors: colors)
                            .environmentObject(passRecoveryOtpViewModel)
                            .environment(\.layoutDirection, .leftToRight)
                        
                        //Time View
                        HStack {

                            if timeRemaining > 0 {
                                CountDownView(timeRemaining: $timeRemaining)
                                    .font(.system(size: 12))
                            } else {
                                Button {
                                    //Resend code
                                    Task {
                                        await passRecoveryOtpViewModel.resendCode(with: phoneNumber, countryCode: "98", isResendCode: true, isRecovery: true)
                                    }
                                     
                                } label: {
                                    Text("resend_code".localized(language))
                                        .foregroundColor(Color(red: 0 / 255, green: 223 / 255, blue: 150 / 255, opacity: timeRemaining > 0 ? 0.3 : 1 ))
                                        .font(.system(size: 10, weight: .semibold, design: .default))
                                        
                                        
                                }
                                .opacity(timeRemaining == 0 ? 1.0 : 0.0)
                            }
                            
                            
                            Text("otp_description".localized(language))
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                .foregroundColor(Color(red: 189 / 255, green: 189 / 255, blue: 189 / 255))
                                
                            
                        }
                    }
//                    VStack {
//
//                        ZStack {
//
//                            HStack (spacing: spaceBetweenBoxes){
//
//                                otpText(text: otpViewModel.otp1)
//                                otpText(text: otpViewModel.otp2)
//                                otpText(text: otpViewModel.otp3)
//                                otpText(text: otpViewModel.otp4)
//                            }
//
//
//                            TextField("", text: $otpViewModel.otpField)
//                                .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
//                                .disabled(otpViewModel.isTextFieldDisabled)
//                                .textContentType(.oneTimeCode)
//                                .foregroundColor(.clear)
//                                .accentColor(.clear)
//                                .background(Color.clear)
//                                .keyboardType(.numberPad)
//                        }
//                        .environment(\.layoutDirection, .leftToRight)
//                    }
                    
                    
                    
                    
                }
                .padding()
                Spacer()
                
                
    
                //Send Button
                Button (action: {
                    hideKeyboard()
                    //Send Request to network
                    Task {
                        await passRecoveryOtpViewModel.verifyPhonenumber(verificationKey: verifyKey, otp: passRecoveryOtpViewModel.otpFields.joined(), phoneNumber: ("98\(phoneNumber)"))
                    }
                }, label: {
                    GreenFunctionButton(buttonText: "otp_button_text".localized(language), isAnimated: $passRecoveryOtpViewModel.isRequesting)
                        .frame(width: UIScreen.screenWidth - 50 , height: 45)
                })
                .padding(.bottom, 20)
                .disabled(passRecoveryOtpViewModel.isRequesting)

            
            
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .padding(.bottom,keyboardResponder.currentHeight)
                    
            }
        
        
        .popup(isPresented: $passRecoveryOtpViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: passRecoveryOtpViewModel.errorMessage)
        }, customize: {
            $0
                .animation(.spring())
                .position(.bottom)
                .autohideIn(5)
                .type(.floater())
        })
            
                .navigationBarBackButtonHidden(true)
                .background(
                    NavigationLink(destination:
                                    CreatePasswordView(colors: colors, accessToken: $verifyKey)
                        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                        .environmentObject(baseViewModel)
                        .environmentObject(keyboardResponder)
                        .environmentObject(loginViewModel)
                                   , isActive: $passRecoveryOtpViewModel.isReceived)
                    {
                        EmptyView()
                })
                .edgesIgnoringSafeArea([.top,.bottom])
            
                .navigationBarItems(leading: NavigationItemsView(title: "password_recovery_otp_header".localized(language), isBackButtonHidden: false))
        
                .onTapGesture {
                    hideKeyboard()
                }
            
            

    }
    
    
    private func otpText(text: String) -> some View {
        
        return ZStack {
            Image("OTPRectangle")
            Text(text)
                .font(.title)
                .frame(width: textBoxWidth, height: textBoxHeight)
                .background(VStack{
                 })
            .padding(paddingOfBox)
        }
    }
    
}
//
//struct passwordRecoveryOTPView_Previews: PreviewProvider {
//
//
//    static var colors = ConstantColors()
//    static var previews: some View {
//        passwordRecoveryOTPView(colors: colors, accessToken: <#Binding<Bool>#>)
//    }
//}
