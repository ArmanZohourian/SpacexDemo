//
//  BussinessInformationHamburgerView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/16/22.
//

import SwiftUI
import MapKit
import ExytePopupView

struct BussinessInformationHamburgerView: View {
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var colors: ConstantColors
    
    @State private var mapViewModel : MapViewModel = MapViewModel()
    
    
    @StateObject var cityObject : BusinessInformationViewModel = BusinessInformationViewModel()
    @StateObject var updateBusinessInfoViewModel : UpdateBusinessInfoViewModel = UpdateBusinessInfoViewModel()
    
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    @State var shopName: String = ""
    @State var managerName: String = ""
    @State var phoneNumber: String = ""
    @State var address: String = ""
    @State var manufactureNo: String = ""
    @State var cityName: String = ""
    
    
    @State var userCoordinate: String = "" {
        didSet {
            print("User coordinate is: \(userCoordinate)")
        }
    }
    
    
    
    
    @State var isShowingFullScreenMap : Bool = false
    @State var isShowingCityList: Bool = false
    
    
    
    //Map Properties
    @State var longPressLocation = CGPoint.zero
    @State var customLocation = MapLocation(latitude: 0, longitude: 0) {
        didSet {
            userCoordinate = String(format: "%.6f" ,customLocation.latitude)
            userCoordinate +=  ","
            userCoordinate +=  String(format: "%.6f" ,customLocation.longitude)
        }
    }
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3,
                                       longitude: -122.02),
        span: MKCoordinateSpan(latitudeDelta: 0.1,
                               longitudeDelta: 0.1))
    
    
    
    
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
        
        GeometryReader { geometry in
            VStack {
                ScrollView {
                        
                    //TopRectangle
                    
                
                    CustomNavigationTitle(name: "business_information".localized(language), logo: "briefcase", colors: colors)
                        .foregroundColor(colors.whiteColor)
                        .edgesIgnoringSafeArea(.top)
                        
                    
                            
                    CustomTextField(colors: colors, labelName: "shop_name".localized(language), placeholder: "shop_name_example".localized(language), text: $shopName)
                    
                    CustomTextField(colors: colors, labelName: "home_phone_number".localized(language), placeholder: "021 758 44 12", text: $phoneNumber)
                        .keyboardType(.numberPad)
                            
                    CustomTextField(colors: colors, labelName: "city".localized(language), placeholder: "", text: $cityName)
                    
                        .overlay(alignment: .trailing, content: {
                            Text(updateBusinessInfoViewModel.choosenCity.cityNameFa.isEmpty ? "به عنوان مثال کشور ایران خراسان رضوی مشهد" : updateBusinessInfoViewModel.choosenCity.cityNameFa + updateBusinessInfoViewModel.choosenCity.provinceNameFa)
                                .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                .foregroundColor(colors.grayColor)
                                .padding(.trailing)
                                .offset(y: 25)
                        })
                                .disabled(true)
                                .onTapGesture {
                                    isShowingCityList.toggle()
                                }
                    
                            
                            //MARK: Refactor Map
                            VStack(alignment: .trailing) {
                                Text("location".localized(language))
                                    .foregroundColor(colors.blueColor)
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .padding()
                                    .offset(x: 10)
                                Map(coordinateRegion: $region, annotationItems: [customLocation],
                                    annotationContent: { location in
                                    MapMarker(coordinate: location.coordinate, tint: .red)
                                })
                                    .frame(width: UIScreen.screenWidth - 30, height: 90)
                                    .onAppear {
                                        Task {
                                            await mapViewModel.checkIfLocationServicesIsEnabled()
                                        }
                                    }
                                    .onTapGesture {
                                        self.isShowingFullScreenMap = true
                                    }
                            }
                            
                    CustomTextField(colors: colors, labelName: "address".localized(language), placeholder: "city_example".localized(language), text: $address)
                            
                            
                    CustomTextField(colors: colors, labelName: "certificate_number".localized(language), placeholder: "12-142577-00001245", text: $manufactureNo)
                        .keyboardType(.numberPad)
                            
                        
                        .offset(y: -20)
                        .padding()
                        
                    Button {
                        Task {
                            await updateBusinessInfoViewModel.updateBusinessInfo(name: shopName ,identifierId: manufactureNo ,address: address ,location: userCoordinate ,cityId: String(updateBusinessInfoViewModel.choosenCity.id) ,contactInfo: phoneNumber)
                        }
                        
                    } label: {
                        GreenFunctionButton(buttonText: "register_info".localized(language), isAnimated: $updateBusinessInfoViewModel.isRequesting)
                    }
                    .disabled(updateBusinessInfoViewModel.isRequesting)
                    .frame(width: UIScreen.screenWidth - 50 , height: 45)
                    .padding(.bottom , 30)
                    .padding(.bottom, keyboardResponder.currentHeight)
                    
                }

            }
            
            .frame(width: geometry.size.width, height: geometry.size.height)
            .padding(.bottom, keyboardResponder.currentHeight)

        }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        
            .task {
                
                await updateBusinessInfoViewModel.getBusinessInfo()
                
                shopName = updateBusinessInfoViewModel.businessInfo?.businessName ?? ""
                phoneNumber = updateBusinessInfoViewModel.businessInfo?.phoneNumber ?? ""
                manufactureNo = String(updateBusinessInfoViewModel.businessInfo?.businessIdentityNumber ?? 0)
                updateBusinessInfoViewModel.choosenCity = City(id: 1, cityName: updateBusinessInfoViewModel.businessInfo?.cityName ?? "", cityNameFa: updateBusinessInfoViewModel.businessInfo?.cityNameLocal ?? "" , provinceName: "", provinceNameFa: "")
                address = updateBusinessInfoViewModel.businessInfo?.address ?? ""
                
                
            }
        

            .popup(isPresented: $updateBusinessInfoViewModel.hasError, view: {
                FloatBottomView(colors: colors.redColor, errorMessage: updateBusinessInfoViewModel.errorMessage)
            }, customize: {
                $0
                    .animation(.spring())
                    .autohideIn(3)
                    .position(.bottom)
                    .type(.floater())
            })
        
        
            .popup(isPresented: $updateBusinessInfoViewModel.isSuccessful, view: {
                FloatBottomView(colors: Color.green, errorMessage: updateBusinessInfoViewModel.errorMessage)
            }, customize: {
                $0
                    .animation(.spring())
                    .autohideIn(3)
                    .position(.bottom)
                    .type(.floater())
            })
        
        
            
        
        
        .onTapGesture {
            hideKeyboard()
        }
        .edgesIgnoringSafeArea([.top,.bottom])

        
        .sheet(isPresented: $isShowingCityList, content: {
            CityHamburgerView(colors: colors, isPresented: $isShowingCityList)
                .environmentObject(updateBusinessInfoViewModel)
        })
        .sheet(isPresented: $isShowingFullScreenMap, content: {
            
            ZStack(alignment: .topLeading) {

                GeometryReader { proxy in
                    Map(coordinateRegion: $region, annotationItems: [customLocation],
                        annotationContent: { location in
                        MapMarker(coordinate: location.coordinate, tint: .red)
                    })
                        .gesture(LongPressGesture(
                                       minimumDuration: 0.25)
                                       .sequenced(before: DragGesture(
                                           minimumDistance: 0,
                                           coordinateSpace: .local))
                                           .onEnded { value in
                                               switch value {
                                               case .second(true, let drag):
                                                   longPressLocation = drag?.location ?? .zero
                                                   customLocation = convertTap(at: longPressLocation, for: proxy.size)
                                               default:
                                                   break
                                               }
                                           })
                                   .highPriorityGesture(DragGesture(minimumDistance: 10))
                    Button("Done") {
                        isShowingFullScreenMap = false
                    }
                    .padding([.leading, .top], 20)
                }

            }
          
        })
        .navigationBarBackButtonHidden()
    }
    
    
    private func printLocation() {
        print("x: \(longPressLocation.x) - y: \(longPressLocation.y)")
    }
    
}



struct BussinessInformationHamburgerView_Previews: PreviewProvider {
    static var previews: some View {
        BussinessInformationHamburgerView(colors: ConstantColors())
    }
}


private extension BussinessInformationHamburgerView {
    
    func convertTap(at point: CGPoint, for mapSize: CGSize) -> MapLocation {
        let lat = region.center.latitude
        let lon = region.center.longitude
        
        let mapCenter = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
        
        // X
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * region.span.longitudeDelta/2
        
        // Y
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * region.span.latitudeDelta/2
        
        return MapLocation(latitude: lat - ySpan, longitude: lon + xSpan)
    }
}
