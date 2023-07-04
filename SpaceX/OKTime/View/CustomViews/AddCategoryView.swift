//
//  AddCategoryView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/6/22.
//

import SwiftUI
import UIKit
import ExytePopupView

struct AddCategoryView: View {
    
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    
    var colors: ConstantColors
    

    
    @State var categoryName: String = ""
    
    @Binding var isPresented: Bool
    
    
    @State var showSheet: Bool = false
    
    @State var image = UIImage()
    
    @State var category : Category? = nil
    
    @EnvironmentObject  var addCategoryViewModel : BusinessServiceAddCategoryViewModel
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    
    @EnvironmentObject var getCategoryViewModel: ServicesViewModel
    
    var imagePlaceholder: some View {
        Rectangle()
            .foregroundColor(Color.pink)
            .frame(width: 40, height: 35)
            .cornerRadius(10)
            .padding(.trailing)
            .clipShape(Circle())
    }
    
    var body: some View {

        
        ActionSheetView {
            ScrollView {
                VStack(spacing: 10) {

                    

                        if let onChangeCategory = category {
                            CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: onChangeCategory.title , text: $categoryName, isPassword: false)
                        } else {
                            CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: "category_name_placeholder".localized(language), text: $categoryName, isPassword: false)
                        }


                    //Image Textfield
                    VStack(alignment: .trailing) {
                        Text("category_image_label".localized(language))
                            .foregroundColor(colors.blueColor)
                            .font(.custom("YekanBakhNoEn-Bold", size: 14))
                            
                            
                        
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
                                .padding(.leading)
                                
                                Spacer()

                                //Image
                                if let onChangeCategory = category {
                                    if let imageName = onChangeCategory.image {
                                        AsyncImage(url: URL(string: APIConstanst.imageBaseUrl + imageName) , content: { image
                                            in
                                            image
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .background(Color.clear)
                                                .padding(.trailing)
                                                .clipShape(Rectangle())
                                        }, placeholder: {
                                            imagePlaceholder
                                        })

                                    }
                                } else {
                                    Image(uiImage: self.image)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .cornerRadius(10)
                                        .padding(.trailing)
                                }
                                
                            }
//                            .frame(width: UIScreen.screenWidth - 15)
                        }
                        
                        .frame(width: UIScreen.screenWidth - 20, height: 45)
                        .border(colors.lightGrayColor, width: 0.8)
                        
                    }

                    
                    Button {
                        //Send Request and upload the file
                    
                        hideKeyboard()
                        addCategoryViewModel.uploadCategory(with: image ,categoryName: categoryName ,subCategory: nil, completionHandler: { request in
                            
                            if request {
                                isPresented = false
                                Task {
                                    await getCategoryViewModel.getServices()
                                    await addCategoryViewModel.getServices()
                                }
        
                            }
                            
                        })
                        
                    } label: {
                        GreenFunctionButton(buttonText: "category_button_text".localized(language), isAnimated: $addCategoryViewModel.isRequesting)
                            .frame(width: UIScreen.screenWidth - 50 , height: 45)
                    }
                    .disabled(addCategoryViewModel.isRequesting)
                    


                }

            }
            
        
            .popup(isPresented: $addCategoryViewModel.hasError) {
                FloatBottomView(colors: colors.redColor, errorMessage: addCategoryViewModel.errorMessage)
            } customize: {
                $0
                    .type(.floater())
                    .autohideIn(3)
                    .animation(.spring())
                    .position(.bottom)
            }

            
            
            
        }
                
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    static var colors: ConstantColors = ConstantColors()
    static var previews: some View {
        AddCategoryView(colors: colors, isPresented: .constant(true))
    }
}
