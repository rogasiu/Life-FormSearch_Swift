//
//  LifeTableViewController.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import UIKit

class LifeTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    var items = [SearchItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        
        if !searchTerm.isEmpty {
            
            // set up query dictionary
            let query = searchTerm
            // use the item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
            let searchItemRequest = SearchItemAPIRequest(searchName: query)
            Task{
                do{
                    let storeItem = try await SendAPIRequest.sendRequest(searchItemRequest)
                    self.items = storeItem
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = items[indexPath.row]
        var contents = cell.defaultContentConfiguration()
        contents.text = item.commonName
        contents.secondaryText = item.scientificName
        cell.contentConfiguration = contents

        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @IBSegueAction func showDetails(_ coder: NSCoder, sender: Any?) -> SearchViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
                  return nil}
        let lifeForm = items[indexPath.row]
        return SearchViewController(coder: coder, lifeForm: lifeForm)
    }
    
}
