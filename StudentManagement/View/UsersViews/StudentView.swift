//
//  StudentView.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 10.12.2024.
//

import SwiftUI

struct StudentView: View {
    
    var userName: String
    var onDismiss: () -> Void
    @ObservedObject var viewModel: ViewModels

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("StudentImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 88, height: 88)
                    .cornerRadius(10)

                Text("Öğrenci Sayfası")
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

                                if !lesson.isMandatory {
                                    Button(action: {
                                        viewModel.updateLessonMandatory(userName: userName, lesson: lesson.lesson, isMandatory: true) { success in
                                            if success {
                                                viewModel.fetchLessonsStudents(for: userName)
                                                print("\(lesson.lesson) dersi zorunlu hale getirildi.")
                                            } else {
                                                print("Ders güncellenemedi.")
                                            }
                                        }
                                    }) {
                                        Text("Seç")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.green)
                                            .cornerRadius(8)
                                            .shadow(radius: 5)
                                    }
                                    .padding(.top, 5)
                                } else {
                                    Text("Seçildi")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                        .italic()
                                }
                            }
                            .padding(.vertical, 5)
                            .background(Color.clear)
                            .cornerRadius(8)
                            .listRowBackground(Color.white)
                        }

                        .listStyle(PlainListStyle())
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
            viewModel.fetchLessonsStudents(for: userName)
        }
    }
}

#Preview {
    StudentView(userName: "AhmetYilmaz", onDismiss: {
        print("Çıkış yapıldı")
    }, viewModel: ViewModels())
}
