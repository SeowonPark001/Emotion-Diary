//
//  MainView.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/20.
//

import UIKit

class CalendarView :  UIView {
    // 각 달력에 붙어있을 이모티콘
    lazy var emotion1 : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 해당 날짜 카드뷰(테이블 뷰)에 있을 이모티콘
    lazy var emotion2 : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    // 해당 날짜 카드뷰(테이블뷰?)에 있을 일기 내용
    lazy var review : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 일기 작성(추가) 버튼 (+)
    let addBtn : UIButton  = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "Dark")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 그림자
    let shadow: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupView()
        setUpConstraints()
    }
    
    func setupView() {
        addSubview(emotion1)
        addSubview(emotion2)
        addSubview(review)
        addSubview(shadow)
        shadow.addSubview(addBtn)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            emotion1.centerXAnchor.constraint(equalTo: centerXAnchor),
            emotion1.centerYAnchor.constraint(equalTo: centerYAnchor),
            emotion1.widthAnchor.constraint(equalToConstant: 50),
            emotion1.heightAnchor.constraint(equalToConstant: 50),
            
            emotion2.topAnchor.constraint(equalTo: emotion1.bottomAnchor, constant: 50) ,
            emotion2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20) ,
            emotion2.widthAnchor.constraint(equalToConstant: 30),
            emotion2.heightAnchor.constraint(equalToConstant: 30),
            
            review.topAnchor.constraint(equalTo: emotion2.topAnchor) ,
            review.leadingAnchor.constraint(equalTo: emotion2.trailingAnchor, constant: 20) ,
            review.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20) ,
            review.bottomAnchor.constraint(greaterThanOrEqualTo: shadow.topAnchor, constant: -5) ,
            
            shadow.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            shadow.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            shadow.widthAnchor.constraint(equalToConstant: 60),
            shadow.heightAnchor.constraint(equalToConstant: 60),
            
            addBtn.topAnchor.constraint(equalTo: shadow.topAnchor),
            addBtn.leadingAnchor.constraint(equalTo: shadow.leadingAnchor),
            addBtn.trailingAnchor.constraint(equalTo: shadow.trailingAnchor),
            addBtn.bottomAnchor.constraint(equalTo: shadow.bottomAnchor),
            
        ])
    }
    
    // 뷰를 다시 그리는 시점, 레이아웃 위치/크기 재조정
    override func layoutSubviews(){
        addBtn.layer.cornerRadius = addBtn.frame.size.height / 2 // 원형
        addBtn.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
