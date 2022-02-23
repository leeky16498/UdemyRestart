//
//  ContentView.swift
//  Restart
//
//  Created by Kyungyun Lee on 09/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = true
    //앱스토리지는 프로퍼티 래퍼, 그리고 '유저 키' 옆에는 프로퍼티 값
    
    var body: some View {
        ZStack {
            if isOnboardingViewActive {
                OnboardingView()
            } else {
                HomeView()
            }
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}
