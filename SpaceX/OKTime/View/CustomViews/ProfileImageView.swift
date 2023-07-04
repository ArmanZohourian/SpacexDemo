//
//  ProfileImageView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/13/22.
//

import SwiftUI

struct ProfileImageView: View {
    
    var image: String?
    
    var body: some View {
        
        if let profileImage = image {
            

            AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + profileImage)) { image in
                
                
                ZStack {
                    Rectangle()
                        .frame(width: 40, height: 40, alignment: .leading)
                        .foregroundColor(Color.green)
                        .cornerRadius(20)
                    
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 36, height: 36, alignment: .leading)
                }
                
                    
            } placeholder: {
                
                Rectangle()
                    .frame(width: 40, height: 40, alignment: .leading)
                    .foregroundColor(Color.green)
                    .cornerRadius(20)
                
            }
            
        } else {
            
            Rectangle()
                .frame(width: 40, height: 40, alignment: .leading)
                .foregroundColor(Color.green)
                .cornerRadius(20)
        }
        

        
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView()
    }
}
