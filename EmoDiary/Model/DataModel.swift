//
//  DataModel.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/20.
//

import UIKit

struct PostModel {
    var date: Date          // 작성 날짜
    var review: String      // 일기 내용
    var emotion: Int        // 감정 (정수로 선택)
    var photo: UIImage?     // 사진 (없을 수도)
}

// 전체 페이지에서 사용하도록 전역변수로 선언
let emotionArray :[String] = ["Neutral", "Happy", "Touched", "Sad", "Hopeless", "Angry"]
let emojiArray :[String] = ["😐", "😆", "🥹", "😢", "😱", "😡"]
