//
//  HalfHeightSheet.swift
//  OKTime
//
//  Created by Arman Zohourian on 10/19/22.
//

import SwiftUI
import UIKit

extension View {
    
    func halfSheet<SheetView: View>(showSheet: Binding<Bool>, @ViewBuilder sheetView: @escaping ()-> SheetView) -> some View {
        
        return self
            .overlay(
                HalfSheetAssist(sheetView: sheetView(),showSheet: showSheet)
            )
    }
    
    
}

struct HalfSheetAssist<SheetView:View>: UIViewControllerRepresentable {
    
    var sheetView: SheetView
    let controller = UIViewController()
    @Binding var showSheet: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        
        if showSheet {
            
            let sheetController = CustomHostingController(rootView: sheetView)
            
            //Presenting the view
            uiViewController.present(sheetController, animated: true) {
                
                
                DispatchQueue.main.async {
                    self.showSheet.toggle()
                }
                
            }
            
        }
        
    }
    
}

// Custom UIHostingController for halfSheet
class CustomHostingController<Content:View> : UIHostingController<Content> {
    
    
    override func viewDidLoad() {
        
        // setting presentation controller properties
        if let presentationController = presentationController as?  UISheetPresentationController{
                
            presentationController.detents = [
                .medium(),
                .large()
            ]
        }
        
    }
    
}
