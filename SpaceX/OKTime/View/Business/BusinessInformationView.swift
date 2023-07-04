//
//  BusinessInformationView.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/17/22.
//


//MARK: Clean up the shit

import SwiftUI
import MapKit

struct BusinessInformationView: View {
    
    
    @AppStorage("language")
    
    private var language = LocalizationService.shared.language
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var colors: ConstantColors
    
    @State private var mapViewModel : MapViewModel = MapViewModel()
    
    
    //Network Properties
    @EnvironmentObject var networkInstance : LoginViewModel
    
    @EnvironmentObject var baseViewModel : BaseViewModel
    
    @StateObject var businessInformationViewModel : BusinessInformationViewModel = BusinessInformationViewModel()
    
    @EnvironmentObject var keyboardResponder : KeyboardResponder
    @State var shopName: String = ""
    @State var managerName: String = ""
    @State var phoneNumber: String = ""
    @State var address: String = ""
    @State var manufactureNo: String = ""
    @State var cityName: String = ""
    @Binding var token: String
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
    
    
    var body: some View {
        
            ScrollView {
                VStack {
//                flowName: "business_information_header".localized(language)
                    //Top Rectangle
                    
                    CustomFlowView(colors: colors, flowDescription: "business_information_subheader".localized(language), flowImage: "user-business-flow", flowBgImage: "business-flow")
                    
                    
                    
                    //Shop Name
                    CustomRegisterField(colors: colors, labelName: "business_information_shop_label".localized(language), placeholder: "business_information_shop_placeholder".localized(language), text: $shopName, errorMessage: $businessInformationViewModel.nameErrorMessage, hasError: $businessInformationViewModel.nameHasError, isPassword: false)
                    
                    CustomRegisterField(colors: colors, labelName: "business_information_phone_number_label".localized(language), placeholder: "021 758 44 12", text: $phoneNumber, errorMessage: $businessInformationViewModel.contactInfoErrorMessage, hasError: $businessInformationViewModel.contactInfoHasError, isPassword: false)
                        .keyboardType(.numberPad)
                    
                    
                    CustomRegisterField(colors: colors, labelName: "business_information_city_label".localized(language), placeholder: "", text: $cityName, errorMessage: $businessInformationViewModel.cityIdErrorMessage, hasError: $businessInformationViewModel.cityIdHasError, isPassword: false)
                                .overlay(alignment: .bottomTrailing, content: {
                                    Text(businessInformationViewModel.choosenCity.cityNameFa.isEmpty ? "business_information_city_placeholder".localized(language) : businessInformationViewModel.choosenCity.cityNameFa + businessInformationViewModel.choosenCity.provinceNameFa)
                                        .onChange(of: businessInformationViewModel.choosenCity.cityNameFa, perform: { newValue in
                                            businessInformationViewModel.cityIdHasError.toggle()
                                        })
                                        .padding(.bottom, 30)
                                        .padding(.trailing)
                                        .font(.custom("YekanBakhNoEn-Regular", size: 12))
                                        .foregroundColor(colors.grayColor)
                                        
                                })
                                .disabled(true)
                                .onTapGesture {
                                    isShowingCityList.toggle()
                                }
                                .overlay(alignment: .bottomLeading) {
                                    Image("arrow-down")

                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 15)
                                        .padding(.leading)
                                        .padding(.bottom, 30)
                                        .onTapGesture {
                                            isShowingCityList.toggle()
                                        }
                                }
                    
                    
                    
                    
                    
                    
                            //MARK: Refactor Map
                            VStack(alignment: .trailing, spacing: -5) {
                                Text("business_information_location_label".localized(language))
                                    .foregroundColor(colors.blueColor)
                                    .font(.custom("YekanBakhNoEn-Bold", size: 14))
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
                            
                    
                    
                    CustomRegisterField(colors: colors, labelName: "business_information_address_label".localized(language), placeholder: "business_information_address_placeholder".localized(language), text: $address, errorMessage: $businessInformationViewModel.addressErrorMessage, hasError: $businessInformationViewModel.addressHasError, isPassword: false)
                    
                    
                    CustomRegisterField(colors: colors, labelName: "business_information_certificate_number_label".localized(language), placeholder: "12-142577-00001245", text: $manufactureNo, errorMessage: $businessInformationViewModel.identifierIdErrorMessage, hasError: $businessInformationViewModel.identifierIdHasError, isPassword: false)
                        .keyboardType(.numberPad)
                        .offset(y: -20)
                        .padding()

                }
                Button {
                    Task {
                        await businessInformationViewModel.submitBusinessInfo(name: shopName ,identifierId: manufactureNo ,address: address ,location: userCoordinate ,cityId: String(businessInformationViewModel.choosenCity.id) ,contactInfo: phoneNumber)
                    }
                    
                } label: {
                    GreenFunctionButton(buttonText: "business_information_button_text".localized(language), isAnimated: $businessInformationViewModel.isRequesting )
                }
                .frame(width: UIScreen.screenWidth - 50 , height: 45)
                .padding(.bottom , 30)
                .padding(.bottom, keyboardResponder.currentHeight)
                .disabled(businessInformationViewModel.isRequesting)

            }
        
            
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
        
                .popup(isPresented: $businessInformationViewModel.hasError, view: {
                    FloatBottomView(colors: colors.redColor, errorMessage: businessInformationViewModel.errorMessage)
                        .padding(.bottom, keyboardResponder.currentHeight)
                        .padding(.bottom)
                }, customize: {
                    $0
                        .position(.bottom)
                        .type(.floater())
                        .autohideIn(3)
                        .animation(.spring())
                })

        .onTapGesture {
                    hideKeyboard()
            }

        
        .edgesIgnoringSafeArea([.top,.bottom])

        .sheet(isPresented: $isShowingCityList, content: {
            CityView(colors: colors, isPresented: $isShowingCityList)
                .environmentObject(businessInformationViewModel)
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
        .navigationBarItems(leading: NavigationItemsView(title: "business_information_header".localized(language), isBackButtonHidden: true))
        
        .background(
            
            NavigationLink(destination: BusinessServicesView(colors: colors,token: .constant(""))
                .environment(\.layoutDirection, language.rawValue == "en" ? .rightToLeft : .leftToRight)
                .environmentObject(baseViewModel)
                .environmentObject(networkInstance)
                            , isActive: $businessInformationViewModel.isReceived
                           , label: {
                               EmptyView()
                           })
        
        )
    }
    
    private func printLocation() {
        print("x: \(longPressLocation.x) - y: \(longPressLocation.y)")
    }
}



struct MapLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}

extension MapLocation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

private extension BusinessInformationView {
    
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
