//
//  ProfileDetailsViwe.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI
import ExytePopupView

struct ProfileDetailsView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var colors: ConstantColors
    
    @State var firstName = ""
    
    @State var lastName = ""
    
    @State var phoneNumber = ""
    
    @State var isShwoingPasswordPopup = false
    
    @State var image : UIImage = UIImage()
    
    @State var imageName: String?
    
    @State var showSheet: Bool = false
    
    @StateObject var registerUserInfoViewModel = RegisterUserInfoViewModel()
    
    @StateObject var resetPasswordViewModel = ResetPasswordViewModel()
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var profileCellViewModel: ProfileCellViewModel
    
    
    
    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("arrow-square-left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }

    }
    
    
    
    var imagePlaceholder: some View {
        
        Image(systemName: "person.crop.circle")
            .resizable()
            .frame(width: 90, height: 90)
            .foregroundColor(colors.grayColor)
            .background(colors.lightGrayColor)
            .clipShape(Circle())
            .overlay(alignment: .center) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())

            }
            .onTapGesture {
                showSheet = true
            }
        
    }
    
    
    var body: some View {
        
        
            
        ScrollView {
            
                VStack {
                    
                    
                        
                    CustomNavigationTitle(name: "profile_details".localized(language), logo: "profile", colors: colors)
                        .foregroundColor(colors.whiteColor)
                                
                    
                    VStack(spacing: 10) {
                        
                        
                        if let profileImage = imageName {
                            
                            
                            
                            AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + profileImage)) { image in
                                
                                
                                image
                                    .resizable()
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                                    .overlay {
                                        Image(uiImage: self.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 90, height: 90)
                                            .clipShape(Circle())
                                    }
                                
                                
                            } placeholder: {
                                
                                imagePlaceholder
                            }

                            

                        } else {
                            
                            imagePlaceholder
                            
                        }
                        

                        

                        Text("choose_picture".localized(language))
                            .font(.system(size: 15))
                            .onTapGesture {
                                showSheet = true
                            }
                        
                        
                    }

                    CustomTextField(colors: colors, labelName: "firstname_label".localized(language), placeholder: "firstname_placeholder".localized(language), text: $firstName, isPassword: false)
                    
                    CustomTextField(colors: colors, labelName: "lastname_label".localized(language), placeholder: "lastname_placeholder".localized(language), text: $lastName, isPassword: false)
                    
                    PhonenumberView(phoneNumber: $phoneNumber, colors: colors, hasDescription: false, description: "")
                        .disabled(true)
                    
                    
                    HStack {
                        Image("edit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                isShwoingPasswordPopup = true
                            }
                        Spacer()
                        Text("change_password".localized(language))
                        Image("key")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .background(colors.cellColor)
                    
                    Spacer()
                    
                    Button {
                        //send to server
                        registerUserInfoViewModel.registerUserInfo(firstName: firstName, lastName: lastName, phoneNumber: "", imageData: image.pngData(), completionHandler: { isSuccessful in
                            if isSuccessful {
                                Task {
                                    await registerUserInfoViewModel.getUserInfo()
                                    await profileCellViewModel.getUserInfo()
                                    
                                }
                            }
                        })
                        
                        
                    } label: {
                        GreenFunctionButton(buttonText: "register_info".localized(language), isAnimated: $registerUserInfoViewModel.isActivated)
                            
                    }
                    .frame(width: UIScreen.screenWidth - 10 , height: 40)
                    .padding(.bottom, 30)
                    
                    
                }
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .padding(.bottom, keyboardResponder.currentHeight)
                
                
            }
            
        
        
        .task {
            await registerUserInfoViewModel.getUserInfo()

            firstName = registerUserInfoViewModel.userInformation?.firstName ?? ""
            lastName = registerUserInfoViewModel.userInformation?.lastName ?? ""
            phoneNumber = registerUserInfoViewModel.userInformation?.phoneNumber ?? ""
            imageName = registerUserInfoViewModel.userInformation?.avatar


        }

        
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
        }
        
        
        .popup(isPresented: $isShwoingPasswordPopup, view: {
            PasswordPopupView(isPresented: $isShwoingPasswordPopup, colors: colors)
                .environmentObject(resetPasswordViewModel)
                .environmentObject(keyboardResponder)
        }, customize: {
            
            $0
                .backgroundColor(.black.opacity(0.6))
                .closeOnTap(false)
        })
        
        
        .popup(isPresented: $registerUserInfoViewModel.isRecieved, view: {
            FloatBottomView(colors: Color.green, errorMessage: registerUserInfoViewModel.errorMessage)
                
        }, customize: {
            $0
                .position(.bottom)
                .type(.floater())
                .autohideIn(3)
                .animation(.spring())
        })
        
        
        .popup(isPresented: $registerUserInfoViewModel.hasError, view: {
            FloatBottomView(colors: Color.red, errorMessage: registerUserInfoViewModel.errorMessage)
                
        }, customize: {
            $0
                .position(.bottom)
                .type(.floater())
                .autohideIn(3)
                .animation(.spring())
        })
        
    
        
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .edgesIgnoringSafeArea([.top,.bottom])
    
    }
}



struct ProfileDetailsViwe_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailsView(colors: ConstantColors())
    }
}
