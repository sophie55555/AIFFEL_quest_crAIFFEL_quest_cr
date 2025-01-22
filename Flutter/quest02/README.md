# AIFFEL Campus Online Code Peer Review Templete
- 코더 : 고명지, 최유진
- 리뷰어 : 박종호


# PRT(Peer Review Template)
- [v]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    ![1  결과물](https://github.com/user-attachments/assets/50935962-de9e-49ef-a349-c21c71aa4d4d)

네 잘 제출되었습니다.
    
- [v]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
네 코드가 깔끔하고 명료합니다.
        
- [v]  **3. 에러가 난 부분을 디버깅하여 문제를 해결한 기록을 남겼거나
새로운 시도 또는 추가 실험을 수행해봤나요?**
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.red,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 240,
                      height: 240,
                      color: Colors.orange,

       사각형을 만드는 코드에서 Alignment.center를 하고 문제가 발생하여 각각의 Positioned를 잡아준 부분이 새로웠고
       그로인하여 유지보수가 쉽고 또 다양한 position으로 이동할수 있는것을 실험해봤습니다.
        
- [v]  **4. 회고를 잘 작성했나요?**
네 잘 작성되었고 설명도 좋았습니다.
        
- [ ]  **5. 코드가 간결하고 효율적인가요?**
많은 코드가 중복이 안되고 간결했고
중복이 된 Stack에서의 코드는 유지보수를 위해서 저렇게 했다고 설명을 들었습니다. 
# 회고(참고 링크 및 코드 개선)
```
박종호: 저는 코드의 중복을 피하기 위해서 for문을 통해 사각형을 만들었지만 유지보수나 비선형적인 구조는 만들수 없는 한계가 있는데
조금 길어지지만 각각의 사각형에게 자유도를 주어서 흥미로웠습니다.
