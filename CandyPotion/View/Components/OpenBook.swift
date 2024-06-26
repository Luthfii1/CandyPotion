//
//  Coba.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//
//

import SwiftUI

struct OpenBook: View {
    @Binding var selectedIndex: Int
    @State private var progress: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0

    var body: some View {
        VStack {
            OpenableBookView(config: .init(progress: progress)) { size in
                FrontView(size)
            } insideLeft: { _ in
                LeftView()
            } insideRight: { _ in
                RightView()
            }
            .animation(.easeInOut(duration: 0.5), value: progress) // Add animation here
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.width / UIScreen.main.bounds.width
                    }
                    .onEnded { value in
                        let dragProgress = value.translation.width / UIScreen.main.bounds.width
                        progress = max(0, min(1, progress - dragProgress))
                    }
            )
            .onChange(of: dragOffset) { newValue in
                progress = max(0, min(1, progress - newValue))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if progress >= 1 {
                        selectedIndex += 1
                        progress = 0 // Reset progress for the next page
                    }
                }
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    func FrontView(_ size: CGSize) -> some View {
        Image("page-right")
            .resizable()
            .frame(width: 386, height: 592)
            .padding(.trailing, 7)
        
        
    }

    @ViewBuilder
    func LeftView() -> some View {
        Image("page-left")
            .resizable()
            .frame(width: 386, height: 592)
            .padding(.leading, 7)
    }

    @ViewBuilder
    func RightView() -> some View {
//        Image("page-right")
//            .resizable()
//            .frame(width: 386, height: 592)
//            .padding(.leading, 7)
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 380, height: 592)
            .background(Color(red: 1, green: 0.96, blue: 0.88))
            .overlay(
                Rectangle()
                    .inset(by: 1.5)
                    .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
            )
    }
}

/// Interactive Book Card View
struct OpenableBookView<Front: View, InsideLeft: View, InsideRight: View>: View {
    var config: Config = .init()
    @ViewBuilder var front: (CGSize) -> Front
    @ViewBuilder var insideLeft: (CGSize) -> InsideLeft
    @ViewBuilder var insideRight: (CGSize) -> InsideRight

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let progress = max(min(config.progress, 1), 0)
            let rotation = progress * -180

            ZStack {
                insideRight(size)
                    .frame(width: size.width, height: size.height)
//                    .position(x: size.width , y: size.height)

                front(size)
                    .frame(width: size.width, height: size.height)
                    .rotation3DEffect(
                        .degrees(Double(rotation)),
                        axis: (x: 0, y: 10, z: 0),
                        anchor: .leading,
                        perspective: 0.3
                    )
//                    .position(x: size.width, y: size.height)
            }
            .offset(x: (config.width) * 2.4 * progress)
        }
    }

    struct Config {
        var width: CGFloat = 150
        var height: CGFloat = 200
        var progress: CGFloat = 0
    }
}

struct OpenBookView_Previews: PreviewProvider {
    static var previews: some View {
        OpenBook(selectedIndex: .constant(5))
    }
}
