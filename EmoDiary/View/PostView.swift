//
//  File.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/22.
//

import UIKit

class PostView : UIView {
    
    var dataArray: [PostModel] = [] // 데이터 모델 - 추후 사용
    
    // 작성 날짜 라벨
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 📅 캘린더 아이콘 - 날짜 선택
    let calendar: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "calendar_icon")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 해당 날짜 표시
    let dateView: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 날짜 스택뷰
    lazy var sview1 : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateLabel, calendar, dateView])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .leading
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // 작성란 라벨
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 일기"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // ✏️작성란
    let textViewPlaceHolder = "오늘의 감정, 있었던 일들을 간단하게 남겨보세요."
    
    lazy var review: UITextView = {
        let tv = UITextView()
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15) // 테두리-텍스트 간 여백
        tv.text = textViewPlaceHolder
        tv.textColor = .gray
        tv.font = .systemFont(ofSize: 17)
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.cornerRadius = 10 // 둥근 모서리
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    // 감정 라벨
    let emoLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 감정"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 🙂 기본 이모지 아이콘 - 감정 선택
    let emoji: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "smile_icon")
        img.contentMode = .scaleAspectFit
        // img.layer.opacity = 0.5
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 감정 스택뷰
    lazy var sview3 : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [emoLabel, emoji])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .leading
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // 사진 라벨
    let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 사진"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 📸 카메라 아이콘 - 사진 선택
    let camera: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "camera_icon")
        img.contentMode = .scaleAspectFit
        // img.layer.opacity = 0.5
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 사진 스택뷰
    lazy var sview4 : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [photoLabel, camera])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .leading
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // 🖼️ 사진
    let photo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "default_photo.png")
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 5
        img.contentMode = .scaleAspectFill // 뷰크기 내에 맞춤 (잘림)
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 사진 그림자
    let shadow: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // ✖️취소/삭제 버튼
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("취소", for: .normal)
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // ✅작성/수정 완료 버튼
    let summitBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("작성 완료", for: .normal)
        btn.backgroundColor = UIColor(named: "Dark")
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 버튼 스택뷰
    lazy var sview5 : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cancelBtn, summitBtn])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // 전체 스택뷰
    lazy var stackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sview1, reviewLabel, review, sview3, sview4, shadow, sview5])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.alignment = .leading
        sv.spacing = 25
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        configureUI()
    }
    
    func configureUI() {
        
        // 만든 뷰/아이템 등록
        addSubview(stackView)
        shadow.addSubview(photo)

        // 해당 뷰의 크기/위치 설정
        NSLayoutConstraint.activate([
            
            // 전체 (스택) 뷰
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant:  -25),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            // 달력 아이콘
            calendar.widthAnchor.constraint(equalToConstant: 22),
            calendar.heightAnchor.constraint(equalToConstant: 22),
            
            // 일기 작성란
            review.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 15),
            review.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            review.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            review.heightAnchor.constraint(equalToConstant: 150),
            
            // 이모지 아이콘
            emoji.widthAnchor.constraint(equalToConstant: 22),
            emoji.heightAnchor.constraint(equalToConstant: 22),
            
            // 카메라 아이콘
            camera.widthAnchor.constraint(equalToConstant: 22),
            camera.heightAnchor.constraint(equalToConstant: 22),
            
            // 사진 그림자 뷰
            shadow.topAnchor.constraint(equalTo: sview4.bottomAnchor, constant: 15),
            shadow.bottomAnchor.constraint(equalTo: sview5.topAnchor, constant: -30),
            shadow.heightAnchor.constraint(lessThanOrEqualToConstant: 250),
            // 사진 이미지
            photo.topAnchor.constraint(equalTo: shadow.topAnchor),
            photo.bottomAnchor.constraint(equalTo: shadow.bottomAnchor),
            photo.leadingAnchor.constraint(equalTo: shadow.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: shadow.trailingAnchor),
            
            // 버튼
            sview5.heightAnchor.constraint(equalToConstant: 50),
            sview5.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
