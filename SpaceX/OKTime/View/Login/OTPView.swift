//
//  OTP.swift
//  OKTime
//
//  Created by Arman on 10/10/22.
//

import SwiftUI
import ExytePopupView
import Combine

struct OTPView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var otpNetworkInstance : LoginViewModel
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    //OTP
    @StateObject var viewModel = STViewModel()
    
   
    
    var colors: ConstantColors
    
    @Binding var phoneNumber : String
    
    @Binding var verifyKey : String
    
    let textLimit = 1
    
    @StateObject var networkInstance = OTPViewModel()
    @StateObject var OTPviewModel = STViewModel()
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    @State private var didTap = false
    @State var isFocused = false
    @State private var timeRemaining = 5
    
    let textBoxWidth = UIScreen.main.bounds.width / 8
          let textBoxHeight = UIScreen.main.bounds.width / 8
          let spaceBetweenBoxes: CGFloat = 10
          let paddingOfBox: CGFloat = 1
          var textFieldOriginalWidth: CGFloat {
              (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
          }
    
    @State var isSuccessful = false
    
    var body: some View {
       
        //Root stack

            ScrollView {
                    VStack {
             
                        //Top Stack
                        ZStack(alignment: .bottom) {
                            
                            Image("otpReal")
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
                                    
                                    Text("otp_header".localized(language))
                                        .environment(\.locale, .init(identifier: "fa"))
                                        .font(.custom("YekanBakhNoEn-Bold", size: 40))
                                    
                                    Text("otp_subheader".localized(language))
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
                            //Verification Credintial
                            VStack(alignment: .trailing, spacing: -10){
                                
                                //OTP LABEL
                                HStack {
                                    
                                    
                                    Button {
                                        //Go Back To Edit View
                                    } label: {
                                        Text("edit_phone_number_label".localized(language))
                                            .foregroundColor(colors.greenColor)
                                            .font(.custom("YekanBakhNoEn-Regular", size: 10))
                                            .onTapGesture {
                                                presentationMode.wrappedValue.dismiss()
                                            }
                                    }
                                    
                                    
                                    Text("otp_label".localized(language))
                                        .foregroundColor(colors.blueColor)
                                        .font(.custom("YekanBakhNoEn-Bold", size: 14))
                                }
                                .padding()
                                
                                
                                //MARK: OTPView
                                //needs cleaning
                                
                                OTPCustomField(colors: colors)
                                    .environmentObject(networkInstance)
                                    .environment(\.layoutDirection, .leftToRight)
                                    
                                
//                                VStack {
//
//                                    ZStack {
//
//                                        HStack (spacing: spaceBetweenBoxes){
//
//                                            otpText(text: viewModel.otp1)
//                                            otpText(text: viewModel.otp2)
//                                            otpText(text: viewModel.otp3)
//                                            otpText(text: viewModel.otp4)
//                                        }
//                                        .environment(\.layoutDirection, .leftToRight)
//
//
//                                        TextField("", text: $viewModel.otpField)
//                                            .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
//                                            .environment(\.layoutDirection, .leftToRight)
//                                            .disabled(viewModel.isTextFieldDisabled)
//                                            .textContentType(.oneTimeCode)
//                                            .foregroundColor(.clear)
//                                            .accentColor(.clear)
//                                            .background(Color.clear)
//                                            .keyboardType(.numberPad)
//                                    }
//                                }
                                //DONE
//                                .padding(.trailing, 10)
                                
                                //MARK: Resend code
                                HStack {
                                    
                                    
                                    //MARK: FIX SOMETHING
                                    //Time Interval
                                    
                                    
 
                                        
                                    if timeRemaining > 0 {
                                        CountDownView(timeRemaining: $timeRemaining)
                                            .font(.system(size: 12))
                                    } else {
                                        Button {
                                            //Resend code
                                          Task {
                                              await networkInstance.resendCode(with: phoneNumber, countryCode: "98", isResendCode: true, isRecovery: false)
                                            }
                                             
                                        } label: {
                                            Text("Resend code")
                                                .foregroundColor(colors.greenColor)
                                                .font(.system(size: 12))
                                                
                                                
                                                
                                        }
                                        .opacity(timeRemaining == 0 ? 1.0 : 0.0)
                                    }
                            
                                    
        

                                    

                                    
                                    
                                    Text("otp_description".localized(language))
                                        .foregroundColor(Color(red: 189 / 255, green: 189 / 255, blue: 189 / 255))
                                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                    
                                }
                                .padding(.top, 20)
                                
                                
                                
                            }
                        
                        
                        
                        
                        Spacer()
                        //Send Credintials
                            Button {
                               
                                Task {
                                    
                                    await networkInstance.verifyPhonenumber(verificationKey: verifyKey, otp: networkInstance.otpFields.joined() , phoneNumber: "98\(phoneNumber)")

                                }
                                
                            } label: {
                                
                                GreenFunctionButton(buttonText: "otp_button_text".localized(language), isAnimated: $networkInstance.isRequesting)

                            }
                            .frame(width: UIScreen.screenWidth - 50 , height: 45)
                            .padding(.bottom, -30)
                            .disabled(networkInstance.isRequesting)

                        
                        Spacer()
                        
                    }
                
                    .onTapGesture {
                        hideKeyboard()
                    }
                
  
                    
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                
                
                
                NavigationLink(destination: RegisterView(colors: colors, phoneNumber: $phoneNumber, token: $otpNetworkInstance.accesstoken)
                    .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                    .environmentObject(otpNetworkInstance)
                    .environmentObject(keyboardResponder)
                    .environmentObject(baseViewModel)
                               , isActive: $networkInstance.isReceived) {
                    EmptyView()
                }
                
                .padding(.bottom, keyboardResponder.currentHeight)
                
                
            }
            .popup(isPresented: $networkInstance.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: networkInstance.errorMessage)
            }, customize: {
                $0
                    .animation(.spring())
                    .autohideIn(3)
                    .position(.bottom)
                    .type(.floater())
            })
    
        .edgesIgnoringSafeArea([.top,.bottom])
        .navigationBarBackButtonHidden()


    }
    
    
    //MARK: OTP Functionality
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
//struct OTP_Previews: PreviewProvider {
//    static var previews: some View {
//        OTPView()
//    }
//}
