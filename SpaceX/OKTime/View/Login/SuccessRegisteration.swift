//
//  SuccessRegisteration.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/19/22.
//

import SwiftUI

struct SuccessRegisteration: View {
    
//flowName: "success_register_header".localized(language)
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    let colors: ConstantColors
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    
    var body: some View {
            
        VStack {
            
            CustomFlowView(colors: colors, flowDescription: "success_register_subheader".localized(language), flowImage: "user-flow-4", flowBgImage: "", flowName: "success_register_header".localized(language))
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
            Spacer()
            VStack(alignment: .center, spacing: 30) {
                
                Image("clock-ticked-2")
                
                Text("success_register_status".localized(language))
                    .foregroundColor(colors.blueColor)
                Text("success_register_status_description".localized(language))
                    .foregroundColor(colors.grayColor)
            }
            Spacer()
            Button(action: {
                //Go back to Home View
                baseViewModel.isLoggedIn = true
            }, label: {
                GreenFunctionButton(buttonText: "success_register_button_text".localized(language), isAnimated: .constant(false))
            })
            .frame(width: UIScreen.screenWidth - 50 , height: 45)
            .padding(.bottom, 30)
        }
        .background(colors.whiteColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

struct SuccessRegisteration_Previews: PreviewProvider {
    static var previews: some View {
        SuccessRegisteration(colors: ConstantColors())
    }
}
