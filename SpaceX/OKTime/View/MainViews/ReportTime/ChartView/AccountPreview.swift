//
//  AccountPreview.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/20/22.
//

import SwiftUI

struct AccountPreview: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    
    var colors: ConstantColors
    @State var isSecure : Bool = false
    var income: String
    var totalIncome: String
    
    var body: some View {
        
        VStack(spacing: -20) {
            //TOP HSTACK
            HStack {
               
                
                //Eye Image
                Button {
                    isSecure.toggle()
                } label: {
                    Image(isSecure ? "hidden-eye" : "eye")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24, alignment: .center)
                }

                Spacer()
                Text("account_review".localized(language))
                    .foregroundColor(colors.blueColor)
                    .font(.system(size: 14))
            }
            
            .padding()
            
            
            HStack(spacing: 0) {
                
                
                VStack(alignment: .trailing ,spacing: 3) {
                    Text(isSecure ? "******" :"\(totalIncome)")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(colors.blueColor)
                    
                    Text("toman_income".localized(language))
                        .foregroundColor(Color.gray)
                        .font(.system(size: 10, weight: .regular, design: .default))
                }
    
                
                .padding()
                
                Divider()
                
                
                VStack(alignment: .trailing ,spacing: 5) {
                    Text(isSecure ? "******" :"\(income)")
                        .font(.system(size: 12, weight: .regular, design: .default))
                        .foregroundColor(colors.blueColor)
                    Text("monthly_toman_income".localized(language))
                        .foregroundColor(Color.gray)
                        .font(.system(size: 10, weight: .regular, design: .default))
                }
                
                .padding()
                
                
                
                
                
                
            }
            .padding()
            
        }
        .frame(width: UIScreen.screenWidth - 30)
        .background(colors.cellColor)
        .padding(.top)

    }
}
