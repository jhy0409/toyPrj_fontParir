//
//  ViewController.swift
//  fontPair
//
//  Created by inooph on 5/23/24.
//

import Alamofire
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    var label: UILabel!
    var txtSize: CGFloat = 0
    
    var postArr: [Post] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //label = UILabel()
        //label.font = .systemFont(ofSize: 15)
        //label.textColor = .black
        //label.textAlignment = .center
        //label.numberOfLines = 0
        //
        //// 설정할 텍스트
        //label.text = """
        //[진양곤 HLB그룹 회장 : 세계적으로 명망 있는 항서제약의 경험과 HLB의 열정, 간절함이 함께 하고 있는 이번 간암신약 프로젝트는 약간의 지체는 있지만 결국 목표에 도달해 역대 최고의 간암신약의 꿈을 실현해 낼 것이라고 믿습니다.]
        //
        //한편 오늘(23일) HLB 주가는 장중 16% 넘게 올랐다가 상승폭을 반납하고 1.22% 하락 마감했습니다.
        //
        //한국경제TV 박승원입니다.
        //"""
        //label.setAtr()
        //label.layoutSubviews()
        //
        //view.addSubview(label)
        //
        //label.translatesAutoresizingMaskIntoConstraints = false
        //NSLayoutConstraint.activate([
        //    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        //    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        //    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
        //    label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        //])
        
        AF.request("https://koreanjson.com/posts", method: .get).response { [weak self] res in
            switch res.result {
            case .success(let data):
                if let val = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: val)
                        let jarr = json as? [NSDictionary] ?? []
                        
                        self?.postArr.removeAll()
                        
                        for i in jarr {
                            let id      = i["id"] as? Int ?? 0
                            let userId  = i["UserId"] as? Int ?? 0
                            let title   = i["title"] as? String ?? ""
                            
                            let createdAt   = i["createdAt"] as? String ?? ""
                            let updatedAt   = i["updatedAt"] as? String ?? ""
                            // let body        = i["content"] as? String ?? ""
                            
                            let body        = "[진양곤 HLB그룹 회장 : 세계적으로 명망 있는 항서제약의 경험과 HLB의 열정, 간절함이 함께 하고 있는 이번 간암신약 프로젝트는 약간의 지체는 있지만 결국 목표에 도달해 역대 최고의 간암신약의 꿈을 실현해 낼 것이라고 믿습니다.]\n\n한편 오늘(23일) HLB 주가는 장중 16% 넘게 올랐다가 상승폭을 반납하고 1.22% 하락 마감했습니다.\n\n한국경제TV 박승원입니다."
                            self?.postArr.append(.init(id: id, userId: userId, title: title, body: """
                        
                        \(body)
                        
                        let createdAt   = i["createdAt"] as? String ?? ""
                        let updatedAt   = i["updatedAt"] as? String ?? ""
                        let body        = i["content"] as? String ?? ""
                        """))
                        }
                        
                        self?.tblView.reloadData()
                        
                    } catch let err {
                        print("err - \(err)")
                    }
                }
                
            case .failure(let err):
                print("failed 2 - \(err)")
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? tvc {
            cell.backgroundColor = indexPath.row % 2 != 0 ? UIColor.gray.withAlphaComponent(0.15) : UIColor.white
            cell.label.text = postArr[indexPath.row].body
            
            
            if txtSize <= 0 {
                // txtSize = cell.label.font.pointSize * 0.9
                txtSize = cell.label.font.pointSize
            }
            
            cell.label.setAtr(txtSize)
            //cell.label.sizeToFit()
            //cell.setNeedsLayout()
            //cell.layoutIfNeeded()
            
            //let newSize = cell.label.sizeThatFits(view.frame.size) //3
            //cell.label.frame.size = newSize
            //cell.label.setNeedsLayout()
            //cell.label.layoutIfNeeded()
            
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    
}

class tvc: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
}

struct Post {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}


extension UILabel {
    func setAtr(_ atrSize: CGFloat = 0) {
        // Attributed String 생성 및 정규식 적용
        let atrStr = NSMutableAttributedString(string: self.text ?? "")
        
        // 한글을 제외한 모든 문자에 대한 패턴
        let nonKoreanPattern = "[^\u{AC00}-\u{D7A3}]+"
        // 한글 문자에 대한 패턴
        let koreanPattern = "[\u{AC00}-\u{D7A3}]"
        
        do {
            let nonKoreanRegex = try NSRegularExpression(pattern: nonKoreanPattern)
            let koreanRegex = try NSRegularExpression(pattern: koreanPattern)
            let text = self.text ?? ""
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            
            
            // 한글을 제외한 모든 문자에 대한 속성 적용
            let nonKoreanMatches = nonKoreanRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            for match in nonKoreanMatches {
                atrStr.addAttributes(
                    // [ NSAttributedString.Key.font: UIFont(name: "GmarketSansMedium", size: atrSize) as Any
                    // , range: match.range)
                    
                    [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: atrSize) as Any
                      ,NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.8),
                      
                      NSAttributedString.Key.paragraphStyle: paragraphStyle
                     ], range: match.range)
            }
            
            
            // 한글 문자에 대한 속성 적용
            let koreanMatches = koreanRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            for match in koreanMatches {
                // atrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: match.range)
                atrStr.addAttribute(
                    NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: match.range)
            }
            
            self.attributedText = atrStr
            
        } catch let err {
            print(err)
        }
    }
}
