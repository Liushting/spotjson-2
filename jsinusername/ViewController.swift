//
//  ViewController.swift
//  jsinusername
//
//  Created by 劉十六 on 2019/5/18.
//  Copyright © 2019 Ting. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userlabel: UILabel!
    var infoTableViewController:InfoTableViewController?
    var userapi = "https://itunes.apple.com/search?term=陳奕迅&media=music".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let reachability = Reachability(hostName: "www.apple.com")
    lazy var sessiin = { return URLSession(configuration: .default)
    }()
    var session = URLSession(configuration: .default)
    //測試有沒有網路
    var isDownloading = false
    // 為了避免再重新整理的時候還在下載上一個圖片
    
    
    @IBAction func makeNewUser(_ sender: UIBarButtonItem) {
        // 因為在各總有可能失敗的地方 設定false
        // 所以 如果沒有再下載
        //在呼叫downloadWithURLSession 重新開始下載
        if isDownloading == false {
            downloadWithURLSession(webAddress: userapi!)
        }
        
    }
    func downloadWithURLSession(webAddress:String) {
        if let url =  URL(string: webAddress){ // 先把網址連結到url 網路正常時開始下載資料
            if interneOK() == true {
                let task  = session.dataTask(with: url) { (data, response, error) in
                    // data =  下載資料
                    // response = 網頁回應
                    // error =  有可能發生的錯誤
                    if error != nil {
                        DispatchQueue.main.async {
                            // 在這個必包裡面 error 會是個Optional 選以要先寫檢查式這邊才可以放心加！
                            self.popAlert(withTitle: "Sorry", AndMessage: error!.localizedDescription)
                        }
                        self.isDownloading = false
                        return
                    }
                    if let  dowloadedData = data{
                        do{
                            let downloadedDate = try Data(contentsOf: url)
                            let json = try JSONSerialization.jsonObject(with: downloadedDate, options: [])
                            DispatchQueue.main.async {
                                self.parseJSON(json: json)
                            }
                        }
                        catch{
                            //因爲這邊在主執行緒裡面 要加上DispatchQueue
                            DispatchQueue.main.async {
                                // 因為是在一個閉包 都要加self
                                self.popAlert(withTitle: "Sorry", AndMessage: error.localizedDescription)
                            }
                        }
                    } else {
                        self.isDownloading = false
                    }
                }
                task.resume() //開始下載
                isDownloading = true
            }else {
                // 如果沒有網路的時候
                popAlert(withTitle: "沒有網路", AndMessage: "請再試一次")
                
            }
        }
        else {
            // 連接不到url的時候
            popAlert(withTitle: "抱歉", AndMessage: "目前沒辦法產出隨機的使用者")
        }
        
    }
    
    func interneOK() -> Bool {
        //＝＝0就是沒有網路 回傳flase
        if reachability?.currentReachabilityStatus().rawValue == 0 {
            return false
        }
        else{
            return true
        }
    }
    
    
    func popAlert(withTitle title:String,AndMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //創造警告控制器
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
        present(alert,animated: true,completion: nil)
        // 推出警告控制器
    }
    
    override func viewDidLoad() {
        
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0.67, green: 0.3, blue: 0.157, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        super.viewDidLoad()
        downloadWithURLSession(webAddress:userapi!)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moinfo"{
            infoTableViewController =  segue.destination as? InfoTableViewController
        }
    }
    //    if let infoArray = okJson["results"] as? [[String:Any]]{
    //        // 現在用results取直 把結果可以看成是一個陣列 而陣列裡面的成員是Dictionary 所以會有兩個[]
    //        // 轉型成功 把值存進 infoArray裡面
    //        print(infoArray)
    //        let infoDictionary = infoArray[0]
    //
    
    func parseJSON(json:Any){
        if let okJson = json as? [String:Any]{
            // 把下載得資料看成是Dictionary 型別是字串內容是Any（可能是陣列也有可能是Dictionary）
            // 把轉型的結果存在okjson裡面
            // 轉型成功的時候 就可以用results這個key 讓key拿到陣列
            // 在這個陣列裡面只有一個成員 是Dictionary 在這個Dictionary裡面key是字串 內容可能是字串也有可能是字典
            if let loadedImageAddresss = okJson["results"] as? [[String:Any]]{
             //   print(loadedImageAddresss)
                //   if  let  infoinfoDicss = infoinfoDics["Info"] as? [String:Any]{
                // 現在用results取直 把結果可以看成是一個陣列 而陣列裡面的成員是Dictionary 所以會有兩個[]
                // 轉型成功 把值存進 infoArray裡面
                var key = Int.random(in: 0...50)
                let infoDictionary = loadedImageAddresss[key]

                // 取出範例json裡面 第一個陣列 也就是index是0
                //把它存在 infoDictionary 裡面
                let loadedName =  infoDictionary["trackName"] as? String
                //  let loadedName = userFullName(nameDictionary: infoDictionary["name"])
                // 最後用name 當key 拿到裡面的Dictionary  但是要再拿到裡面的字串 必須在建立一個方法來取得（userFullName）
                let loadedEmail =  infoDictionary["collectionCensoredName"] as? String
                let loadedPhone = infoDictionary["artistName"] as? String
                let  players = infoDictionary["previewUrl"] as? String
                let imageDictionary = infoDictionary["artworkUrl100"] as? String
                
                // 又是一個Dictionary 所以要轉型[String: XXX]
                //  let loadedImageAddress = imageDictionary?["artworkUrl100"]
                // key為large  ， loadedImageAddress 得到圖片網址（json裡面）
                let loadedUser = User(name: loadedName, email: loadedEmail, Phone: loadedPhone, image: imageDictionary,players: players )
                settingInfo(userss: loadedUser)
                
                // 把loadedUser當成參數 呼叫settingInfo
            }
            
            
        
        else {
            self.isDownloading = false
        }
    } else {
    self.isDownloading = false
    //}
    }


}
func userFullName(nameDictionary:Any?) -> String?{
    //  看json想得資料想要取用得值  假設現在是要取的是first,last 所以轉型成string,string
    // 轉型成功存在okDictionary
    if let okDictionary = nameDictionary as? [String:String]{
        let firstName = okDictionary["first"] ?? ""
        //  在把first 當key  存在 firstName
        let lastName = okDictionary["last"] ?? ""
        return firstName + " " + lastName
    }else{
        return nil
    }
}
var player: AVPlayer?
func settingInfo(userss:User) {
    userlabel.text = userss.name
    infoTableViewController?.email.text = userss.email
    infoTableViewController?.phone.text = userss.Phone
    if let  imageAddress = userss.image, let playert = userss.players {
        // 把網址轉成ＵＲＬf let imageAddress = user.image{
        if let imageURL = URL(string: imageAddress),let playURl = URL(string: playert){
           // print(playURl)
            let task = session.downloadTask(with: imageURL, completionHandler: {
                (url, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.popAlert(withTitle: "Soory", AndMessage: error!.localizedDescription)
                    }
                    self.isDownloading = false
                    return
                }
                if let okURL = url {
                    do {
                        let downloadImage = UIImage(data: try Data(contentsOf: okURL))
                        DispatchQueue.main.async {
                            print(okURL)
                            self.userImageView.image = downloadImage
                            self.isDownloading = false
                            // 正確的話開始下載圖片
                    
                        }
                        self.player = AVPlayer(url: playURl)
                        self.player?.play()
                        print(playURl)
                    }
                    catch{
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "Sorry", AndMessage: error.localizedDescription)
                            self.isDownloading = false
                        }
                        
                    }
                }
            })
            task.resume()            }
        else {
            self.isDownloading = false
        }
    } else {
        self.isDownloading = false
    }
    
}
override func viewDidAppear(_ animated: Bool) {
    // 畫面顯示在螢幕上時才會執行
//    userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
}
}
