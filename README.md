# BookSearcher

**Deployment Target: iOS 15.0**

**Architecture: RxSwift + MVVM**

**Framework & Library: RxSwift, RxAppState, SnapKit**

## 구현사항

- [x] 검색화면 구현
- [x] 디테일 화면 구현
- [x] 아이템 선택시 디테일 화면 이동

### 추가구현사항

- [x] 메인화면 구현
- [x] 자세히 보기 터치시 Safari로 이동
- [x] 위시리스트 추가 터치시 Toast Message present

## 실행화면

| 메인화면                                                     | 검색화면 이동                                                | 검색화면                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![](https://user-images.githubusercontent.com/78553659/199579739-d4b4fb9d-a730-41c9-81b2-89b044767737.gif) | ![](https://user-images.githubusercontent.com/78553659/199579752-e2699b91-8a88-49f8-bcf8-3a063ac37053.gif) | ![](https://user-images.githubusercontent.com/78553659/199579766-45a27e7f-de60-4a4c-b377-4bbb53218578.gif) |



| 디테일화면                                                   | 자세히 보기 터치                                             | 위시리스트에 추가 터치                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![](https://user-images.githubusercontent.com/78553659/199579775-a1eeb6ff-5b60-463a-8a20-2c22c3ae20ed.gif) | ![](https://user-images.githubusercontent.com/78553659/199579785-3a77b358-45df-46df-b7e5-072313072d4a.gif) | ![](https://user-images.githubusercontent.com/78553659/199579797-147b4a39-29a2-4c91-aeb4-e7472c5ae6e4.gif) |



## 트러블 슈팅

<details>
  <summary>검색 터치 애니메이션</summary>


### 문제

  - 기존의 Push, Present로는 해당 애니메이션 표현이 어려움


### 고민

1. 구글 북스 앱과 다르게 Push, Present 애니메이션 적용
2. Custom 애니메이션 구현

### 해결

  `SearchBar` 모양의 버튼을 생성, 해당 버튼과 같은 크기를 가진 `ContentView`를 만들어 `SearchViewController`를 `ContenView`에 추가.
  `SearchBar` 버튼 터치시 `ContentView`의 크기를 키우는 방식으로 `SearchViewController` present.
  `SearchViewController`가 present되기 전, dimiss 되고 난후 `ContentView.isHidden = true`

</details>
<br></br>


<details>
  <summary>메인화면 최다판매 리스트 Cell 이미지 다운로드 시점 </summary>


### 문제

  - 서버로부터 `Item`을 받아와 `CollectionView`에 전달할 때 이미지를 다운로드 받게되면 보이지 않는 셀의 이미지도 다운로드 요청을 하기에 불필요한 자원낭비라고 생각


### 해결

  각 `Cell`에 해당하는 ViewModel을 만들고, `Cell`이 뷰에 그려질때, `configure(with: viewModel)`메소드를 이용하여 바인딩, `configure`이후 ViewModel에게 `Cell`의 로드정보를 알려줌.
  ViewModel은 Cell로부터 로드 이벤트가 방출될때 이미지를 다운로드하도록 구현

</details>
<br></br>


<details>
  <summary>이미지 캐싱</summary>


### 문제

  - 메모리 캐싱만 진행할지 디스크 캐싱까지 진행을 해야할지 고민

### 고민

1. 디스크캐싱이 필요한지?

     - 책 정보의 경우 이미지가 바뀔 가능성이 적다고 판단, 한번 디스크에 저장해놓으면 앱을 구동할 때마다 이미지를 받아오지 않아도됨.

     - 하지만, 사용자가 동일한 책을 검색 할 경우보다 새로운 책을 검색 할 경우가 많다고 생각.

     - 동일한 책만 검색할 경우 디스크캐싱이 유리하지만, 새로운 책만 검색할 경우 오히려 불필요한 데이터를 저장.
### 해결

디스크캐싱 없이 메모리 캐싱만 진행.

</details>
<br></br>


<details>
  <summary>최다판매 리스트, 검색 리스트 dataSource (미해결)</summary>


### 문제

  - 하나의 dataSource를 바탕으로 다른 정보를 보여주기때문에 Book / Music 탭 이동시 해당 스크롤 위치값을 그대로 가지고 `Cell`의 데이터만 변경


### 고민

1. 각 탭별로 다른 `dataSource`를 두고 바인딩 (유력)
   - `viewModel` 로직이 복잡해 질 수 있음.

2. 탭이 변동될시 ` CollectionView` reload

   - 로직은 간편하나, 사용자 경험 저하 우려 존재

   - 페이지네이션 기능 구현시 `viewModel`이 더 복잡해 질 수 있음.

</details>
<br></br>

<details>
  <summary>디테일 화면 구현</summary>


### 문제

  - 각 섹션마다 다른 UI의 형태를 띄고있어 ViewController의 코드 길이가 길어짐.


### 고민

1. `UICollectionView` + `CompositionalLayout`을 사용하여 각 섹션별로 다른 `Cell` 활용.

   - 각 섹션별로 다른 cell을 활용하다보니 `DataSource`의 길이가 길어지고 코드 가독성이 떨어지는 현상 발생.

   - 버튼섹션의 경우 터치 이벤트를 상위 `ViewModel`에 전달해야하는데, 로직이 복잡해짐.

2. `UIScrollView` + `UITableView` 활용

   - 사용자 리뷰섹션만 `TableView`를 활용, 나머지 섹션은 `CustomView`를 만들어서 활용.

   - `ScrollView`의 높이가 정해지지않으면 `TableView`의 경우 `Cell`을 그리지 않음.

### 해결

`UIScrollView` + `UITableView`를 활용하여 구현.

`TableView`의 최소 높이값을 지정해두고, `ScrollView`의 `ContentLayoutGuide.bottom`을 `TableView.bottom`과 맞춤

`DetailViewController`의 레이아웃 코드가 길어졌지만, `CollectionView`를 활용했을때보다 전체적인 코드량이 현저히 줄어듬.

</details>
<br></br>

<details>
  <summary>DetailViewModel - SubViewModel 바인딩 </summary>


### 문제

  - 하위 View와 ViewModel 바인딩을 Rx를 통해서 진행하니 로직이 복잡해지고 코드길이가 길어짐.

### 고민

1. 각 데이터 파싱을 `DetailViewModel`이 하지 않고 `SubViewModel`에게 의존

    - `DetailViewModel`의 경우 코드가 줄어들지만, 불필요한 데이터까지 전달.

2. Rx를 활용하지 않고 직접 전달.

    - `ViewModel`의 경우 `View`에게 한번 주입하기 때문에 굳이 Rx를 이용 할 필요가 없음.

    - `DetailView`와 `DetailViewModel`의 의존도가 높아지는걸 우려했지만, Rx를 사용해도 의존도 변함 없음.

### 해결

기존 Rx를 통해서 `ViewModel`을 주입해주던 로직을 `DetailViewController`가 `DetailViewModel`로부터 받아오는 로직으로 변경
한번 사용하고 사용하지 않는 스트림을 삭제 하여 불필요한 메모리 낭비를 줄이고, Rx를 걷어냄으로써 `DetailViewModel`의 가독성 향상

</details>
<br></br>