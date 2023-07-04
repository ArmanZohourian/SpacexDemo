//
//  CustomMapView.swift
//  OKTime
//
//  Created by Arman Zohourian on 12/6/22.
//

import SwiftUI
import MapKit

struct CustomMapView: View {
    
    
    @State var userCoordinate: String = "" {
        didSet {
            print("User coordinate is: \(userCoordinate)")
        }
    }
    
    @State var customLocation = MapLocation(latitude: 0, longitude: 0) {
        didSet {
            userCoordinate = String(format: "%.6f" ,customLocation.latitude)
            userCoordinate +=  ","
            userCoordinate +=  String(format: "%.6f" ,customLocation.longitude)
        }
    }
    
    @State var longPressLocation = CGPoint.zero
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3,
                                       longitude: -122.02),
        span: MKCoordinateSpan(latitudeDelta: 0.1,
                               longitudeDelta: 0.1))
    
    @State var isShowingFullScreenMap = false
    
    var body: some View {
        
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
//                                                   printLocation()
                                               
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
        
        
        
    }
}


private extension CustomMapView {
    
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


struct CustomMapView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMapView()
    }
}
