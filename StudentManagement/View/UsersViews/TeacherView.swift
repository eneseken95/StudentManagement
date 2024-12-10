//
//  TeacherView.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 10.12.2024.
//

import SwiftUI

struct TeacherView: View {
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Teacher View")
                    .font(.largeTitle)
                    .foregroundColor(.green)

                Button("Çıkış yap") {
                    onDismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .navigationBarBackButtonHidden(true)
        .statusBarHidden()
    }
}

#Preview {
    TeacherView(onDismiss: {
        print("Çıkış yapıldı")
    })
}
