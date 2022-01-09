//
//  PopupExtension.swift
//  BRESS-TournooiPlanner
//
//  Created by Bas Buijsen on 06/01/2022.
//

import SwiftUI

struct OverlayModifier<OverlayView:View> : ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var overlayView: () -> OverlayView
    
    init(isPresented: Binding<Bool>, @ViewBuilder overlayView: @escaping() -> OverlayView){
        self._isPresented = isPresented
        self.overlayView = overlayView
    }
    
    func body(content: Content) -> some View {
        content.overlay(isPresented ? overlayView() : nil)
    }
}

extension View{
    func popup<OverlayView: View>(isPresented: Binding<Bool>,
                                  blurRadius : CGFloat = 3,
                                  blurAnimation: Animation? = .easeInOut,
                                  @ViewBuilder overlayView: @escaping () -> OverlayView) -> some View{
        blur(radius: isPresented.wrappedValue ? blurRadius : 0)
            .animation(blurAnimation)
            .allowsHitTesting(!isPresented.wrappedValue)
            .modifier(OverlayModifier(isPresented: isPresented, overlayView: overlayView))
    }
}

struct BottomPopupView<Content : View> : View {
    @ViewBuilder var content: () -> Content
    
    var body: some View{
        GeometryReader{ geometry in
            VStack{
                Spacer()
                content()
                    .background(Color("ButtonTextBlack"))
                    .cornerRadius(radius: 16, corners: [.topLeft, .topRight])
            }
        }.edgesIgnoringSafeArea([.bottom])
            .animation(.easeInOut)
            .transition(.move(edge: .bottom))
    }
}


struct RoundedCornersShape: Shape{
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View{
    
    func cornerRadius(radius: CGFloat, corners: UIRectCorner = .allCorners) -> some View{
        clipShape(RoundedCornersShape(radius: radius, corners: corners))
    }
}

