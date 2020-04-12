//
//  DBModel.swift
//  Final_Project
//
//  Created by Crystal Ding on 2020-04-12.
//

import UIKit
import CoreData

class DBModel {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let dbDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //fetch data to db
    func fetch(completion: @escaping ([City]) -> Void){
        let fetchData : NSFetchRequest =  City.fetchRequest()
            do{
                var resData = [City]()
                resData = try context.fetch(fetchData)
                completion(resData)
            }
            catch {
                fatalError("Failed to fetch cities: \(error)")
            }
    }
    
    //save data to db
    func addCity (selectedCity : String, completion: @escaping () -> Void) {
        
        let strArr = selectedCity.components(separatedBy: ", ")
        let city = City(context: self.context)
        let province = Province(context: self.context)
        let country =  Country(context: self.context)
        
        city.city_name = strArr[0]
        province.province_name = strArr[1]
        country.country_name = strArr[2]
        country.addToProvince(province)
        province.country_belong = country
        province.addToCity(city)
        city.province_belong = province
        
        do {
            try self.context.save()
        }
        catch let error as NSError {
            fatalError("Error: \(error.localizedDescription)")
        }
        
        self.dbDelegate.saveContext()
        completion()
    }
}
