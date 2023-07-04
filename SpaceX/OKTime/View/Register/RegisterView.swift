//
//  RegisterView.swift
//  OKTime
//
//  Created by ok-ex on 10/10/22.
//

import SwiftUI
import ExytePopupView

struct RegisterView: View {
    
    
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //Network Instance
    
    @StateObject var networkInstance = BusinessRegister()
    //Variables
    var colors: ConstantColors
    @State var isUserState = false
    @State var firstName = ""
    @State var lastName = ""
    @State var cityId = ""
    @State var sex = ""
    @State var password = ""
    @State var repPassword = ""
    @Binding var phoneNumber : String
    @Binding var token : String
    @State var isMale = true
    @State var isShowingSexSelection = false
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var registerInstance : LoginViewModel
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    
    
    
    
    @State var didTap = false
    
    
    
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
        
        
        ScrollView(showsIndicators: false) {
            //User State Buttons
            VStack {
                
                //Top stack
                ZStack(alignment: .trailing) {
                
                    colors.blueColor
                        .frame(maxWidth: UIScreen.screenWidth)
    
                    VStack(alignment: .trailing) {
                        
                        HStack(spacing: 5) {
                            
                            Text("register_header".localized(language))
                                .foregroundColor(Color.white)
                                .font(.custom("YekanBakhNoEn-Bold", size: 36))
                            
                            Image("Greenwatch")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                
                        }
                        .padding(.trailing)
                        
                        Text("register_subheader".localized(language))
                            .foregroundColor(Color.white)
                            .font(.custom("YekanBakhNoEn-Regular", size: 16))
                            .padding(.trailing)
                    }
                    .padding(.top, 80)
                    .padding()
                }
                .ignoresSafeArea()
                 
                MulitchoiceView(isUserState: $isUserState)
                
                if isUserState {
                    UserRegisterView(colors: colors, firstName: $firstName, lastName: $lastName, sex: $sex)
                } else {
                    withAnimation(.easeInOut(duration: 4))  {
                        BusinessRegisterView(colors: colors, firstName: $firstName, lastName: $lastName, cityId: $cityId, sexSelection: $sex, isShwoingSexSelection: $isShowingSexSelection, password: $password, repPassword: $repPassword)
                            .environmentObject(networkInstance)
                        
                    }
                    
                    Button {
                        //Send request to server
                        
                        if isUserState  {
                            
                            //Call user instance for network
                            
                        } else {
                            
                            //Call Business instance for network
                            Task {
                                
                                
                                await networkInstance.registerUser(firstName: firstName, lastName: lastName, sex: sex, password: password, repPassword: repPassword, token: token)
                            }
                        }
                    
                    } label: {
                        GreenFunctionButton(buttonText: "register_button_text".localized(language), isAnimated: $networkInstance.isRequesting)
                    }
                    .frame(width: UIScreen.screenWidth - 50 , height: 45)
                    .padding(.bottom , 30)
                    .disabled(networkInstance.isRequesting)
                }
                

                
                
                
        }
            
            .padding(.bottom, keyboardResponder.currentHeight)
            
            .popup(isPresented: $networkInstance.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: networkInstance.errorMessage)
                    .padding([.leading, .trailing])
                    .padding(.bottom, keyboardResponder.currentHeight)
                
            }, customize: {
                $0
                    .position(.bottom)
                    .autohideIn(3)
                    .type(.floater())
                    .animation(.spring())
            })
            
            
            .background(
                NavigationLink(destination: BusinessInformationView(colors: colors, token: .constant(""))
                    .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                    .environmentObject(keyboardResponder)
                    .environmentObject(registerInstance)
                               , isActive: $networkInstance.isReceived, label: {
                        EmptyView()
                    })
            )
            

        }
        
        .overlay(alignment: .bottom, content: {
            if isShowingSexSelection {
                CustomSelectionMenu(isPresented: $isShowingSexSelection, selectedValue: $sex, selectionTitle: "business_register_sex_label".localized(language), options: ["business_register_male_sex".localized(language), "business_register_female_sex".localized(language)])
                    .frame(width: UIScreen.screenWidth)
                    .padding()
            }
        })
        
        
        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        .edgesIgnoringSafeArea([.top,.bottom])
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        
    }
}
