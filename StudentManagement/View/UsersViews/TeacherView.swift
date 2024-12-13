//
//  TeacherView.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 10.12.2024.
//

import SwiftUI

struct TeacherView: View {
    
    var userName: String
    var onDismiss: () -> Void
    @ObservedObject var viewModel: ViewModels

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Text("Teacher View")
                    .font(.largeTitle)
                    .foregroundColor(.green)

                Text("Welcome, \(userName)!")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()

                VStack {
                    if let lessons = viewModel.lessonsData?.data, !lessons.isEmpty {
                        List(lessons) { lesson in
                            VStack(alignment: .leading) {
                                Text(lesson.lesson)
                                    .font(.headline)
                                Text(lesson.isMandatory ? "Zorunlu Ders" : "Seçmeli Ders")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        Text("Ders bulunamadı")
                            .foregroundColor(.white)
                    }
                }
                .padding()

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
        .statusBarHidden(true)
        .onAppear {
            viewModel.fetchLessonsTeacher(for: userName)
        }
    }
}

#Preview {
    TeacherView(userName: "MehmetKara", onDismiss: {
        print("Çıkış yapıldı")
    }, viewModel: ViewModels())
}
