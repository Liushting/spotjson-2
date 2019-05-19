//    func downloadWitchData(webAddress:String){
//
//        if let url =  URL(string: webAddress) {
//            if interneOK() == true {
//                DispatchQueue.main.async {
//                    do{
//                        let downloadedDate = try Data(contentsOf: url)
//                        print(try JSONSerialization.jsonObject(with: downloadedDate, options: []))
//                    }
//                    catch{
//                        //因爲這邊在主執行緒裡面 要加上DispatchQueue
//                        DispatchQueue.main.async {
//                            // 因為是在一個閉包 都要加self
//                            self.popAlert(withTitle: "Sorry", AndMessage: error.localizedDescription)
//                        }
//                        print(error)
//                        // 如果有網路的話開始下載資料
//                    }
//                }
//
//            } else {
//                // 如果沒有網路的時候
//                popAlert(withTitle: "沒有網路", AndMessage: "請再試一次")
//
//            }
//        }else {
//            // 連接不到url的時候
//            popAlert(withTitle: "抱歉", AndMessage: "目前沒辦法產出隨機的使用者")
//        }
//
//    }

