//
//  MainView.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/20.
//

import UIKit
import FSCalendar

class CalendarView :  UIView {
    // 🗓️ 달력
    lazy var calendar: FSCalendar = {
        let cv = FSCalendar()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // 해당 날짜 - 월
    let mmDate: UILabel = {
        let label = UILabel()
        label.text = "" //"3월" // data에서 불러오기
        label.font = .systemFont(ofSize: 12)
        label.backgroundColor = UIColor(named: "Background")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 해당 날짜 - 일
    let ddDate: UILabel = {
        let label = UILabel()
        label.text = "" //"12일" // data에서 불러오기
        label.font = .boldSystemFont(ofSize: 24)
        label.backgroundColor = UIColor(named: "Background")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 해당 날의 감정
    let emoji: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor(named: "Background")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 해당 날의 일기 박스
    let reviewBox: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 글자 제한 X
        label.layer.borderWidth = 0.8
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 10 // 둥근 모서리
        label.backgroundColor = UIColor(named: "Background")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 해당 날의 일기
    let review: UILabel = {
        let label = UILabel()
        label.text = "오늘의 일기를 남겨보세요."
        label.textColor = .gray
        label.numberOfLines = 0 // 글자 제한 X
        label.font = UIFont(name: "IM_Hyemin-Regular", size: 16) //.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(named: "Background")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 날짜 일 + 이모지 세로배열
    let stackView1: UIStackView = {
        let sv = UIStackView() // arranged error
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 5
        sv.backgroundColor = UIColor(named: "Background")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // 해당 일기 정보들 전부
    let stackView2: UIStackView = {
        let sv = UIStackView() // arranged error
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.alignment = .leading
        sv.spacing = 15
        sv.backgroundColor = UIColor(named: "Background")
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // 🖼️사진
    let photo: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // 뷰크기 내에 맞춤 (잘림)
        img.clipsToBounds = true // 넘치는 부분 잘라내기
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 사진 그림자
    let shadow3: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor // 테두리 색
        view.layer.borderWidth = 3 // 테두리 두께
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 4
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // 버튼 메뉴 (+)
    let menuBtn : UIButton  = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "Dark")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 그림자 - 메뉴 버튼
    let shadow: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 작성 버튼 🖊️
    let addBtn : UIButton  = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "Medium")
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 리스트 버튼 🗂️
    let listBtn : UIButton  = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "Medium")
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 숨겨져 있는 두 버튼 (작성, 목록) 스택
    lazy var stackView: UIStackView = {
       let st = UIStackView(arrangedSubviews: [addBtn, listBtn])
        st.axis = .vertical
        st.alignment = .center
        st.spacing = 10
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "Background")
        
        setupView()
        setUpConstraints()
    }
    
    func setupView() {
        addSubview(calendar)
    
        addSubview(stackView2)
        sendSubviewToBack(stackView2) // 가장 뒤로
        stackView2.addArrangedSubview(stackView1)
        
        stackView1.addArrangedSubview(mmDate)
        stackView1.addArrangedSubview(ddDate)
        stackView1.addArrangedSubview(emoji)
    
        stackView2.addArrangedSubview(reviewBox)
        reviewBox.addSubview(review)
        
        addSubview(shadow3)
        shadow3.addSubview(photo)
        
        addSubview(stackView)
        bringSubviewToFront(stackView) // 가장 앞으로
        addSubview(shadow)
        bringSubviewToFront(shadow) // 가장 앞으로
        shadow.addSubview(menuBtn)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            // 달력
            calendar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            calendar.heightAnchor.constraint(lessThanOrEqualToConstant: 470),
            
            // 일기 카드
            stackView2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stackView2.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 30),
            stackView2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            stackView2.bottomAnchor.constraint(equalTo: shadow3.topAnchor, constant: -5),
            stackView2.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            emoji.widthAnchor.constraint(equalToConstant: 35),
            emoji.heightAnchor.constraint(equalToConstant: 35),
            
            reviewBox.trailingAnchor.constraint(equalTo: stackView2.trailingAnchor),
            reviewBox.heightAnchor.constraint(equalTo: stackView2.heightAnchor),
            
            review.topAnchor.constraint(equalTo: reviewBox.topAnchor, constant: 13),
            review.leadingAnchor.constraint(equalTo: reviewBox.leadingAnchor, constant: 13),
            review.trailingAnchor.constraint(equalTo: reviewBox.trailingAnchor, constant: -13),
            review.bottomAnchor.constraint(equalTo: reviewBox.bottomAnchor, constant: -13),
            
            shadow3.leadingAnchor.constraint(equalTo: reviewBox.leadingAnchor),
            shadow3.trailingAnchor.constraint(equalTo: menuBtn.leadingAnchor, constant: -20),
            shadow3.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shadow3.heightAnchor.constraint(equalToConstant: 125),
            
            photo.topAnchor.constraint(equalTo: shadow3.topAnchor),
            photo.leadingAnchor.constraint(equalTo: shadow3.leadingAnchor),
            photo.trailingAnchor.constraint(equalTo: shadow3.trailingAnchor),
            photo.bottomAnchor.constraint(equalTo: shadow3.bottomAnchor),
            
            // 숨겨져 있다가 나타날 버튼
            stackView.centerXAnchor.constraint(equalTo: menuBtn.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: menuBtn.topAnchor, constant: -10),
            
            addBtn.widthAnchor.constraint(equalToConstant: 55),
            addBtn.heightAnchor.constraint(equalToConstant: 55),
            listBtn.widthAnchor.constraint(equalToConstant: 55),
            listBtn.heightAnchor.constraint(equalToConstant: 55),
            
            // 기존 버튼
            shadow.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            shadow.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shadow.widthAnchor.constraint(equalToConstant: 60),
            shadow.heightAnchor.constraint(equalToConstant: 60),
            
            menuBtn.topAnchor.constraint(equalTo: shadow.topAnchor),
            menuBtn.leadingAnchor.constraint(equalTo: shadow.leadingAnchor),
            menuBtn.trailingAnchor.constraint(equalTo: shadow.trailingAnchor),
            menuBtn.bottomAnchor.constraint(equalTo: shadow.bottomAnchor),
            
        ])
    }
    
    // 뷰를 다시 그리는 시점, 레이아웃 위치/크기 재조정
    override func layoutSubviews(){
        menuBtn.layer.cornerRadius = menuBtn.frame.size.height / 2 // 원형
        menuBtn.clipsToBounds = true
        // 나머지 버튼 -> 컨트롤러에서 자르기
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
