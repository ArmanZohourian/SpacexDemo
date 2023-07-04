//
//  AddCategoryHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/1/22.
//

import SwiftUI

struct AddCategoryHamburgerView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    var colors: ConstantColors
    @State var categoryName: String = ""
    @Binding var isPresented: Bool
    @State var showSheet: Bool = false
    @State var image = UIImage()
    @State var category : Category? = nil
    @EnvironmentObject  var addCategoryViewModel : ServicesViewModel
    @ObservedObject var keyboardResponder = KeyboardResponder()
    var body: some View {

        
        
        VStack(spacing: 20) {

            ZStack {
                HStack {
                    Image("close-circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                                isPresented = false
                                }
                        .offset(y: -60)
                    Spacer()
                    EmptyView()
                }
                if let onChangeCategory = category {
                    CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: onChangeCategory.title , text: $categoryName, isPassword: false)
                } else {
                    CustomTextField(colors: colors, labelName: "category_name_label".localized(language), placeholder: "category_name_placeholder".localized(language), text: $categoryName, isPassword: false)
                }

            }
            .padding(.top , -40)
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
//                        if let onChangeCategory = category {
//                            if let imageData = onChangeCategory.image {
//                                Image(uiImage: UIImage(data: imageData) ?? UIImage())
//                                    .resizable()
//                                    .frame(width: 40, height: 40)
//                                    .cornerRadius(10)
//                                    .background(Color.clear)
//                            }
//                        } else {
//                            Image(uiImage: self.image)
//                                .resizable()
//                                .frame(width: 40, height: 35)
//                                .aspectRatio(contentMode: .fill)
//                                .clipShape(Circle())
//                                .cornerRadius(10)
//                                .background(Color.clear)
//                        }


                        
                    }
                    .frame(width: UIScreen.screenWidth - 15)
                }
                .padding()
                .frame(width: UIScreen.screenWidth - 10, height: 45)
                .border(colors.lightGrayColor, width: 0.8)
                
                
                
            }


            
            Button {
                //Send Request and upload the file
                
                addCategoryViewModel.uploadCategory(with: image
                                            , params: ["name" : categoryName,
                                                        "activate" : "true"
                                                                    ]
                                            ,category: category
                                            ,subCategory: nil
                                                )
                isPresented = false
            } label: {
                GreenFunctionButton(buttonText: "category_button_text".localized(language), isAnimated: .constant(false))
                    .frame(width: UIScreen.screenWidth - 50 , height: 45)
            }
            .padding(.bottom, -100)

        }
            
            
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        
        .foregroundColor(.black)
        .frame(maxWidth: UIScreen.screenWidth)
        .frame(height: UIScreen.screenHeight / 2.3)
        .background(Color.white)
        .cornerRadius(15, corners: [.topLeft, .topRight])
        
    }
}

//
//struct AddCategoryHamburgerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddCategoryHamburgerView()
//    }
//}


