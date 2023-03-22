//
//  PostController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/22.
//

import UIKit

class PostController : UIViewController{
    
    let postView = PostView()   // 연결할 View 이름
    
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
    }
    
    @objc private func didTapTextView(_ sender: Any) {
        view.endEditing(true)
    }
    
    override func loadView() {
        view = postView // 실행 시 해당 뷰로 연결
    }
    
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
