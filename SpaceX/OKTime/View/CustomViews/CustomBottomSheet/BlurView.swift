//
//  BlurView.swift
//  TestProject
//
//  Created by Arman Zohourian on 1/1/23.
//

import SwiftUI

struct BlurView: UIViewRepresentable {

    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.backgroundColor = UIColor.black
        
        return view 
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
