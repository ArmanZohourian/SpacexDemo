//
//  BusinessServicesView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//

import SwiftUI
import ExytePopupView
struct BusinessServicesView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    var colors: ConstantColors
    
    @State var category: Category = Category(title: "")
    
    
    //MARK: Instances
    @StateObject var keyboardResponder: KeyboardResponder = KeyboardResponder()
    
    
    @EnvironmentObject var businessServiceViewModel : BusinessServicesViewModel
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    
    @StateObject var businessServiceAddCategortViewModel = BusinessServiceAddCategoryViewModel()
    
    @StateObject var getServicesViewModel = ServicesViewModel()
    
    
    @State private var selection: Category?
    @State var isShown : Bool = false
    @State var isShownEditing: Bool = false
    @State var categoryName: String = ""
    @State var categoryImage: Data?
    @State var price: String = ""
    @State var isRequested  : Bool = false
    @Binding var token: String
    
    @State private var categories : [Category] = [
        Category(title: "اصلاح موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
        Category(title: "رنگ موی سر"),
    ]
    
    @State var isShowingSubCategory : Bool = false
    
    var isNavigate: Binding<Bool> {   // link activator !!
        Binding(get: { selection != nil}, set: { _ in selection = nil })
    }

    var body: some View {
        
        GeometryReader { geometry in
            
            
                VStack(spacing: 10) {
                    
    
                    CustomFlowView(colors: colors,
                                    flowDescription: "business_service_subheader".localized(language)
                                    , flowImage: "user-service-flow",
                                    flowBgImage: "service-flow")
                    
                    
                    Button {
                        self.isShown.toggle()
                    } label: {
                        AddButtonView(buttonText: "business_service_add_button_text".localized(language), colors: colors)
                    }
                        .padding(.top)
                    
                    
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("business_service_categories".localized(language))
                            .font(.custom("YekanBakhNoEn-Bold", size: 20))
                        Text("business_service_categories_description".localized(language))
                            .font(.custom("YekanBakhNoEn-Regular", size: 12))
                            .foregroundColor(colors.grayColor)
                            .environment(\.layoutDirection, language == .persian ? .rightToLeft : .leftToRight)
                    }
                    .padding()
                    
                    
                    
                        List(businessServiceAddCategortViewModel.categories)  { category in
                            
                            
                            ZStack {
                                
                                CustomListView(colors: colors, description: String(category.subCategory?.count ?? 0), isSubCategory: false, categoryName: category.title, image: category.image, isShowingSubCategory: $isShowingSubCategory, category: category)
                                    .environmentObject(businessServiceAddCategortViewModel).overlay(alignment: .trailing, content: {
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
                                               await businessServiceAddCategortViewModel.deleteCategory(with: category)
                                               await businessServiceAddCategortViewModel.getServices()
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
                        .background(content: {
                            NavigationLink(isActive: isNavigate) {
                                BusinessAddSubCategoryView(colors: colors, category: $category)
                                                                                .environmentObject(businessServiceAddCategortViewModel)
                                                                                .environmentObject(keyboardResponder)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0.0)
                            .buttonStyle(PlainButtonStyle())
                            

                        })
                        .listStyle(.plain)
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: AddShiftView(colors: colors)
                        .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                        .environmentObject(keyboardResponder)
                        .environmentObject(baseViewModel)
                    )
                        {
                            
                            GreenFunctionButton(buttonText: "business_service_button_text".localized(language), isAnimated: .constant(false))
                                
                            
                        }
                    
                    .disabled(businessServiceAddCategortViewModel.isNotCategoryAdded)
                    .onTapGesture {
                        businessServiceAddCategortViewModel.checkIfHasNotAddedCategory()
                    }
                    
                    .frame(width: UIScreen.screenWidth - 30 , height: 45)
                    .padding(.bottom, 20)
                    .offset(y: isShown ? 80 : 0)
                }
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                
                
                .popup(isPresented: $businessServiceAddCategortViewModel.hasError, view: {
                    FloatBottomView(colors: colors.redColor, errorMessage: businessServiceAddCategortViewModel.errorMessage)
                }, customize: {
                    $0
                        .type(.toast)
                        .autohideIn(5)
                        .animation(.spring())
                        .position(.bottom)
                })
            

                
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        
        }
        .task {
           await businessServiceAddCategortViewModel.getServices()
        }
        
        
        
        .popup(isPresented: $businessServiceAddCategortViewModel.hasError, view: {
            FloatBottomView(colors: colors.redColor, errorMessage: businessServiceAddCategortViewModel.errorMessage)
        }, customize: {
            $0
                .type(.toast)
                .autohideIn(5)
                .animation(.spring())
                .position(.bottom)
        })
        
        
        
        .popup(isPresented: $isShownEditing, view: {
            EditCategoryView(colors: colors, categoryName: categoryName, isPresented: $isShownEditing, category: self.category)
                .environmentObject(keyboardResponder)
                .environmentObject(businessServiceAddCategortViewModel)
        }, customize: {
            $0
                .closeOnTapOutside(true)
                .type(.toast)
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
                .position(.bottom)
        })
        
        .popup(isPresented: $isShown, view: {
            
            AddCategoryView(colors: colors, categoryName: categoryName, isPresented: $isShown, category: nil)
                .environmentObject(keyboardResponder)
                .environmentObject(businessServiceAddCategortViewModel)
                .environmentObject(getServicesViewModel)
                .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
        }, customize: {
            $0
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .type(.toast)
                .position(.bottom)
                .backgroundColor(.black.opacity(0.4))
        })
        
        

        
        .overlay(alignment: .center, content: {
            if isShowingSubCategory {

                BottomSheetView(isPresenteed: $isShowingSubCategory) {
                                AddSubcategoryView(colors: colors, category: $category, subCategoryName: "", priceName: "", showSheet: false, isPresented: $isShowingSubCategory)
                                    .environmentObject(keyboardResponder)
                                    .environmentObject(businessServiceAddCategortViewModel)
                                    .environment(\.layoutDirection, language == .english ? .rightToLeft : .leftToRight)
                                    .ignoresSafeArea(.keyboard, edges: .bottom)

                        }
                }
        })
        
        
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: NavigationItemsView(title: "business_service_header".localized(language), isBackButtonHidden: false))
        
        .edgesIgnoringSafeArea([.top, .bottom])
        
    }
    
    
    private func editCategory(category : Category) {
        
        self.category = category
        self.isShownEditing = true
        
    }
    
    private func editSubCategory(category: Category) {
        self.category = category
        self.isShowingSubCategory = true
    }

}
