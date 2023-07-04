//
//  ProfileCellView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI

struct ProfileCellView: View {
    
    
    @EnvironmentObject var profileCellViewModel : ProfileCellViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            //Profile Image
            HStack {
                
                ProfileImageView(image: profileCellViewModel.userInformation?.avatar)
                
                VStack(alignment: .leading) {
                    Text(profileCellViewModel.userInformation?.firstName ?? "" + (profileCellViewModel.userInformation?.lastName ?? "") )
                        .foregroundColor(Color.white)
                        .font(.custom("YekanBakhNoEn-Regular", size: 16))
                    Text(profileCellViewModel.businessInformation?.businessName ?? "")
                        .foregroundColor(Color.white)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                }
                
            }
         
            Spacer()
            
            //Menu Button
            Button (action: {
                self.isPresented.toggle()
            }, label: {
                
                Image("menu-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                
            })

                
        }
        .padding()
        .task {
            await profileCellViewModel.getUserInfo()
            await profileCellViewModel.getBusinessInfo()
        }
    }
}

struct ProfileCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCellView(isPresented: .constant(true))
    }
}
