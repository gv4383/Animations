//
//  ContentView.swift
//  Animations
//
//  Created by Goyo Vargas on 11/4/21.
//

import SwiftUI

// Example 8
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

// Example 8
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

// Comment out all examples except
// for the one you want to run
struct ContentView: View {
    //Example 1
    @State private var animationAmount1 = 1.0
    
    // Example 2
    @State private var animationAmount2 = 1.0
    
    // Example 3
    @State private var animationAmount3 = 1.0
    
    // Example 4
    @State private var animationAmount4 = 0.0
    
    // Example 5
    @State private var enabled5 = false
    
    // Example 6.1
    @State private var dragAmount61 = CGSize.zero
    
    // Example 6.2
    let letters = Array("Hello, SwiftUI")
    @State private var enabled62 = false
    @State private var dragAmount62 = CGSize.zero
    
    // Example 7
    @State private var isShowingRed7 = false
    
    // Example 8
    @State private var isShowingRed8 = false
    
    var body: some View {
        // Example 1 - Implicit animations
        Button("Tap Me") {
            animationAmount1 += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount1)
        .blur(radius: (animationAmount1 - 1) * 3)
        .animation(.default, value: animationAmount1)
        
        // Example 2 - Customizing animations
        Button("Tap Me") {
            animationAmount2 += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.red)
                .scaleEffect(animationAmount2)
                .opacity(2 - animationAmount2)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: false),
                    value: animationAmount2
                )
        )
        .onAppear {
            animationAmount2 = 2
        }
        
        // Example 3 - Animating bindings
        VStack {
            Stepper("Scale amount", value: $animationAmount3.animation(
                .easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)

            Spacer()

            Button("Tap Me") {
                animationAmount3 += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount3)
        }
        
        // Example 4 - Explicit animations
        Button("Tap Me") {
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                animationAmount4 += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animationAmount4), axis: (x: 0, y: 1, z: 0))
        
        // Example 5 - Controlling the animation stack
        Button("Tap Me") {
            enabled5.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled5 ? .blue : .red)
        .animation(.default, value: enabled5)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled5 ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled5)
        
        // Example 6.1 - Animating Gestures
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount61)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount61 = $0.translation }
                    .onEnded { _ in
                        dragAmount61 = .zero // use for implicit animation
//                        withAnimation { // explicit animation
//                            dragAmount61 = .zero
//                        }
                    }
            )
            .animation(.spring(), value: dragAmount61) // implicit animation
        
        // Example 6.2 - Animating Gestures
        HStack(spacing: 0) {
            ForEach(0..<letters.count) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled62 ? .blue : .red)
                    .offset(dragAmount62)
                    .animation(
                        .default
                            .delay(Double(num) / 20),
                        value: dragAmount62
                    )
            }
        }
        .gesture(
            DragGesture()
                .onChanged { dragAmount62 = $0.translation }
                .onEnded { _ in
                    dragAmount62 = .zero
                    enabled62.toggle()
                }
        )
        
        // Example 7 - Showing and hiding views with transitions
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed7.toggle()
                }
            }

            if isShowingRed7 {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
        
        // Example 8 - Building custom transitions using ViewModifier
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed8 {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed8.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
