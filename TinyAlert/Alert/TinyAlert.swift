//
//  TinyAlert.swift
//  TinyAlert
//
//  Created by jingcao on 2021/8/31.
//

import SwiftUI

// 调整返回view的逻辑
struct TinyAlert: ViewModifier {
    
    @Binding var isPresenting: Bool
    @State var toastCount = 0

    func body(content: Content) -> some View {
        
        content.overlay(
            tinyAlertView(isPresenting: $isPresenting)
                .animation(.easeInOut, value: isPresenting)
        )
        .onChange(of: isPresenting, perform: { value in
            if value == true {
                toastCount += 1
            }
        })
        
    }
    
}

// 弹窗view
struct tinyAlertView: View {
    
    @State private var Opacity = 0.8
    @Binding var isPresenting: Bool
    var duration: Double = 2

    var body: some View {
        if isPresenting {
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.4), lineWidth: 2)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
                Text("Alert")
            }
            .opacity(Opacity)
            .transition(AnyTransition.slide)
            .onAppear(perform: {
                if isPresenting {
                    onAppearAction()
                }
            })
            .onTapGesture {
                
            }
        }
        
    }
    
    func onAppearAction(){
        print("start dimiss")
        if duration > 0{
            let task = DispatchWorkItem {
                isPresenting = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
        }
    }
    
}

// 测试view
struct AlertView: View {
    
    @State var isPresenting = false
    
    var body: some View {
        VStack{
            Spacer()
            Button(action:{
                isPresenting = true
            }){
                Text("tap")
                    .foregroundColor(.black)
            }
        }
        .tinyAlert(isPresenting: $isPresenting)
    }
}

// 最终调用的方法：tinyAlert()
extension View {
    func tinyAlert(isPresenting: Binding<Bool>) -> some View {
        modifier(TinyAlert(isPresenting: isPresenting))
    }
}

struct AlertView_Previews: PreviewProvider {

    static var previews: some View {
        AlertView()
    }
}
