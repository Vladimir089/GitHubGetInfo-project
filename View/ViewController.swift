//
//  ViewController.swift
//  BasicRequest
//
//  Created by Владимир on 04.09.2023.
//

import UIKit

class ViewController: UIViewController {
    //MARK: -OUTLETS
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    let mainQueue = DispatchQueue.main
    var endpoint = "https://api.github.com/users/sallen0400"
    var urlNext = " "
    
    @IBOutlet weak var navigateItemsName: UINavigationItem!
    var nickName: String = "sallen0400"
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var biotext: UITextView!
    @IBOutlet weak var reposLabel: UILabel!
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 175
        searchTextField.delegate = self
        getUser()
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (s) in
            self.view.frame.origin.y = -340
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil , queue: nil) { (s) in
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: -METHODS
    func getUser() {
        let url = URL(string: endpoint)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let _ = url, url != nil {
            let request = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) { data , response , error  in
                if let data = data, let git = try? decoder.decode(GitHubUser.self, from: data) {
                    self.mainQueue.async {
                        self.biotext.text = git.bio
                        self.usernameLabel.text = git.name
                        self.loadPhoto(URLString: git.avatarUrl)
                        self.followersLabel.text = "\(git.followers) подписчиков"
                        self.urlNext = self.endpoint
                        self.navigateItemsName.title = git.name
                        var rep = 0
                        if git.publicRepos != 0 {
                            rep = git.publicRepos ?? 0
                        }
                        if git.publicRepos == nil && git.publicRepos == 0 {
                            self.reposLabel.text = "нет репозиториев"
                            return
                        } else if git.publicRepos == 1 {
                            self.reposLabel.text = "\(rep) репозиторий"
                        } else if git.publicRepos ?? 0 > 1 && git.publicRepos ?? 0 < 5 {
                            self.reposLabel.text = "\(rep) репозитория"
                        } else if git.publicRepos ?? 0 >= 5 {
                            self.reposLabel.text = "\(rep) репозиториев"
                        }
                    }
                }
            }
            task.resume()
        } else {
            showAlert(message: "Такого пользователя нет")
        }
    }
    
    @IBAction func savePage(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "repos")  as? SecondViewController
        vc!.url = "https://api.github.com/users/\(nickName)/repos"
        navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    
    func loadPhoto(URLString: String)  {
        let url = URL(string: URLString)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data1, response1, error1 in
            self.mainQueue.async {
                let image = UIImage(data: data1!)!
                self.imageView.image = image
            }
        }
        task.resume()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        if searchTextField.text != "" {
            nickName = searchTextField.text!
        } else {
            showAlert(message: "Укажите ник")
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let urlString = "https://api.github.com/users/" + "\(nickName)"
        let url = URL(string: urlString )
        if var _ = url, url != nil {
            let request = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) { data , response , error  in
                if let data = data, let git = try? decoder.decode(GitHubUser.self, from: data) {
                    self.mainQueue.async {
                        self.biotext.text = git.bio
                        self.usernameLabel.text = git.name
                        self.loadPhoto(URLString: git.avatarUrl)
                        self.followersLabel.text = "\(git.followers) подписчиков"
                        self.navigateItemsName.title = git.name
                        self.urlNext = urlString
                        self.view.frame.origin.y = 0
                        var rep = 0
                        if git.publicRepos != 0 {
                            rep = git.publicRepos ?? 0
                        }
                        self.searchTextField.resignFirstResponder()
                        if git.publicRepos == nil && git.publicRepos == 0 {
                            self.reposLabel.text = "нет репозиториев"
                            return
                        } else if git.publicRepos == 1 {
                            self.reposLabel.text = "\(rep) репозиторий"
                        } else if git.publicRepos ?? 0 > 1 && git.publicRepos ?? 0 < 5 {
                            self.reposLabel.text = "\(rep) репозитория"
                        } else if git.publicRepos ?? 0 >= 5 {
                            self.reposLabel.text = "\(rep) репозиториев"
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

//MARK: -Extension

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        return true
    }
}
