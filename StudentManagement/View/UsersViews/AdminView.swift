//
//  AdminView.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 10.12.2024.
//

import SwiftUI

struct AdminView: View {
    
    var userName: String
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Image("TeacherImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .cornerRadius(10)

                Text("Yönetici Sayfası")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                Text("Hoşgeldin, \(userName)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)

                Button(action: {
                    withAnimation {
                        onDismiss()
                    }
                }) {
                    Text("Çıkış Yap")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 150, height: 55)
                        .background(Color.orange)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 20)
                }

                Spacer()
                Spacer()
            }
            .padding(.top, 100)
        }
        .navigationBarBackButtonHidden(true)
        .statusBarHidden(true)
    }
}

#Preview {
    AdminView(userName: "AyseDemir", onDismiss: {
        print("Çıkış yapıldı")
    })
}
