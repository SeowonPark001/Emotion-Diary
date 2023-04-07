# 📝 나의 감정 일기 (Emotion-Diary)
#### 📱 개요: Swift MVC 패턴을 이용한 다이어리 iOS 앱 프로젝트
<div>
  <img src="https://user-images.githubusercontent.com/69637868/230543106-40a86b89-8e9a-4d9b-b8e7-e66d770df099.png" alt="스플래시" width="130" height="280">
<img src="https://user-images.githubusercontent.com/69637868/230543098-a4c3a00d-6dff-4bb6-9d5f-d8092414e474.png" alt="메인1" width="130" height="280">
<img src="https://user-images.githubusercontent.com/69637868/230543100-887e34c6-5c0f-41be-9abf-6bf7df75c7e7.png" alt="메인2" width="130" height="280">
<img src="https://user-images.githubusercontent.com/69637868/230543105-31c64613-98ed-490e-910d-cb38d0ee38d1.png" alt="작성" width="130" height="280">
<img src="https://user-images.githubusercontent.com/69637868/230543096-a09d27b3-c87b-4297-8fc8-ef0327b2d64b.png" alt="목록" width="130" height="280">
<img src="https://user-images.githubusercontent.com/69637868/230543087-0f0b73e4-8d49-4481-9e52-54b940e9d192.png" alt="상세" width="130" height="280">
</div>

#### 🕰️ 개발 기간 : 2023.03.20 - 2023.03.31
#### 🧑‍💻 참여 인원 : iOS 1명
#### 📌 개발 목표 :
> MVC 구현: 일기 기록 저장, 조회, 수정, 삭제 기능, 테이블뷰에 목록 페이지 구현

> 추가목표: 일기 기록 검색 기능, 달력에 실시간 데이터 정보 업데이트 (이미지 출력)
#### 📊 개발 완성도 : MVC 100% 구현 + 추가목표 90% 구현 완료
#### 🛠️ 구현 파트
- 스플래시 화면, 메인 달력페이지, 일기 작성/수정 페이지, 일기 목록 확인 페이지
- Realm을 이용하 데이터 저장, 조회, 수정, 삭제 기능
- FSCalendar 오픈소스 캘린더 UI 및 기능 커스텀 -> 날짜 위에 데이터 내 감정 이모티콘 출력
- SearchBar를 이용한 기록 검색 기능
- Lottie를 이용한 스플래시 애니메이션 구현
#### 📚 사용 기술 & 라이브러리 : Swift, FSCalender, Realm, Lottie
<br>

### 🤔 고민 & 구현 방법
1. 데이터를 받아오는 시간을 줄이기 위한 방법
> Q. 고민 : 앱을 실행시키고 컨트롤러 간의 이동에서 여러 개의 비동기 처리와 데이터를 받아오는 시간이 최대한 지연되지 않도록 하려면 어떻게 해야 하는가.

> S. 해결 : 앱 실행 후 메인 컨트롤러에서 Realm 데이터를 읽어오기 시작한 즉시 스플래시 화면을 띄워 애니메이션 재생시간동안 데이터를 받아옴.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        // DiaryData 데이터들을 가져옴 + 오름차순
        load = realm.objects(DiaryData.self).sorted(byKeyPath: "date", ascending: true)
        dataList = load
        
        ...
        
        // 실행시 스플래시 화면 먼저 출력
        let nextVC = SplashController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
>

    func executeAnimation() {
        // 애니메이션 재생 끝난 후!
        animationView.play{ (finish) in
            print("Animation Finished!")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
> R. 결과 : 데이터를 받아오는 데 걸리는 시간을 줄이고 부드럽고 동적인 흐름으로 데이터 호출과 화면이동을 구성.
<br>

2. 화면 내 버튼을 효율적으로 배치하는 방법
> Q. 고민 : 네비게이션바 및 탭바 없이 화면 공간을 최대한 차지하지 않으면서 사용자 관점에서 접근 및 알아보기 쉬운 버튼들을 배치하려면 어떻게 해야 하는가.

> S. 해결 : 사용자 경험 관점에서 터치하기 쉽게 우측하단에 원형 메뉴 버튼을 배치하였고, 알아보기 쉬운 아이콘을 표현한 일기 작성 버튼과 목록 버튼을 숨겨서 다른 UI와 겹치지 않게 배치. 

    @objc func tapMenuBtn() {
        print("(+) 메뉴 버튼 클릭")
        
        calView.addBtn.layer.cornerRadius = calView.addBtn.frame.size.height / 2
        calView.addBtn.clipsToBounds = true
        calView.listBtn.layer.cornerRadius = calView.listBtn.frame.size.height / 2
        calView.listBtn.clipsToBounds = true
        
        // 버튼 누를 때마다 나타났다/사라졌다 토글 지정
        calView.addBtn.isHidden.toggle()
        calView.listBtn.isHidden.toggle()
    }
> R. 결과 : 메뉴 버튼 하나만 클릭하면 숨겨져 있던 다른 버튼들이 나타나 사용자로 하여금 효율적인 버튼 수납이 가능하도록 함.

