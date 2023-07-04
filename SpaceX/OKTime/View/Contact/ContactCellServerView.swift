//
//  ContactCellServerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/22.
//

import SwiftUI

struct ContactCellServerView: View {
    
//    var contact: ContactInfo
    var colors: ConstantColors
    var name: String
    var phone: String
    var image: String?
    
    
    
    var imagePlaceholder: some View {
        Image(systemName: "person.crop.circle")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 59, height: 50)
    }
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            
            HStack {
                VStack(alignment: .trailing, spacing: 7) {
                    HStack {
                        Text(name)
                            .font(.custom("YekanBakhNoEn-SemiBold", size: 14))
                            .foregroundColor(colors.blueColor)
                            
                    }
                    Text(phone)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                        .foregroundColor(Color.blue)
                }
                
                
                
                
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
        
    }
}

//struct ContactCellServerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactCellServerView()
//    }
//}
