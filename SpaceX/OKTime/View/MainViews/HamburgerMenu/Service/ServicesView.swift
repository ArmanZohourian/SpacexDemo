//
//  ServicesView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI
import ExytePopupView

struct ServicesView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    
    var colors: ConstantColors
    @State var category: Category = Category(title: "")
    //MARK: Instances
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    @EnvironmentObject var businessServiceViewModel : BusinessServicesViewModel
    
    @StateObject var businessServiceAddCategortViewModel = BusinessServiceAddCategoryViewModel()
    
    @StateObject var getServicesViewModel = ServicesViewModel()
    
    @StateObject var addCategoryViewModel = BusinessServiceAddCategoryViewModel()

    @State var isShown : Bool = false
    @State var isShownEditing: Bool = false
    @State var categoryName: String = ""
    @State var categoryImage: Data?
    @State var price: String = ""
    @State var isRequested  : Bool = false
    @State private var selection: Category?
    @State private var categories : [Category] = [
        Category(title: "اصلاح موی سر"),
        Category(title: "رنگ موی سر")
    ]
    @State var isShowingSubCategory : Bool = false {
        didSet {
            
        }
    }
    
    var isNavigate: Binding<Bool> {   // link activator !!
        Binding(get: { selection != nil}, set: { _ in selection = nil })
    }

    
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
    
    var body: some View {
        
        
        //MARK: Main View
        GeometryReader { geometry in
 
                VStack(spacing: 10) {
                                        
                    CustomNavigationTitle(name: "services".localized(language), logo: "briefcase", colors: colors)
                        .foregroundColor(colors.whiteColor)
                        .edgesIgnoringSafeArea(.top)
                            
                        
                        
                    
    
                    AddButtonView(buttonText: "add_service".localized(language), colors: ConstantColors())
                        .onTapGesture {
                            self.isShown.toggle()
                        }
                    
                    List(getServicesViewModel.categories)  { category in
                        
                        
                        ZStack {
                            
                            CustomListView(colors: colors, description: String(category.subCategory?.count ?? 0), isSubCategory: false, categoryName: category.title, image: category.image, isShowingSubCategory: $isShowingSubCategory, category: category)
                                .environmentObject(businessServiceAddCategortViewModel)
                                .overlay(alignment: .trailing, content: {
                                    //fixing the overlap on tap gesture ( toggler and the cell)
                                    Rectangle()
                                        .foregroundColor(Color.clear)
                                        //Making it tappable
                                        .contentShape(Rectangle())
                                        .padding(.leading, 100)
                                        .onTapGesture {
                                            self.selection = category
                                            businessServiceAddCategortViewModel.selectedCategory = category
                                            self.category = category
                                        }
                                })
                                
                            
                        }
                        
                                .background(colors.cellColor)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                                    Button {
                                        //Delete from list
                                        Task {
                                        
                                        await getServicesViewModel.deleteCategory(with: category)
                                    }


                                    } label: {
                                        VStack {
                                            Image("trash")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .aspectRatio(contentMode: .fit)


                                            Text("business_service_delete_category".localized(language))

                                        }
                                    }
                                    .tint(.red)

                                    Button {
                                        //Edit from list
                                        editCategory(category: category)


                                    } label: {
                                        VStack {
                                            Image("edit-button")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .aspectRatio(contentMode: .fit)

                                            Text("business_service_edit_category".localized(language))
                                                .font(.system(size: 4))
                                        }
                                    }
                                    .tint(.orange)


                                }
                                
                        
                        
                    }
                    
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        //MARK: Send request to network
                    }, label: {
                        GreenFunctionButton(buttonText: "register_info".localized(language), isAnimated: .constant(false))
                    })
                        .frame(width: UIScreen.screenWidth - 50 , height: 45)
                        .padding(.bottom, 20)
                        .offset(y: isShown ? 80 : 0)
                }
            
                .popup(isPresented: $getServicesViewModel.hasError, view: {
                    FloatBottomView(colors: colors.redColor, errorMessage: getServicesViewModel.errorMessage)
                }, customize: {
                    $0
                        .animation(.spring())
                        .autohideIn(5)
                        .position(.bottom)
                        .type(.floater())
                    
                })

            
        }
        .background(content: {
            NavigationLink(isActive: isNavigate) {
                ServiceAddSubcategory(colors: colors, category: $category)
                                                                .environmentObject(businessServiceAddCategortViewModel)
                                                                .environmentObject(keyboardResponder)
            } label: {
                EmptyView()
                    .foregroundColor(Color.clear)
            }
            

        })
        .task {
            await getServicesViewModel.getServices()
            
        }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        
 


        
        

            .popup(isPresented: $isShown, view: {
                AddCategoryView(colors: colors, isPresented: $isShown)
                    .environmentObject(addCategoryViewModel)
                    .environmentObject(getServicesViewModel)
                    .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
            }, customize: {
                $0
                    .type(.toast)
                    .position(.bottom)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.4))
            })
        
        
        
        
        
        
            .popup(isPresented: $isShownEditing, view: {
                EditCategoryHamburgerView(colors: colors, categoryName: categoryName, isPresented: $isShownEditing, category: getServicesViewModel.selectedCategory)
                      .environmentObject(getServicesViewModel)
                      .padding(.bottom, keyboardResponder.currentHeight)
                      .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
            }, customize: {
                    
                $0
                    .backgroundColor(.black.opacity(0.4))
                    .position(.bottom)
                    .closeOnTap(false)
                    .closeOnTapOutside(true)
                    .type(.toast)
            })
        
        
            .overlay(alignment: .center, content: {
                if isShowingSubCategory {

                    BottomSheetView(isPresenteed: $isShowingSubCategory) {
                                AddSubCategoryHamburgerView(colors: colors, category: $category, subCategoryName: "", priceName: "", showSheet: false, isPresented: $isShowingSubCategory)
                                    .environmentObject(getServicesViewModel)
                                    .environmentObject(businessServiceAddCategortViewModel)
                                    .environmentObject(keyboardResponder)

                            }
                    }
            })

        
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        
    }
    
    
    //MARK: DELETE SHOUDL BE ASSINGED

    func delete(at offsests: IndexSet) {
        businessServiceAddCategortViewModel.categories.remove(atOffsets: offsests)
    }


    func getIndex(item: Category) -> Int {
        return categories.firstIndex { (item1) -> Bool in
            return item.id  == item1.id
        } ?? 0
    }
    
    private func editCategory(category : Category) {
        
//        self.category = category
        self.getServicesViewModel.selectedCategory = category
        self.isShownEditing = true
        
    }
    
    private func editSubCategory(category: Category) {
        self.category = category
        self.isShowingSubCategory = true
    }
}

//struct ServicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesView(colors: ConstantColors(), token: .constant(""))
//    }
//}
