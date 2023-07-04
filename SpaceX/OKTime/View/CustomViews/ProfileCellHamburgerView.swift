//
//  ProfileCellHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 1/11/23.
//

import SwiftUI

struct ProfileCellHamburgerView: View {
    
    @EnvironmentObject var profileCellViewModel : ProfileCellViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            //Profile Image
            HStack {
                //            Menu Button
            Button {
                            //close the full cover sheet
                isPresented.toggle()
                    }
            label: {
                    Image("close-circle-green")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(profileCellViewModel.userInformation?.firstName ?? "" + (profileCellViewModel.userInformation?.lastName ?? "") )
                        .foregroundColor(Color.white)
                        .font(.custom("YekanBakhNoEn-Regular", size: 16))
                    Text(profileCellViewModel.businessInformation?.businessName ?? "")
                        .foregroundColor(Color.white)
                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                }
                
                ProfileImageView(image: profileCellViewModel.userInformation?.avatar)
                
               
                

                
            }
         

                
        }
        .padding()
        .task {
            await profileCellViewModel.getUserInfo()
            await profileCellViewModel.getBusinessInfo()
        }
    }
}

//struct ProfileCellHamburgerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileCellHamburgerView()
//    }
//}
