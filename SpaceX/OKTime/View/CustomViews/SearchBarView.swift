//
//  SearchBarView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText : String
    
    @Binding var addTapped: Bool
    
    var colors: ConstantColors
    
    var language = LocalizationService.shared.language
    
    var body: some View {
        
        
        
        VStack {
            HStack {
        
                TextField("search_contacts_placeholder".localized(language), text: $searchText)
                    .foregroundColor(colors.grayColor)
                    .multilineTextAlignment(.trailing)
                    .overlay(
                        Rectangle()
                            .cornerRadius(5)
                            .foregroundColor(colors.blueColor)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text("+")
                                    .foregroundColor(colors.whiteColor)
                                    .font(.system(size: 20))
                                    .onTapGesture {
                                        addTapped.toggle()
                                    }
                            )
                            .padding(.leading, 10)
                        , alignment: .leading
                    )
                    
                Image("search")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing)

                
            }
            .frame(width: UIScreen.screenWidth - 20, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.white)
                    .border(colors.lightGrayColor, width: 0.4)
            )
        }
        .padding()
    }
}

//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView(searchText: .constant("به عنوان مثال علی حسین پور"), colors: ConstantColors())
//    }
//}
