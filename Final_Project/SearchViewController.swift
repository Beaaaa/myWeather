//
//  SearchViewController.swift
//  Final_Project
//
//  Created by Crystal Ding on 2020-04-11.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let dbModel = DBModel()
    private let searchTextModel = SearchTextModel()
    private lazy var resData = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //call auto-fill function to get a list of cities
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        searchTextModel.autoFillCity(searchString: searchText) { [unowned self] data in
            DispatchQueue.main.async { [weak self] in
                self!.resData = data
                self!.searchTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }

    //config tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath)
        
        if (resData.count > 1) {
            let strArr = self.resData[indexPath.row].components(separatedBy: ", ")
            cell.textLabel?.text = strArr[0]
            cell.detailTextLabel?.text = strArr[1] + ", " + strArr[2]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.activityIndicator.startAnimating()
        dbModel.addCity(selectedCity: resData[indexPath.row]) { [unowned self] in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: nil, message: "Your favourite city has been saved!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Gotcha", style: .default, handler: { [unowned self] action in
                    self!.navigationController?.popViewController(animated: true)
                }))
                self!.present(alert, animated: true)
            }
        }
    }
}
