//
//  EditCategoryView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import SwiftUI

struct EditCategoryView: View {
    
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language

    var colors: ConstantColors
    
    @State var categoryName: String = ""
    @Binding var isPresented: Bool
    @State var showSheet: Bool = false
    @State var image = UIImage()
    @State var category : Category? = nil
    
    @EnvironmentObject  var addCategoryViewModel : BusinessServiceAddCategoryViewModel
    @EnvironmentObject var keyboardResponder: KeyboardResponder

    
    var body: some View {

        
        ActionSheetView {
            ScrollView {
                VStack(spacing: 10) {

                    
                        if let onChangeCategory = category {
                            CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: onChangeCategory.title , text: $categoryName, isPassword: false)
                        } else {
                            CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: "category_name_placeholder".localized(language), text: $categoryName, isPassword: false)
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

//                                if let onChangeCategory = category {
//                                    if let imageData = onChangeCategory.image {
//                                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
//                                            .resizable()
//                                            .frame(width: 40, height: 40)
//                                            .cornerRadius(10)
//                                            .background(Color.clear)
//                                    }
//                                } else {
//                                    Image(uiImage: self.image)
//                                        .resizable()
//                                        .frame(width: 40, height: 35)
//                                        .cornerRadius(10)
//                                        .background(Color.clear)
//                                }


                                
                            }
                            .frame(width: UIScreen.screenWidth - 15)
                        }
                        .padding()
                        .frame(width: UIScreen.screenWidth - 10, height: 45)
                        .border(colors.lightGrayColor, width: 0.8)
                        
                        
                        
                    }


                    
                    Button {
                        //Send Request and upload the file
                        
                        if let onChangeCategory = category {
                            let editedCategory = Category(title: categoryName , image: nil, subCategory: onChangeCategory.subCategory)

                            addCategoryViewModel.editCategory(with: image ,category: category , changedCategory: editedCategory , completionHandler: { isSuccessfull in
                                if isSuccessfull {
                                    isPresented = false
                                    Task {
                                        await addCategoryViewModel.getServices()
                                        
                                    }
                                }
                            })
                        } else {
                            
                            let category = Category(title: categoryName, image: nil, subCategory: [SubCategory]())
                            self.category = category
                        }
                        
                        
                        

                    } label: {
                        GreenFunctionButton(buttonText: "Edit".localized(language), isAnimated: $addCategoryViewModel.isRequesting)
                            .frame(width: UIScreen.screenWidth - 50 , height: 45)
                    }
                    .disabled(addCategoryViewModel.isRequesting)

                }
                
                .padding(.bottom)
            }
            
            .popup(isPresented: $addCategoryViewModel.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: addCategoryViewModel.errorMessage)
            }, customize: {
                $0
                    .animation(.spring())
                    .autohideIn(3)
                    .position(.bottom)
                    .type(.floater())
            })
            
        }
        
        
        .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
            
            
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }

        
    }
    
    
    
}
