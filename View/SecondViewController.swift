//
//  SecondViewController.swift
//  BasicRequest
//
//  Created by Владимир on 21.09.2023.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var url: String = ","
    let idintifire = "ll"
    var model = [GitRepos]()
    let queue = DispatchQueue.main
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        
        getRepos()
        
    }
    
  
    
    
    
    func getRepos() {
        let urls = URL(string: url)
            do {
                let data = try Data(contentsOf: urls!)
                let result = try JSONDecoder().decode([GitRepos].self, from: data)
                self.model = result
            } catch {
                print("Error")
            }

    }
    

}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: idintifire)
        cell.detailTextLabel?.text = "ID репозитория - \(model[indexPath.row].id)"
        cell.textLabel?.text = "Название - \(model[indexPath.row].name)"
        
        return cell
    }
    
    
}
