//
//  ContactView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/9/22.
//

import SwiftUI

struct ContactCellView: View {
    
    var contact: ContactInfo
    var colors: ConstantColors
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            
            HStack {
                VStack(spacing: 7) {
                    HStack {
                        Text(contact.firstname)
                            .font(.system(size: 16))
                            .foregroundColor(colors.blueColor)
                        Text(contact.lastname)
                            .font(.system(size: 16))
                            .foregroundColor(colors.blueColor)
                            
                    }
                    Text(contact.phoneNumber?.stringValue ?? "")
                        .font(.system(size: 12))
                }
                if let data = contact.image {
                    let image = UIImage(data: data)
                    if let contactImage = image {
                        Image(uiImage: contactImage)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                    }
                } else {
                    Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 59, height: 50)
                }

            }
        }
        
    }
}
