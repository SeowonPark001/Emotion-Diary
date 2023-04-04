//
//  SplashController.swift
//  EmoDiary
//
//  Created by 박서원 on 2023/03/31.
//

import UIKit
import Lottie
import RealmSwift

class SplashController : UIViewController {
    
    // 애니메이션 이미지
    lazy var animationView : LottieAnimationView = {
        let view = LottieAnimationView(name: "109643-rapturous-emoji")
        view.contentMode = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let myTitle : UILabel = {
        let label = UILabel()
        label.text = "감정 일기"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        executeAnimation()
    
        // 네비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // View가 사라질 때 => 숨겼던 네비게이션 바 다시 출력
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "Medium")
        
        view.addSubview(animationView)
        view.addSubview(myTitle)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            myTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myTitle.topAnchor.constraint(equalTo: animationView.bottomAnchor)
        ])
    }
    
    func executeAnimation() {
        
        // 애니메이션 재생 끝난 후!
        animationView.play{ (finish) in
            print("Animation Finished!")
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

