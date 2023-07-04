//
//  SuccessfulPasswordView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/3/22.
//

import SwiftUI

struct SuccessfulPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var loginViewModel : LoginViewModel
    
    var colors: ConstantColors
    
    var language = LocalizationService.shared.language
    
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    var body: some View {
        
        
        VStack {
            //Top Rectangle
                                VStack(alignment: .trailing, spacing: 10) {
                                    Spacer()
                                    
                                    Text("click_to_start".localized(language))
                                        .font(.custom("YekanBakhNoEn-Regular", size: 16))
                                        .padding()
                                    
                                    Image("password-indicator-4")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.screenWidth - 30, height: UIScreen.screenHeight / 22)
                                }
                                .padding()
                                .foregroundColor(colors.whiteColor)
                                .background(colors.blueColor)
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight / 4)
                                .ignoresSafeArea()
            Spacer()
            VStack(alignment: .center, spacing: 30) {
                
                Image("clock-ticked-2")
                
                Text("opreation_successful".localized(language))
                    .font(.custom("YekanBakhNoEn-SemiBold", size: 20))
                    .foregroundColor(colors.blueColor)
                
                
                Text("login_to_continue".localized(language))
                    .font(.custom("YekanBakhNoEn-Regular", size: 16))
                    .foregroundColor(colors.grayColor)
                
                
            }
            Spacer()

            Button(action: {
                loginViewModel.selection = nil
            }, label: {
                GreenFunctionButton(buttonText: "login".localized(language), isAnimated: .constant(false))
                    .frame(width: UIScreen.screenWidth - 50 , height: 45)
            })
            .padding(.bottom, 30)
                
        }
        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        .navigationBarItems(leading: NavigationItemsView(title: "operation_successfull_password".localized(language), isBackButtonHidden: true))
        .navigationBarBackButtonHidden()
        .background(
            NavigationLink(destination: LoginView(), label: {
                EmptyView()
            })
        )
    
    .background(colors.backgroundColor)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea()
        
    }
}

struct SuccessfulPasswordView_Previews: PreviewProvider {
    static var colors = ConstantColors()
    static var previews: some View {
        SuccessfulPasswordView(colors: colors)
    }
}
