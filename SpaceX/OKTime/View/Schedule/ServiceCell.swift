//
//  ServiceCell.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/5/23.
//

import SwiftUI

struct ServiceCell: View {
    
    
    var subCategory: SubCategory
    
    var colors: ConstantColors
    
    var image: String?
    
    var body: some View {
        content
            
    }
    
    
    var imagePlaceholder: some View {
        
        Rectangle()
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .foregroundColor(Color.pink)
    }
    
    
    var content: some View {
        HStack {
            
            
            HStack {
                Text(subCategory.price)
                Text("Toman")
            }
            .foregroundColor(colors.moderateBlue)
            .font(.custom("YekanBakhNoEn-Regular", size: 12))
            
            
            Spacer()
            //Right side stack
            HStack {
                

                
                //Category and sub stack
                VStack(alignment: .trailing, spacing: 13) {
                    Text(subCategory.name)
                        .foregroundColor(colors.blueColor)
                        .font(.custom("YekanBakhNoEn-SemiBold", size: 16))
                        
                    
                    
                    Text(subCategory.categoryName!)
                        .foregroundColor(colors.moderateBlue)
                        .font(.custom("YekanBakhNoEn-Regular", size: 14))
                }
                .padding()
                
                //Image
                if let cellImage = image {
                    
                    AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + cellImage)) { image in
                        
                        
                        image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        
                    } placeholder: {
                        
                        imagePlaceholder
                    }
                }
                else {
                
                imagePlaceholder
                
            }
                

                
            }
        }
        .frame(height: 70)
        .padding([.leading, .trailing])
        
    }
}
