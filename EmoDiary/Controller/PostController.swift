//
//  PostController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/22.
//

import UIKit
import RealmSwift

class PostController : UIViewController{
    
    var realm: Realm!
    var load: Results<DiaryData>?
    var realmData: DiaryData?
    
    var delegate: UpdateDelegate?
    var recordDate: Date = Date()

    let postView = PostView()
    let imgPicker = UIImagePickerController()

    let emotionArray :[String] = ["Neutral", "Happy", "Touched", "Sad", "Hopeless", "Angry"]
    let emojiArray :[String] = ["😐", "😆", "🥹", "😢", "😱", "😡"]
    
    //MARK: - Load View
    
    override func loadView() {
        view = postView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTarget()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        postView.datePicker.date = recordDate
        loadData()  // 화면 나타날 때마다 데이터 불러오기
    }
    
    func loadData() {
        realm = try! Realm()
        load = realm?.objects(DiaryData.self)   // DiaryData 데이터들을 가져옴
        postView.diary = realmData              // DiaryData형 => View로 전달
        print("Post - Load Data: \(load)")
    }
    
    //MARK: - Set Up UI
    func setNavigationBar() {
        title = "감정 일기 작성"
        
        let navi = UINavigationBarAppearance()
        navi.configureWithOpaqueBackground()
        navi.backgroundColor = UIColor(named: "Bright")
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
        // 텍스트뷰(작성란) 터치
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTextView(_:)))
        view.addGestureRecognizer(tapGesture)
        
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
        
        // 하단 버튼 누르기
        postView.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        postView.summitBtn.addTarget(self, action: #selector(summitBtnTapped), for: .touchUpInside)
    }
    
    func setDelegate() {
        postView.review.delegate = self
        imgPicker.delegate = self
    }
    
    // 이미지뷰(아이콘) 눌렀을 때
    @objc func imgViewTapped(_ sender: UITapGestureRecognizer) {
        let tag = sender.view!.tag
        
        switch tag {
        
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
    
    // Date형 날짜 -> String으로 변환
    func configureDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
         
        return dateFormatter.string(from: date)
    }
    
    
    // 감정 액션 시트 출력
    func showEmojiSheet(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIAlertController(title: "오늘의 감정", message: nil, preferredStyle: .actionSheet)
        
        for i in 0...5 { // 6가지 감정 넣기
            actionSheet.addAction(UIAlertAction(title: emojiArray[i], style: .default, handler: {(ACTION:UIAlertAction) in
                print("\(self.emotionArray[i]) 감정 선택")
                self.postView.emoji.image = UIImage(named: self.emotionArray[i]) // 해당 감정 이모티콘 출력
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
    
    // 작성란 Place Holder 구현
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }
    
    // 글자 제한수 업데이트
    private func updateCountLabel(characterCount: Int) {
        postView.textCounter.text = "\(characterCount)/150"
    }
    
    
    // 작성 취소/삭제 버튼 눌렀을 때
    @objc func cancelBtnTapped(){
        print("취소/삭제 버튼 클릭")
        
        // Alert 팝업창
        var alert = UIAlertController(title: "일기 삭제", message: "작성한 일기를 삭제하시겠습니까?", preferredStyle: .alert)
        
        // 일기 작성 후 새로 저장하는 경우
        if postView.diary == nil {
            alert = UIAlertController(title: "일기 작성 취소", message: "일기 작성을 취소하시겠습니까?", preferredStyle: .alert)
        }
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("확인버튼이 눌렸습니다.")
            
            if self.postView.diary == nil { // 전 화면으로 돌아가기 (=> Main)
                self.navigationController?.popViewController(animated: true)
            }
            else { // 데이터가 존재하는 경우
                // 데이터 삭제 (Delete)
                let delete = self.realmData
                
                try! self.realm.write {
                    print("[\(delete?.date)] 일기 삭제 -------------")
                    self.realm.delete(delete!)
                }
                print("일기 삭제 완료")
                // 전 화면으로 돌아가기 (=> List)
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소버튼이 눌렸습니다.")
        }
        alert.addAction(success)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 작성 완료/수정 버튼 눌렀을 때
    @objc func summitBtnTapped() {
        print("작성 완료/수정 버튼 클릭")
        
        // Alert 팝업창
        var alert = UIAlertController(title: "일기 수정 확인", message: "작성한 일기를 수정하시겠습니까?", preferredStyle: .alert)
        
        // 일기 작성 후 새로 저장하는 경우
        if postView.diary == nil {
            alert = UIAlertController(title: "일기 작성 확인", message: "작성한 일기를 저장하시겠습니까?", preferredStyle: .alert)
        }
        
        let success = UIAlertAction(title: "확인", style: .default) { action in
            print("확인버튼이 눌렸습니다.")
            
            // 작성란이 빈칸인 경우 혹은 감정 이모티콘을 선택하지 않은 경우
            if self.postView.review.text == "오늘의 감정, 있었던 일들을 간단하게 남겨보세요." || self.postView.emoji.image == UIImage(named: "smile_icon") {
                let alert = UIAlertController(title: "감정 일기를 다 채워주세요!", message: "", preferredStyle: .alert)
                let check = UIAlertAction(title: "확인", style: .default) { action in
                    print("확인버튼이 눌렸습니다.")
                }
                alert.addAction(check)
                self.present(alert, animated: true, completion: nil)
            }
            else { // 정상적으로 작성/수정한 경우 => Realm Data Create/Update
                
                // 1. 데이터 작성/추가 (Create)
                if self.postView.diary == nil {
                    let data = DiaryData()
                    data.date = self.configureDate(date: self.postView.datePicker.date)
                    data.review = self.postView.review.text
                    data.emotion = {
                        var result = ""
                        for i in 0...5 {
                            if self.postView.emoji.image == UIImage(named: self.emotionArray[i]) {
                                result = String(self.emotionArray[i])
                            }
                            else if self.postView.emoji.image == UIImage(named: "smile_icon") {
                                result = String(self.emotionArray[0])
                            }
                        }
                        return result
                    }()
                    if self.postView.photo.image != UIImage(named: "default_photo") {
                        data.photo = self.postView.photo.image?.jpegData(compressionQuality: 1)
                    }
                    dump("데이터 상세 정보: \n\(data)")
                    
                    // 같은 날짜의 기록이 없는 경우
                    if (self.load?.filter("date == '\(data.date)'").count)! == 0 {
                        // 저장하기
                        try! self.realm?.write {
                            self.realm?.add(data)
                            print("Realm 데이터 추가 완료!!")
                        }
                    }
                    else {
                        var alert = UIAlertController(title: "⚠️\n일기 확인\n", message: "이미 오늘 작성한 일기가 있습니다.", preferredStyle: .alert)
                        let check = UIAlertAction(title: "확인", style: .default) { [self] action in
                            print("확인버튼이 눌렸습니다.")
                        }
                        alert.addAction(check)
                        self.present(alert, animated: true, completion: nil)
                    }

//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy.MM.dd"
//                    dateFormatter.date(from: data.date)!
                    self.delegate?.updateDiary(date: self.postView.datePicker.date)
                    
                    // 전 화면으로 돌아가기 (=> Main)
                    self.navigationController?.popViewController(animated: true)
                }
                
                else { // 이미 데이터가 있는 경우
                    // 2. 데이터 수정 (Updat)
                    let update = self.realmData
                    
                    try! self.realm.write {
                        update!.date = self.configureDate(date: self.postView.datePicker.date)
                        
                        update!.review = self.postView.review.text
                        update!.emotion = {
                            var result = ""
                            for i in 0...5 {
                                if self.postView.emoji.image == UIImage(named: self.emotionArray[i]) {
                                    result = String(self.emotionArray[i])
                                }
                                else if self.postView.emoji.image == UIImage(named: "smile_icon") {
                                    result = String(self.emotionArray[0])
                                }
                            }
                            return result
                        }()
                        if self.postView.photo.image != UIImage(named: "default_photo") {
                            update!.photo = self.postView.photo.image?.jpegData(compressionQuality: 1)
                        } else {
                            update!.photo = nil
                        }
                    }
                    print("[\(update?.date)] 일기 수정 완료 ---------------")
                    dump("데이터 수정 정보: \n\(update)")
                    
                    
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyy.MM.dd"
//                    dateFormatter.date(from: update!.date)!
                    
                    self.delegate?.updateDiary(date: self.postView.datePicker.date)
                    
                    // 전 화면으로 돌아가기 (=> List)
                    self.navigationController?.popViewController(animated: true)
                }
            }
     
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소버튼이 눌렸습니다.")
        }
        alert.addAction(success)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
            updateCountLabel(characterCount: 0)
        }
    }
    // 글자수 제한 표시
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= 150 else { return false }
        updateCountLabel(characterCount: characterCount)

        return true
    }
}
// 글자수 제한 글씨체 색 - 작성란 place holder
extension UILabel {
    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
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
