//
//  ContentView.swift
//  TestProject
//
//  Created by Arman Zohourian on 12/21/22.
//

import SwiftUI
import Combine

struct BottomSheetView<Content: View>: View {
    
    
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @State var hasReachedMaximumHeight = false
    @GestureState var gestureOffset: CGFloat = 0
    @Binding var isPresented: Bool
    
    let keyboardResponder = KeyboardResponder()
    
    let content: Content
    
    init(offset: CGFloat = 0, lastOffset: CGFloat = 0 , gestureOffset: CGFloat = 0, isPresenteed: Binding<Bool> , @ViewBuilder content: () -> Content) {
        
        
        self._isPresented = isPresenteed
        self.content = content()
        
        
        
    }
    
    var body: some View {
        
        ZStack {
            
            // For getting Frame for image
            GeometryReader { proxy in

                Color.black.opacity(0.4)
                    .transaction({ transaction in
                        transaction.animation = .none
                    })

                    .onTapGesture {
                        isPresented.toggle()
                        hideKeyboard()
                    }
                
                
                
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .ignoresSafeArea()
            
            // For getting height for drag gesture
            GeometryReader { proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                
                
                return AnyView(
                    
                    ZStack {
                        
                        Color.white
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                            
                        
                            
                        
                        VStack {
//                            Capsule()
//                                .fill(Color.white)
//                                .frame(width: 80, height: 4)
//                                .padding(.top, 20)
                            
                            
                            content
                                .frame(width: UIScreen.screenWidth)
                            
                             
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        
                    }
                    .padding(.top, 100)
                    .offset(y: (height - 100) / 3)
                    .offset(y: offset)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        
                        out = value.translation.height
                        onChange()
                        
                    }).onEnded({ value in
                        
                        let maxHeight = height - 100
                        withAnimation {
                            
                            
                            //Logic Conditions for Moving States...
                            // Up down or mid
                            if -offset > 100 && -offset < maxHeight / 2 {
                                //Mid
                                offset = -(maxHeight / 3)
                                
                            }
                            else if -offset > maxHeight / 2 && hasReachedMaximumHeight {
                                offset = -maxHeight / 1.2
                                hasReachedMaximumHeight = true
                                
                            }
                            else {
                                offset = 0
                            }
  
                        }
 
                        
                        //Storing Last offset...
                        // so the gesture can continue
                        
                        ////Preventing the view getting out of the screen size height
                        if !hasReachedMaximumHeight {
                           lastOffset = offset
                        }
                        
                        //// if Showing keyboard we will change the sheet position to full view

                        
                        
                        
                    }))
                    .onReceive(Just(self.keyboardResponder.isKeyboardVisible), perform: { isVisible in
                        if isVisible {
                            let maxHeight = height - 100
                            offset = -maxHeight / 1.2
                            hasReachedMaximumHeight = true
                        }
                    })
           
                )
                
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
        
        .transition(.move(edge: .bottom))
        .transaction { transaction in
            transaction.animation = .linear
            
        }

        
    }
    
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    

    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
