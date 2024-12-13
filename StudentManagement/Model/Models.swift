//
//  Models.swift
//  StudentManagement
//
//  Created by Enes Eken 2 on 9.12.2024.
//

import Foundation

enum Role: String, Decodable {
    case student
    case teacher
    case admin
}

struct LoginModel: Decodable, Equatable {
    let id: Int
    let userName: String
    let password: String
    let role: Role
}

struct LoginResponse: Decodable {
    let error: Bool
    let message: String
    let data: LoginModel
}

struct Lesson: Identifiable, Codable {
    var id: UUID = UUID()
    var lesson: String
    var isMandatory: Bool

    enum CodingKeys: String, CodingKey {
        case lesson
        case isMandatory
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lesson = try container.decode(String.self, forKey: .lesson)

        let isMandatoryInt = try container.decode(Int.self, forKey: .isMandatory)
        isMandatory = isMandatoryInt == 1
    }
}

struct LessonsResponse: Codable {
    var error: Bool
    var message: String
    var data: [Lesson]
}
