//
//  SubcategoryBusinessCell.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/13/23.
//

import SwiftUI

struct SubcategoryBusinessCell: View {
    
    @State var isActivated : Bool = false
    
    @EnvironmentObject var servicesViewModel: BusinessServiceAddCategoryViewModel
    
    var subCategory: SubCategory
    
    var colors: ConstantColors
    
    var image: String?
    
    var body: some View {
        
        subCateogryView
            .onChange(of: isActivated) { newValue in
                Task {
                    await servicesViewModel.updateSubCategoryStatus(with: subCategory , status: newValue)
                }
            }
    }
    
    var language = LocalizationService.shared.language
    
    
    var imagePlaceholder: some View {
        
        Rectangle()
            .frame(width: 30, height: 30, alignment: .center)
            .cornerRadius(30)
    }
    
    
    var subCateogryView: some View {
        
        
        
        VStack {
            HStack {
                
                //Price
                HStack {
                    
                    Text("toman".localized(language))
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                    
                    Text(subCategory.price)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                }
                .foregroundColor(Color.blue)

                
                
                Spacer()
                
                //Subcategory name
                Text(subCategory.name)
                    .font(.custom("YekanBakhNoEn-SemiBold", size: 14))
                
                
                //Image
                
                
                if let cellImage = image {
                    
                    AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + cellImage)) { image in
                        
                        
                        image
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .clipShape(Circle())
                        
                        
                    } placeholder: {
                        
                        imagePlaceholder
                    }
                }
                else {
                
                imagePlaceholder
                
            }
                

                
                
                //Check Button
                Button {
                    isActivated.toggle()
                } label: {
                    ZStack {
                        
                        Color.blue
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 10, height: 10)
                            
                    }
                    .opacity(isActivated ? 1.0 : 0.0)
                    .frame(width: 20, height: 20)
                    .overlay(alignment: .center) {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.gray, lineWidth: 0.5)
                    }
                }
                

                
                

            }
            
        }
        .padding()
        .frame(height: 50)
        .background(colors.cellColor)
        .onAppear {
            isSubCategoryActivated(with: subCategory)
        }
        
    }
    
    
    private func isSubCategoryActivated(with subCategory: SubCategory) {
        
        if subCategory.isActive {
            isActivated = true
        } else {
           isActivated = false
        }
        
    }
    
    
    
}
