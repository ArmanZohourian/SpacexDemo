////
////  popupView2.swift
////  OKTime
////
////  Created by Arman Zohourian on 10/17/22.
////
//
//import SwiftUI
//
//// MARK: - Private Properties
///// The rect of the hosting controller
//@State private var presenterContentRect: CGRect = .zero
//
///// The rect of popup content
//@State private var sheetContentRect: CGRect = .zero
//
///// The offset when the popup is displayed
//private var displayedOffset: CGFloat {
//    -presenterContentRect.midY + screenHeight/2
//}
//
///// The offset when the popup is hidden
//private var hiddenOffset: CGFloat {
//    if presenterContentRect.isEmpty {
//        return 1000
//    }
//    return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
//}
//
///// The current offset, based on the "presented" pro perty
//private var currentOffset: CGFloat {
//    return isPresented ? displayedOffset : hiddenOffset
//}
//private var screenWidth: CGFloat {
//    UIScreen.main.bounds.size.width
//}
//
//private var screenHeight: CGFloat {
//    UIScreen.main.bounds.size.height
//}
