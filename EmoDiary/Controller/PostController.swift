//
//  PostController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/22.
//

import UIKit

class PostController : BaseController{
    
    let postView = PostView() // 연결할 View 이름
    
    let imgPicker = UIImagePickerController()
    
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTarget()
        setDelegate()
        
        configureDate()
    }
    
    func setNavigationBar() {
        title = "감정 일기 작성"
        
        let navi = UINavigationBarAppearance()
        navi.configureWithOpaqueBackground()
        navi.backgroundColor = UIColor(named: "Medium")
        navi.titleTextAttributes = [.foregroundColor: UIColor.white] // 글씨색

        let naviCtrl = navigationController?.navigationBar
        naviCtrl?.standardAppearance = navi
        naviCtrl?.scrollEdgeAppearance = navi
        
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.scrollEdgeAppearance = navi
        navigationItem.standardAppearance = navi
        navigationItem.compactAppearance = navi
    }
    
    func setTarget() {
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
        
        // 텍스트뷰(작성란) 터치
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setDelegate() {
        postView.review.delegate = self
        imgPicker.delegate = self
    }
    
    // 해당 날짜 표시
    func configureDate(){
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        let result = dateFormatter.string(from: now)
        
        postView.dateView.text = result
    }
    
    // 작성란 Place Holder 구현
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }

    
    // 이미지뷰(아이콘) 눌렀을 때
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
    
    // 감정 액션 시트 출력
    func showEmojiSheet(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "오늘의 감정", message: nil, preferredStyle: .actionSheet)
        
        for i in 0...5 { // 6가지 감정 넣기
            actionSheet.addAction(UIAlertAction(title: emojiArray[i], style: .default, handler: {(ACTION:UIAlertAction) in
                print("\(emotionArray[i]) 감정 선택")
                self.postView.emoji.image = UIImage(named: emotionArray[i]) // 해당 감정 이모티콘 출력
            }))
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

// Delegate 패턴: Text View Place Holder
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
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: false, completion: nil)
    }
    // 카메라 열기
    func openCamera() {
        imgPicker.sourceType = .camera
        present(imgPicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            postView.photo.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}
