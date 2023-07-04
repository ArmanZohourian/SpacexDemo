//
//  CachedImage.swift
//  SpaceX
//
//  Created by Arman Zohourian on 6/28/23.
//

import SwiftUI

struct CachedImage<Content, PlaceHolder>: View where Content: View , PlaceHolder: View{
    
    @StateObject private var manager = CachedImageManager()
    
    let imageUrl: String
    
    private let content: (Image) -> Content
    private let placeholder: () -> PlaceHolder
    
    init(imageUrl: String,@ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> PlaceHolder) {
        self.imageUrl = imageUrl
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            if let data = manager.data, let image = UIImage(data: data) {
                        content(Image(uiImage: image))
                            
                    } else {
                        placeholder()
                        
                    }
        }
        .task {
            await manager.load(imageUrl)
        }
        

    }
}

