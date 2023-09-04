# 💻 TransportationAssistant
  - 플러터를 이용한 대중교통 하차알림 어플리케이션

## ⌚ Project Period
  - 2023.03 ~ 2023.06

## 팀원 R&R
  - 최종원 : API 호출 및 사이드 레이아웃 기능, 디자인 구현, UI 수정, 논문 초안 작성
  - 임정규 : 지도 탭과 알람 탭 구현
  - 진재원 : 최근검색과 즐겨찾기 기능과 푸시 알람 사운드 구현
  - 김재현 : UI 전체적인 디자인 수정, PPT, 논문, 보고서 작성, 프로젝트 계획
  - 유준혁 : 전체적인 UI 설계, API 호출, 상세 경로 표시 
  - 최건 : 하차 알림, 백엔드 구조 설계


## 🛠 Development Environment
  ### 👩‍💻 IDE : ![androidstudio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)
  ### 📱 Mobile Framework : ![flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ### 🚀 Skills : ![dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white) ![java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
  ### 💻 OS : ![android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

## 💡 The Need For Development
대중교통을 이용하는 대부분의 사람들은 자주가는 길일지라도<br> 
상용 어플리케이션이 제공하는 정보를 이용하기 위해 항상 지도 앱이나 대중교통 애플리케이션을 이용.

이는 등하교시 항상 대중교통을 이용했던 모든 조원이 경험했던 내용으로 초행길이라면 이용 정보를 찾기 위해,<br>
자주가는 길도 더욱 빠르게 목적지에 도달하기 위해 지도나 대중교통 어플리케이션을 필수적으로 사용.

이러한 경험을 토대로 현재 상용 대중교통 어플리케이션에서 나아가 대중교통 이용 프로세스를 간소화하고,<br> 
하차 알림 기능을 제공하여 대중교통 이용 시 하차 정류장을 확인하기 위해 수시로 주변을 확인하는<br>
사용자의 피로감을 최대한 줄여 전반적인 사용자 경험을 향상시키는 사용자 친화적인 앱의 필요성을 느낌.


## 💡 Development Features
### 1. 요구사항 분석
- 현재 애플리케이션 시장에 존재하는 수많은 대중교통 어플들 중에서도 사용자 친화적인 기능과 편리한 기능이 흩어져 있다.
- 현재 기술로 충분히 개발할 수 있는 기능조차 구현이 덜 되어있다.
→ 기능을 모으고 덜 구현된 기능 보완 필요하다.

### 2. 설계
- 기존 애플리케이션 기능의 통합:

여러 기존 대중 교통 애플리케이션의 필수 기능을 하나의 통합 애플리케이션으로 통합하면 <br>
서로 다른 앱을 동시에 사용하는 개인의 사용자 경험을 크게 향상시킬 수 있다. <br> 
실시간 대중교통 정보, 경로 계획, 티켓 구매 및 서비스 업데이트와 같은 기능을 통합하여 <br>
사용자는 단일 애플리케이션에서 필요한 모든 기능에 액세스할 수 있다. <br>
이 통합으로 인해 여러 앱 사이를 전환할 필요가 없으므로 시간과 노력을 <br>
절약하는 동시에 보다 매끄럽고 편리한 대중 교통 환경을 제공한다. <br>

- 하차 알림 기능:

대중교통 애플리케이션에 '하차 알림' 기능을 포함하면 통근자들의 불편을 크게 줄일 수 있다. <br>
이 기능을 사용하면 내릴 때를 확인하기 위해 지속적으로 확인할 필요가 없어 사용자가 편안하게 휴식을 취하고 여행할 수 있다. <br>
적시에 경고 또는 알림을 제공함으로써 애플리케이션은 사용자에게 예정된 정류장 및 환승 지점에 대한 정보를 제공한다. <br>
이 기능은 정류장을 놓치거나 잘못된 환승을 할 가능성을 줄여 전반적인 대중 교통 경험을 보다 편리하고 사용자 친화적으로 만든다. <br>


### 3. 구현
[온보딩]
- 온보딩 <br>
어플리케이션 실행시 해당 어플리케이션의 강점과 장점, 간략한 사용방법, 제공 서비스 등을 제공하여 유저에게 직관적인 가이드를 제공한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/01063952-b7c3-4466-9309-747c4346ab5f)
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/b2c6eef6-e3af-4500-8fb6-e15fdb3ae26c)
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/fec8ad58-ca2d-45a4-961b-78fe45bd90d3)
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/2364704f-0033-4027-aea4-7d6b65d2b3a1)
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/a2aa04fe-a2ef-4894-ad84-26d7fb8c0485)
    
[길찾기]
- 검색 <br>
글자가 입력이 될 때 마다 API 호출을 통해 해당 입력 내용에 대한 예상 검색어 제공한다. <br>
모든 검색어를 작성 후 검색 버튼을 눌러 검색 결과가 나오는 방식보다 기술적으로 어려운 방식으로 구현하였다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/ada333a6-c5f4-4bcc-bfef-9e287c33013f)
 
