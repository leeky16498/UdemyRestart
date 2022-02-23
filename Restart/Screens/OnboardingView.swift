//
//  OnboardingView.swift
//  Restart
//
//  Created by Kyungyun Lee on 09/02/2022.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK : -property
    
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = true
    
    @State var buttonWidth : Double = UIScreen.main.bounds.width - 80
    @State var buttonOffset : CGFloat = 0
    @State var isAnimating : Bool = false // 애니메이션을 위한 스위치같은 것이다.
    @State var imageOffset : CGSize = .zero
    @State var indicatorOpacity : Double = 1.0
    @State var textTitle : String = "Share."
    
    let hapticFeedBack = UINotificationFeedbackGenerator()
    
    // MARK : -body
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
               
                // MARK : -header
                
                Spacer()
                
                VStack(spacing: 0){
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .id(textTitle)
                    
                    Text("""
                     It's not how much we give but
                    how much love we put into giving.
                    """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                .opacity(isAnimating ? 1 : 0) // 슬라이딩 다운 애니메이션을 위한 것
                .offset(y : isAnimating ? 0 : -40) // 무빙 애니메이션 >> 슬라이드 애니메이션을 위한 것.
                .animation(.easeOut(duration: 1), value: isAnimating) // 애니메이션 맥이는 법, 에니메이션 스위치를 통해서 키고 끈다.
                
                // MARK : -center
                
                ZStack{
                    
                    CircieGroupView(shapeColor: .white, shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 0.5), value: imageOffset)
                    //별도 뷰로 소환해서 변수를 통해서 자유롭게 만지는 것도 가능합니다.
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20))) // 앵글파라미터와 앵커 파라미터가 있지만 여기에서는 앵글 파라미터만 줘서 얼마나 돌지를 지정해줬다.
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150  { // drag 한계 {
                                        //abs는 절대값을 의미한다.
                                        imageOffset = gesture.translation
                                        
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 0
                                            textTitle = "Give."
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    imageOffset = .zero
                                    
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1
                                        textTitle = "Share."
                                        
                                    }
                                }
                        )
                        .animation(Animation.easeOut(duration: 0.5), value: imageOffset)
                }
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y : 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                    //애니메이션에 딜레이 모디파이어를 선언하면 2초 되에 에니메이션을 보여줄 수 있다.
                        .opacity(indicatorOpacity)
                    ,alignment: .bottom
                )
                
                // MARK : -footer
                
                ZStack{
                    
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    //1. background
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width : buttonOffset + 80)
                        Spacer()
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(Animation.easeOut(duration: 0.4)) {
                                        if buttonOffset > buttonWidth / 2 {
                                            hapticFeedBack.notificationOccurred(.success)
                                            playSound(sound: "chimeup", type: "mp3")
                                            buttonOffset = buttonWidth - 80
                                            isOnboardingViewActive = false
                                        } else {
                                            hapticFeedBack.notificationOccurred(.warning)
                                            buttonOffset = 0
                                        }
                                    }
                                }
                        )
                        Spacer()
                    }
                
                }
                .frame(width : buttonWidth, height: 80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y : isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            }
        }
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark) // 위에 스테이터스 바 색이 하얀색이면 다크모드, 검정이면 라이트모드이다.
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
