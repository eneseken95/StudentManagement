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
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("TeacherImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 88, height: 88)
                    .cornerRadius(10)

                Text("Öğretmen Sayfası")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)

                Text("Hoşgeldin, \(userName)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                VStack {
                    if let lessons = viewModel.lessonsData?.data, !lessons.isEmpty {
                        List(lessons) { lesson in
                            VStack(alignment: .leading) {
                                Text(lesson.lesson)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text(lesson.isMandatory ? "Zorunlu Ders" : "Seçmeli Ders")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                            .background(Color.clear)
                            .cornerRadius(8)
                            .listRowBackground(Color.white)
                        }
                        .listStyle(PlainListStyle())
                        .frame(height: 350)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                    } else {
                        Text("Ders bulunamadı")
                            .foregroundColor(.white)
                            .italic()
                    }
                }
                .padding()

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
                .padding(.top, 20)

                Spacer()
            }
            .padding(.top, 25)
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
