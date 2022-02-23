//
//  CircieGroupView.swift
//  Restart
//
//  Created by Kyungyun Lee on 09/02/2022.
//

import SwiftUI

struct CircieGroupView: View {
    
    // MARK : -property
    @State var shapeColor : Color
    @State var shapeOpacity : Double
    @State var isAnimating : Bool = false
    ///우리는 이제 이 친구들을 모두 조절하면서 만질 수 있다.
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(shapeColor.opacity(shapeOpacity), lineWidth: 40)
                .frame(width: 260, height: 260, alignment: .center)
            Circle()
                .stroke(shapeColor.opacity(shapeOpacity), lineWidth: 80)
                .frame(width: 260, height: 260, alignment: .center)
        }
        .blur(radius: isAnimating ? 0 : 10)
        .opacity(isAnimating ? 1 : 0)
        .scaleEffect(isAnimating ? 1 : 0.5)
        .animation(.easeOut(duration: 1), value: isAnimating)
        .onAppear(perform: {
            isAnimating = true
        })
    }
}
