//
//  EditSubCategoryHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/4/22.
//

import SwiftUI

struct EditSubCategoryHamburgerView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @EnvironmentObject var getServicesViewModel : ServicesViewModel
    var colors: ConstantColors
    @Binding var category: Category
    @Binding var subCategory: SubCategory
    @State var subCategoryName: String = ""
    @State var priceName: String = ""
    @State var showSheet: Bool = false
    @Binding var isPresented: Bool
    @State private var image = UIImage()
    
    
    
    var body: some View {
        
        
        VStack(alignment: .trailing) {
            
            VStack {
                ZStack {
                    HStack {
                        Image("close-circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .offset(y: 10)
                            .onTapGesture {
                                    isPresented = false
                                    }
                            .offset(y: -40)
                        Spacer()
                        EmptyView()
                    }

                    CustomTextField(colors: colors, labelName: "subcategory_name_label".localized(language), placeholder: "subcategory_name_placeholder".localized(language), text: $subCategoryName, isPassword: false)
                    
                }
                
               
                

                CustomTextField(colors: colors, labelName: "subcategory_price_label".localized(language), placeholder: "", text: $priceName, isPassword: false)
                
                
                VStack(alignment: .trailing) {
                    Text("subcategory_image_label".localized(language))
                        .foregroundColor(Color(red: 14 / 255, green: 31 / 255, blue: 80 / 255))
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .padding()
                        .offset(x: 10)
                    
                    
                    
                    HStack {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Text("subcategory_image_button_text".localized(language))
                                .font(.system(size: 14))
                                .foregroundColor(colors.whiteColor)
                                .frame(width: 100,height: 40)
                                .background(colors.blueColor)
                                .cornerRadius(5)
                        }
                        
                        Spacer()
                        
                        Text("")
                            .foregroundColor(Color.blue)
                        
                        //Image
                        Image(uiImage: self.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .background(Color.clear)
                    }
                    .border(colors.lightGrayColor)
                }

                
                Button {
                    //1 - Send request to sever
                    
                    getServicesViewModel.editSubCategory(with: image, params: ["name": subCategoryName,
                                                                                               "activate": "true",
                                                                                               "cost" : priceName,
                                                                                               "parent_id" : String(category.serverId),
                                                                                               "id" : String(subCategory.serverId)], category: category, subCategory: subCategory)
                    
                    isPresented = false
                } label: {
                    GreenFunctionButton(buttonText: "edit".localized(language), isAnimated: .constant(false))
                        .frame(width: UIScreen.screenWidth - 30 , height: 45)
                }
            }
            .padding()
                // Get its subcategories
                // add it to the view
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
}
