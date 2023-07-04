//
//  EditCategoryHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import SwiftUI

struct EditCategoryHamburgerView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    @State var categoryName: String = ""
    @Binding var isPresented: Bool
    @State var showSheet: Bool = false
    @State var image = UIImage()
    @State var category : Category? = nil
    @EnvironmentObject  var getServiesViewModel : ServicesViewModel
    @ObservedObject var keyboardResponder = KeyboardResponder()
    var body: some View {

        
        ActionSheetView {
            VStack(spacing: 20) {

                ZStack {
                    
                    if let onChangeCategory = category {
                        CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: onChangeCategory.title , text: $categoryName, isPassword: false)
                    } else {
                        CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: "category_name_placeholder".localized(language), text: $categoryName, isPassword: false)
                    }

                }

                //Image TextField
                
                
                VStack(alignment: .trailing) {
                    Text("category_image_label".localized(language))
                        .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .padding(.trailing)
                        .offset(x: 10)
                    
                    VStack(alignment: .trailing, spacing: 1) {

                        HStack {
                            Button {
                                showSheet.toggle()
                            } label: {
                                Text("category_image_button_text".localized(language))
                                    .font(.system(size: 14))
                                    .foregroundColor(colors.whiteColor)
                                    .frame(width: 90,height: 40)
                                    .background(colors.blueColor)
                                    .cornerRadius(5)
                            }
                            
                            Spacer()


                            
                            //Image
//                            if let onChangeCategory = category {
//                                if let imageData = onChangeCategory.image {
//                                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
//                                        .resizable()
//                                        .frame(width: 40, height: 40)
//                                        .cornerRadius(10)
//                                        .background(Color.clear)
//                                }
//                            } else {
//                                Image(uiImage: self.image)
//                                    .resizable()
//                                    .frame(width: 40, height: 35)
//                                    .cornerRadius(10)
//                                    .background(Color.clear)
//                            }


                            
                        }
                        .frame(width: UIScreen.screenWidth - 15)
                    }
                    .padding()
                    .frame(width: UIScreen.screenWidth - 10, height: 45)
                    .border(colors.lightGrayColor, width: 0.8)
                    
                    
                    
                }


                
                Button {
                    //Send Request and upload the file
                    
                    let editedCategory = Category(title: categoryName, image: nil , subCategory: category!.subCategory, isActive: true, serverId: category!.serverId)
                    getServiesViewModel.editCategory(with: self.image, category: category!, changedCategory: editedCategory) { isSuccessful in
                        if isSuccessful {
                            Task {
                                await getServiesViewModel.getServices()
                            }
                            isPresented = false
                        }
                    }
                    
                } label: {
                    GreenFunctionButton(buttonText: "category_button_text".localized(language), isAnimated: $getServiesViewModel.isRequesting)
                        .frame(width: UIScreen.screenWidth - 50 , height: 45)
                }


            }
        }
        
        
        .popup(isPresented: $getServiesViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: getServiesViewModel.errorMessage)

        }, customize: {
            
            $0
                .animation(.spring())
                .position(.bottom)
                .type(.floater())
                .autohideIn(5)
        })
       
    
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }

        
    }
    
    
}
