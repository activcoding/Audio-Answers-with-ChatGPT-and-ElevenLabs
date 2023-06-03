//
//  ProgressView.swift
//  ChatGTP-Audio
//
//  Created by Tommy Ludwig on 03.06.23.
//

import SwiftUI

struct ProgressView: View {
    var progress: Double
    var body: some View {
        MilestoneProgressView(progress: progress)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(progress: 0.0)
    }
}

struct MilestoneProgressView: View {
    var progress: CGFloat
    private var count: Float = 3
    private var radius: CGFloat = 10
    private var lineWidth: CGFloat = 8
    private var color = Color.green
    
    init(progress: CGFloat) {
        self.progress = progress
    }
    
    var body: some View {
        GeometryReader { bounds in
            VStack(spacing: 70) {
                MilestoneShape(count: Int(count), radius: radius)
                    .stroke(lineWidth: lineWidth)
                    .foregroundColor(color.opacity(0.3))
                    .padding(.horizontal, lineWidth/2)
                    .overlay {
                        MilestoneShape(count: Int(count), radius: radius)
                            .stroke(lineWidth: lineWidth)
                            .foregroundColor(color)
                            .padding(.horizontal, lineWidth/2)
                            .mask(
                                HStack {
                                    Rectangle()
                                    
                                        .frame(width: bounds.size.width * progress, alignment: .leading)
                                    Spacer(minLength: 0)
                                }
                            )
                    }
                    .padding(.horizontal, lineWidth/2)
            }
        }
    }
    
    struct MilestoneShape: Shape {
        let count: Int
        let radius: CGFloat
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: 0, y: rect.midY))
            
            var maxX: CGFloat = 0
            let remainingSpace: CGFloat = rect.width - (CGFloat(count)*radius*2)
            let lineLength: CGFloat = remainingSpace / CGFloat(count - 1)
            
            for i in 1...count {
                path.addEllipse(in: CGRect(origin: CGPoint(x: maxX, y: rect.midY - radius), size: CGSize(width: radius*2, height: radius*2)))
                maxX += radius*2
                path.move(to: CGPoint(x: maxX, y: rect.midY))
                if i != count {
                    maxX += lineLength
                    path.addLine(to: CGPoint(x: maxX, y: rect.midY))
                }
            }
            
            return path
        }
    }
}

struct LoadingProgressView: View {
    var progress: CGFloat
    
    @State var rotationAngle: Double = 0
    var fillColor: Color = .red
    var count: Int = 20
    
    var body: some View {
        GeometryReader { bounds in
            ZStack {
                ForEach(0..<count) { i in
                    Circle()
                        .fill(fillColor.opacity(0.2))
                        .frame(width: getDotSize(i), height: getDotSize(i), alignment: .center)
                        .offset(x: (bounds.size.width / 2) - 10)
                        .rotationEffect(.degrees(.pi * 2 * Double(i * 3)))
                }
                
                
                ForEach(0..<count) { i in
                    Circle()
                        .fill(fillColor)
                        .frame(width: getDotSize(i), height: getDotSize(i), alignment: .center)
                        .offset(x: (bounds.size.width / 2) - 10)
                        .rotationEffect(.degrees(.pi * 2 * Double(i * 3)))
                        .opacity(CGFloat(i) < CGFloat(count) * progress ? 1 : 0)
                }
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: .center)
            .rotationEffect(.degrees(-90))
        }
    }
    
    private func getDotSize(_ index: Int) -> CGFloat {
        CGFloat(index)
    }
}
