//
//  HomeView.swift
//  Restart
//
//  Created by Kyungyun Lee on 09/02/2022.
//

import SwiftUI

struct HomeView: View {
    
    // MARK : -property
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = false
    @State var isAnimating : Bool = false
    
    // MARK : -body
    var body: some View {
       
        VStack(spacing: 20){
            
            Spacer()
            
            ZStack {
                CircieGroupView(shapeColor: .gray, shapeOpacity: 0.1)
                
                Image("character-2")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .offset(y: isAnimating ? 35 : -35)
                    .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
            }
            
            Text("The time that leads to mastery is dependent on the intensity of our focus")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    playSound(sound: "success", type: "m4a")
                    isOnboardingViewActive = true
                } // 기본적인 슬라이드 변경 애니메이션을 제공한다.
            }, label: {
                Label("Restart", systemImage: "person.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 140, height: 40, alignment: .center)
                    .background(Color("ColorBlue"))
                    .clipShape(Capsule())
            })
            Spacer()
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                isAnimating = true // 코드의 실행 시간을 지정할 수 있다.
            })
        })
        .preferredColorScheme(.dark)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