- 결과 목록 <br>
출발지와 도착지 정보를 토대로 결과를 출력한다. <br>
도보거리, 소요시간, 비용 순으로 선택적으로 나열한다. <br>
경로 요약 정보를 통해 대략적인 탑승 흐름 제공한다. <br>
경로에 대한 간략한 일정을 아이콘과 색상을 통해 시각적으로 표현하였다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/74411421-8c2c-45f6-a340-ca997a47fa56)
 
- 결과 상세 정보 <br>
선택한 경로에 대한 시간, 비용, 상세 경로를 제공한다. <br>
환승 또는 하차 정류장과 통과하는 정류장을 구분하여 제공한다. <br>
경로 정보에 대해 상세 경로 보기 등을 제공하여 정확히 어떤 정류장들을 경유하는지 제공한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/0f80a117-e5af-400d-9a69-2e882840b917)
 
- 알람 설정 <br>
길찾기를 진행한 후 여러 경로 중 하나의 경로를 클릭하면 세부화면이 뜨며, 세부화면에서 하차알람을 설정할 수 있다. <br>
알람을 설정하면 팝업 알림과 함께 소리가 난다. <br>
기존의 알람을 설정하는 동안 새로운 알람을 설정할 경우 기존의 알람을 지우고 새로운 알람을 설정한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/c711ec94-5780-4b69-9afa-45c4a8cf49b6)

- 최근 기록 저장 <br>
최근에 검색한 길찾기 루트를 자동으로 저장한다. <br>
최근 검색 기록을 클릭하면 출발지와 도착지가 바로 입력되며, 길찾기 결과가 나온다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/1eaf734f-5a37-40a4-8915-535976204172)
 
- 즐겨찾기 저장 <br>
최근 검색에서 각 경로 우측에 버튼을 눌러 즐겨찾기를 설정할 수 있다. <br>
즐겨찾기된 경로를 클릭하면 출발지와 도착지가 바로 입력되며, 길찾기 결과가 나온다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/50102d85-4f09-4cc6-87bf-4d33b0128c3b)
 
[알람]
- 알람 정보 출력 <br>
설정된 알람 정보를 소요시간, 비용, 경로, 경유 정류장을 제공한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/1356e2c2-7819-4e4c-ab03-469442df5392)

- 경로 표시 <br>
알람 탭에서는 설정된 알람의 상세 경로 정보를 제공한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/39c9dd1c-27e6-43e5-98ca-d326c0c59fb2)
 
- 하차 알람 <br>
하차 혹은 환승 정류장에 다다를시 GPS 정보를 이용하여 사용자에게 하차 알람을 제공한다. <br>
사용자는 하차 알람을 듣고 자신의 하차 지점을 직관적으로 알아챌 수 있으며 알람 소리크기나 진동의 세기등을 조절할 수 있다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/fc533aba-bd7f-4f91-86cf-b9ff3e350a19)
 
- 알람 취소 <br>
현재 설정된 알람을 취소하여 앱 전체에 공유되고 있던 알람 정보를 초기화한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/f42fdff5-be79-44c4-87c9-3fb04c8f31bb)
 


[지도]
- 지도 로드 <br>
카카오 플러그인 패키지를 통해 대한민국 지도 정보를 불러온다. <br>

- 경로 표시 <br>
설정된 알람 정보의 GPS 경로 좌표를 받아와 지도에 출력한다. <br>
대중교통, 도보지점 마다 지도에 표시된 경로의 색을 다르게 하여 사용자가 직관적으로 이동 일정을 정확히 알 수 있게 된다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/ef01b33d-e1f8-4134-9afb-1ef315d37a98)

- 현재 위치 표시 <br>
현재 위치에 대한 변화 또는 5초마다 빌드된 지도에 현재 위치를 표시한다. <br>

[부가기능] <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/1edc5565-196f-4e25-8841-3ca11bac7313)
 
- 버스 정보 <br>
검색 노선의 버스 시간표를 제공한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/ca719bda-f28e-48d9-b4cf-3cc1825c2edf)
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/f247447c-162d-403d-99cb-138ea4fa7f2c)
  
- 분실물 문의 <br>
사용자의 편의를 고려하여 탑승했던 노선만 검색하면 해당 버스 운수업체의 연락처를 제공한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/95661798-b527-49b8-8088-dc797d6f0ad0)
 
- 피드백 <br>
사용자가 어플 사용 간 후기를 기록하여 사용자의 불편함을 개선하려고 노력한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/4d84460a-2b9d-4903-a8c1-9100852a8eed)
 
- 공공화장실 <br>
공공 화장실 데이터를 매핑한 사이트로 연결한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/a0b24e06-f4a9-457d-a4a4-fb38caab1e41)
 
- 크레딧 <br>
개발 참여 팀원과 팀명, 사용된 기술 스택, 사용된 API 기술 서술한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/0a4659ab-8637-4246-8404-526a042db7be)
 
- 설정 <br>
프로그래스바를 제어하여 진동을 조절한다. <br>
![image](https://github.com/r3795/TransportationAssistant/assets/105268338/08040129-64b2-43a7-af5f-6dbab870c176)
 
