//
//  ViewController.swift
//  Final_Project
//
//  Created by Crystal Ding on 2020-04-10.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let dbModel = DBModel()
    private lazy var resultSet = [City]()
    private lazy var filteredSet = [City]()
    private lazy var searchStr : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //whenever initial view appears, fetch data from db and populate them to tableView
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.startAnimating()
        
        dbModel.fetch { [unowned self] data in
            DispatchQueue.main.async { [weak self] in
                self!.resultSet = data
                self!.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    //search bar fitler string
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSet = resultSet.filter { (city: City) -> Bool in
            return city.city_name!.lowercased().contains(searchText.lowercased())
        }
        searchStr = searchText
        tableView.reloadData()
    }

    //config tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchStr == "") ? resultSet.count : filteredSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = (searchStr == "") ? resultSet[indexPath.row] : filteredSet[indexPath.row]
        let province = data.province_belong?.province_name
        let country = data.province_belong?.country_belong?.country_name
        
        cell.textLabel?.text = data.city_name
        cell.detailTextLabel?.text = (province ?? " ") + ", " + (country ?? " ")
        
        return cell
    }
    
    //prepare for view transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueID = segue.identifier as String?
        
        if (segueID == "ShowDegailSegue") {
            let vc = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow
            let selectedCity = resultSet[index!.row]
            vc.selectedCity = selectedCity
        }
    }
}
