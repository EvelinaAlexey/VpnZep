//
//  SwipeToUnlockView.swift
//  VpnFly
//
//  Created by Эвелина Пенькова on 14.06.2024.
//

import SwiftUI

extension View {
    func gradientForeground(colors: [Color], startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) -> some View {
        self.overlay(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
}

extension Comparable {
    func clamp<T: Comparable>(lower: T, _ upper: T) -> T {
        return min(max(self as! T, lower), upper)
    }
}

extension CGSize {
    static var inactiveThumbSize:CGSize {
        return CGSize(width: 70, height: 50)
    }
    
    static var activeThumbSize:CGSize {
        return CGSize(width: 85, height: 50)
    }
    
    static var trackSize:CGSize {
        return CGSize(width: 280, height: 50)
    }
}

extension SwipeToUnlockView {
    func onSwipeSuccess(_ action: @escaping () -> Void ) -> Self {
        var this = self
        this.actionSuccess = action
        return this
    }
}


struct SwipeToUnlockView: View {
    
    // we want to animate the thumb size when user starts dragging (swipe)
    @State private var thumbSize:CGSize = CGSize.inactiveThumbSize
    
    // we need to keep track of the dragging value. Initially its zero
    @State private var dragOffset:CGSize = .zero
    
    // Lets also keep track of when enough was swiped
    @State private var isEnough = false
    
    // Actions
    private var actionSuccess: (() -> Void )?
    
    
    // The track does not change size
    let trackSize = CGSize.trackSize
    
    var body: some View {
        ZStack {
            // Swipe Track
            Capsule()
                .frame(width: trackSize.width, height: trackSize.height)
                .foregroundColor(Color.white)
                .overlay(
                    Capsule()
                        .stroke(LinearGradient(
                            stops: [
                            Gradient.Stop(color: Color(red: 0, green: 1, blue: 0.76).opacity(0.66), location: 0),
                            Gradient.Stop(color: Color(red: 0.42, green: 0, blue: 1).opacity(0.66), location: 0.85),
                            ],
                            startPoint: UnitPoint(x: 0, y: 0.5),
                            endPoint: UnitPoint(x: 1, y: 0.5)
                            ))
                         // Розовая обводка вокруг трека
                )
                //.blendMode(.overlay)
                .opacity(0.8)
            
            // Help text
            Text("swipeToTurnOn")
                .font(.caption)
                .italic()
                .foregroundColor(Color.black)
                .offset(x: 30, y: 0)
                .opacity(Double(1 - ( (self.dragOffset.width*2)/self.trackSize.width )))
            
            // Thumb
            ZStack {
                Capsule()
                    .frame(width: thumbSize.width, height: thumbSize.height)
                    .gradientForeground(
                                colors: [
                                    Color(red: 0, green: 1, blue: 0.76),
                                    Color(red: 0.42, green: 0, blue: 1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                    )
                
                Image(systemName: "arrow.right")
                    .foregroundColor(Color.white)
            }
            .offset(x: getDragOffsetX(), y: 0)
            .animation(Animation.spring(response: 0.3, dampingFraction: 0.8))
            .gesture(
                DragGesture()
                    .onChanged({ value in self.handleDragChanged(value) })
                    .onEnded({ _ in self.handleDragEnded() })
            )
        }
    }
    
    // MARK: - Haptic feedback
    private func indicateCanLiftFinger() -> Void {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func indicateSwipeWasSuccessful() -> Void {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    
    // MARK: - Helpers
    private func getDragOffsetX() -> CGFloat {
        // should not be able to drag outside of the track area
        
        let clampedDragOffsetX = dragOffset.width.clamp(lower: 0, trackSize.width - thumbSize.width)
        
        return -( trackSize.width/2 - thumbSize.width/2 - (clampedDragOffsetX))
    }
    
    // MARK: - Gesture Handlers
    private func handleDragChanged(_ value:DragGesture.Value) -> Void {
        self.dragOffset = value.translation
        
        let dragWidth = value.translation.width
        let targetDragWidth = self.trackSize.width - (self.thumbSize.width*2)
        let wasInitiated = dragWidth > 2
        let didReachTarget = dragWidth > targetDragWidth
        
        self.thumbSize = wasInitiated ? CGSize.activeThumbSize : CGSize.inactiveThumbSize
        
        if didReachTarget {
            // only trigger once!
            if !self.isEnough {
                self.indicateCanLiftFinger()
            }
            self.isEnough = true
        }
        else {
            self.isEnough = false
        }
    }
    
    private func handleDragEnded() -> Void {
        // If enough was dragged, complete swipe
        if self.isEnough {
            self.dragOffset = CGSize(width: self.trackSize.width - self.thumbSize.width, height: 0)
            
            // the outside world should be able to know
            if nil != self.actionSuccess {
                self.indicateSwipeWasSuccessful()
                
                // wait and give enough time for animation to finish
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.actionSuccess!()
                }
            }
            
        }
        else {
            self.dragOffset = .zero
            self.thumbSize = CGSize.inactiveThumbSize
        }
        
        
        
    }
    
}

//#Preview {
//    SwipeToUnlockView()
//}
