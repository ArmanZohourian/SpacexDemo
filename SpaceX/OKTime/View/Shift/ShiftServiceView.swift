//
//  ServicesView.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/20/

//MARK: DELETE
import SwiftUI

struct ShiftServiceView: View {
    
    @EnvironmentObject var serviceViewModel : ServiceViewModel
    @EnvironmentObject var timeTableViewModel : TimeTableViewModel
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(spacing: 10) {
                ForEach(serviceViewModel.services) { service in
                    if service.parentId == nil {
                        Text(service.name)
                            .padding()
                        .onTapGesture {
//                            timeTableViewModel.choosenService = service
                        }
                    }
                }
            }

        }

    }
}

struct ShiftServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ShiftServiceView()
    }
}
