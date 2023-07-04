//
//  AddContactPopupView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/12/22.
//

import SwiftUI
import Contacts


struct AddContactPopupView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    
    @Binding var isPresented: Bool
    
    @State var contactName: String = ""
    
    @State var phoneNumber: String = ""
    
    @State var showSheet: Bool = false
    
    @State private var image = UIImage()
    
    @EnvironmentObject var contactObject: ContactsViewModel
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                VStack(spacing: 10) {
                    Image("user-add")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 85, height: 85)
                    
                    Text("add_contact".localized(language))
                        .foregroundColor(colors.blueColor)
                        .font(.system(size: 18, weight: .heavy))
                    
                }
                
                CustomTextFieldPopUp(colors: colors, labelName: "contact_name_label".localized(language), placeholder: "contact_name_description".localized(language), text: $contactName, isPassword: false)
                    
                CustomTextFieldPopUp(colors: colors, labelName: "phone_number_label".localized(language), placeholder: "0915 000 00 00", text: $phoneNumber, isPassword: false)
                    .keyboardType(.numberPad)
                    
                
                
                //MARK: Clean up Image Filed
                Text("contact_profile".localized(language))
                    .foregroundColor(colors.blueColor)
                    .font(.system(size: 15,weight: .semibold))
                    .padding(.leading, 220)
                HStack {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Text("add_picture".localized(language))
                            .font(.system(size: 14))
                            .foregroundColor(colors.whiteColor)
                            .frame(width: 100,height: 40)
                            .background(colors.blueColor)
                            .cornerRadius(5)
                    }
                    .padding(.leading, 5)
                    
                    Spacer()

                    Text("")
                        .foregroundColor(Color.blue)
                    
                    //Image
                    Image(uiImage: self.image)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                        .background(Color.clear)
                        .clipShape(Circle())
                        .padding(.trailing)

                    
                }
                .frame(width: UIScreen.screenWidth - 40)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(colors.lightGrayColor, lineWidth: 0.8)
                )
                    
                
                
                
                HStack(spacing: 5) {

                    Button {
                        isPresented = false
                    } label: {
                        Text("cancel".localized(language))
                            .foregroundColor(Color.white)
                        
                    }
                    .frame(width: UIScreen.screenWidth / 2.5, height: 45)
                    .background(colors.redColor)
                    .cornerRadius(5)
                    .disabled(contactObject.isUploading)
                    
                    
                    Button {
                        //Add Contact
                        hideKeyboard()
                        contactObject.addNewContact(imageData: image.pngData() ?? nil, params: ["name": contactName,
                                                                                                "phone" : phoneNumber], firstName: contactName, phoneNumber: phoneNumber) { isSuccsessful in
                            if isSuccsessful {
                                isPresented = false
                            }
                        }

                    } label: {
                        Text("submit_user".localized(language))
                            .foregroundColor(Color.white)
                            .opacity(contactObject.isUploading ? 0.0 : 1.0)
                    }
                    .frame(width: UIScreen.screenWidth / 2.5, height: 45)
                    .background(colors.darkGreenColor)
                    .cornerRadius(5)
                    .overlay(alignment: .top) {
                        SpinnerView()
                            .opacity(contactObject.isUploading ? 1.0 : 0.0)
                            .padding(.all, 10)
                            
                    }


                }
                .padding()
                
                
            }
            .onTapGesture {
                hideKeyboard()
            }
            
        }
        
        
        .popup(isPresented: $contactObject.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: contactObject.errorMessage)
        }, customize: {
            $0
                .animation(.spring())
                .autohideIn(3)
                .position(.bottom)
                .type(.floater())
        })
        
        .padding(.bottom, keyboardResponder.currentHeight / 2)
        .environment(\.layoutDirection, language == .persian ? .leftToRight : .rightToLeft)
            .frame(width: UIScreen.screenWidth - 20)
            .frame(height: UIScreen.screenHeight - 300)
        
            .background(
                Color.white
            )
        
            .sheet(isPresented: $showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
        
    }
}

struct AddContactPopupView_Previews: PreviewProvider {
    static var previews: some View {
        AddContactPopupView(colors: ConstantColors(), isPresented: .constant(true))
    }
}
