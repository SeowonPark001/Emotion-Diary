//
//  PostController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/22.
//

import UIKit

class PostController : UIViewController{
    
    let postView = PostView()   // 연결할 View 이름
    
    // 감정 배열
    let emotionArray :[String] = ["Neutral", "Happy", "Touched", "Sad", "Hopeless", "Angry"]
    let emojiArray :[String] = ["😐", "😆", "🥹", "😢", "😱", "😡"]
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네이게이션 바
        self.navigationItem.title = "감정 일기 작성하기"
        let navi = UINavigationBarAppearance()
        navi.backgroundColor = UIColor(named: "Medium")
        let naviCtrl = navigationController?.navigationBar
        naviCtrl!.standardAppearance = navi
        naviCtrl!.scrollEdgeAppearance = navi
        
        configureDate() // 오늘 날짜 출력
        
        // 작성란 place holder 구현
        postView.review.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
        view.addGestureRecognizer(tapGesture)
        
        // 달력 아이콘 누르기
        postView.calendar.tag = 1
        self.postView.calendar.isUserInteractionEnabled = true
        self.postView.calendar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imgViewTapped)))
        
        // 이모지 누르기
        postView.emoji.tag = 2
        self.postView.emoji.isUserInteractionEnabled = true
        self.postView.emoji.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imgViewTapped)))
        
        // 카메라 아이콘 누르기
        postView.camera.tag = 3
        self.postView.camera.isUserInteractionEnabled = true
        self.postView.camera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imgViewTapped)))
        
        // 사진 그림 누르기 = 카메라 아이콘과 같은 기능
        postView.photo.tag = 4
        self.postView.photo.isUserInteractionEnabled = true
        self.postView.photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imgViewTapped)))
    
        
        picker.delegate = self
    }
    
    override func loadView() {
        view = postView // 실행 시 해당 뷰로 연결
    }
    
    // 이미지 뷰 눌렀을 때
    @objc func imgViewTapped(_ sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        
        switch tag {
        case 1: // 달력 아이콘 => 달력 팝업창 출력
            print("달력 아이콘 클릭됨 (\(tag))")
            
        case 2: // 이모지 => 액션시트 출력
            print("이모지 클릭됨 (\(tag))")
            showEmojiSheet(sender)
            
        case 3,4: // 카메라&사진 => 카메라/갤러리 연결
            print("카메라/사진 클릭됨 (\(tag))")
            chooseCamOrLib(sender)
            
        default: // 그외
            print("다른 뷰 클릭됨 (\(tag))")
        }
    }
    
    // 텍스트뷰 눌렀을 때
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }
    
    // 해당 날짜 출력
    func configureDate(){ // PostView date label에 값을 할당
        postView.dateView.text = getTodayDate()
    }
    
    func getTodayDate() -> String { // Date -> String
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        return dateFormatter.string(from: now)
    }
    
    // 감정 액션 시트 출력
    func showEmojiSheet(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "오늘의 감정", message: nil, preferredStyle: .actionSheet)
        
        for i in 0...5 { // 6가지 감정 넣기
            actionSheet.addAction(UIAlertAction(title: emojiArray[i], style: .default, handler: {(ACTION:UIAlertAction) in
                print("\(self.emotionArray[i]) 감정 선택")
                self.postView.emoji.image = UIImage(named: self.emotionArray[i]) // 해당 감정 이모티콘 출력
            })) // style: .destructive => 빨간색 글씨
        }
        // 취소 버튼
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // 카메라/사진 액션 시트 출력
    func chooseCamOrLib(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "사진 불러오기", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "사진 앨범", style: .default, handler: {(ACTION:UIAlertAction) in
            print("앨범 선택")
            self.openLibrary()
        }))
            
        actionSheet.addAction(UIAlertAction(title: "카메라", style: .default, handler: {(ACTION:UIAlertAction) in
            print("카메라 선택")
            self.openCamera()
        }))
        
        // 취소 버튼
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }

}

// Delegate 패턴: text view place holder
extension PostController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == postView.textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = postView.textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}


// Delegate 패턴: 사진앨범/카메라 열기
extension PostController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // 사진 앨범 열기
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    // 카메라 열기
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postView.photo.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}
