//
//  AddContactSearchBarView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/12/22.
//

import SwiftUI

struct AddContactSearchBarView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    @Binding var searchText: String
    
    @Binding var isSearched: Bool
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            
            Text("search_contacts".localized(language))
                .font(.custom("YekanBakhNoEn-Bold", size: 15))
                .foregroundColor(colors.whiteColor)
                .border(Color.red)
            
            HStack {
                TextField("search_contacts_placeholder".localized(language), text: $searchText)
                    .font(.custom("YekanBakhNoEn-Regular", size: 14))
                    .foregroundColor(colors.grayColor)
                    .multilineTextAlignment(.trailing)
                    .overlay(
                        Rectangle()
                            .cornerRadius(5)
                            .foregroundColor(colors.blueColor)
                            .frame(width: 80, height: 30)
                            .overlay(
                                Text("search".localized(language))
                                    .foregroundColor(colors.whiteColor)
                                    .font(.system(size: 14))
                                    .onTapGesture {
                                        isSearched = true
                                    }
                            )
                            .padding(.leading, 5)
                        , alignment: .leading
                    )
                    
                Image("search")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing)

                
            }
            .frame(width: UIScreen.screenWidth - 20, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.white)
                    .border(colors.lightGrayColor, width: 0.4)
            )
        }
        .padding()
    }
}

struct AddContactSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactSearchBarView(colors: ConstantColors(), searchText: .constant(""), isSearched: .constant(false))
    }
}
