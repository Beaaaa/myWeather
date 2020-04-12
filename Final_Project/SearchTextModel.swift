//
//  SearchTextModel.swift
//  Final_Project
//
//  Created by Crystal Ding on 2020-04-11.
//

import Foundation

class SearchTextModel {
    
    func autoFillCity(searchString : String, completion: @escaping ([String]) -> Void){
        
        guard let url = URL(string: "http://gd.geobytes.com/AutoCompleteCity?q=\(searchString)") else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!)
                completion(json as! [String])
            }
            catch {
                print("fetch auto-fill data error")
            }
        }
        
        task.resume()
    }
}
