//
//  ImageSlider.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/29/23.
//

import SwiftUI

struct ImageSliderView: View {
    
    let imageUrls: [String]
    @Binding var currentIndex : Int
    
    var body: some View {
            VStack(spacing: 10) {
                TabView(selection: $currentIndex) {
                    ForEach(imageUrls.indices, id: \.self) { index in
                        CachedImage(imageUrl: imageUrls[index]) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tag(index)
                                .frame(width: UIScreen.main.bounds.width - 20)
                                .cornerRadius(10)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            }
            .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .center)
    }
}



