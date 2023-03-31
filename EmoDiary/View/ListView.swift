//
//  ListVIEW.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/31.
//

import UIKit

final class ListView : UITableViewCell {
    
    let mmDate: UILabel = { // 월
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ddDate: UILabel = { // 일
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emoji: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .white
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let reviewBox: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 글자 제한 X
        label.layer.borderWidth = 0.8
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let review: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 글자 제한 X
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 날짜 + 이모지 스택뷰
    let stackView1: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // 전체 스택뷰
    let stackView2: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        sv.alignment = .leading
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    //MARK: - View Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setConstraints()
    }
    
    func setupView() {

        self.contentView.addSubview(stackView2) // cell이 기본으로 contentView 갖고 있음
        
        stackView2.addArrangedSubview(stackView1)
        stackView2.addArrangedSubview(reviewBox)
        
        stackView1.addArrangedSubview(mmDate)
        stackView1.addArrangedSubview(ddDate)
        stackView1.addArrangedSubview(emoji)
        
        reviewBox.addSubview(review)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            stackView2.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stackView2.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            stackView2.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            stackView2.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            emoji.widthAnchor.constraint(equalToConstant: 35),
            emoji.heightAnchor.constraint(equalToConstant: 35),
            
            reviewBox.trailingAnchor.constraint(equalTo: stackView2.trailingAnchor),
            reviewBox.heightAnchor.constraint(equalTo: stackView2.heightAnchor),
            
            review.topAnchor.constraint(equalTo: reviewBox.topAnchor, constant: 13),
            review.leadingAnchor.constraint(equalTo: reviewBox.leadingAnchor, constant: 13),
            review.trailingAnchor.constraint(equalTo: reviewBox.trailingAnchor, constant: -13),
            review.bottomAnchor.constraint(equalTo: reviewBox.bottomAnchor, constant: -13),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
