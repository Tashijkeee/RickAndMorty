//
//  ViewController.swift
//  RickAndMortyApp
//
//  Created by Александр on 26.02.2022.
//

import UIKit

class ViewController: UIViewController {
  
  private var url = "https://rickandmortyapi.com/api/character?page="
  private var isLoaded = false
  private var isSearch = false // для поиска
  
  private var pages = [RickAndMortyPage]() // страницы
  private var choosedCharacter : RickAndMortyModel? // булет передаваться в DetailViewController
  
  private var characters = [RickAndMortyModel]() // Все персонажи
  private var sortedCharacters = [RickAndMortyModel]() // используется для отображения поиска
  private var maxPagesCount = 10
  
  private lazy var searchBar : UISearchBar = {
    let search = UISearchBar()
    search.translatesAutoresizingMaskIntoConstraints = false
    return search
  }()
  
  private lazy var tableView : UITableView = {
    let tv = UITableView()
    tv.translatesAutoresizingMaskIntoConstraints = false
    tv.showsVerticalScrollIndicator = false
    tv.rowHeight = 128
    return tv
  }()
  
  private func setupUI() {
    
    view.addSubview(searchBar)
    searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    searchBar.delegate = self
    searchBar.showsCancelButton = true
    
    view.addSubview(tableView)
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
    
    tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    fetchData()
  }
  
  private func fetchData() {
    NetworlManager.fetchDataRickAndMorty(url: "https://rickandmortyapi.com/api/character") { page in
      self.pages.append(page)
      self.characters = page.results
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? DetailViewController {
      vc.character = choosedCharacter
    }
  }
  
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isSearch {
      return sortedCharacters.count
    } else {
      return characters.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell {
      if isSearch {
        cell.cellModel = sortedCharacters[indexPath.row]
      } else {
        cell.cellModel = characters[indexPath.row]
      }
      cell.configureCell()
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 128
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if isSearch {
      choosedCharacter = sortedCharacters[indexPath.row]
    } else {
      choosedCharacter = characters[indexPath.row]
    }
    
    performSegue(withIdentifier: "segue", sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
    searchBar.searchTextField.endEditing(true)
  }
}

extension ViewController: UIScrollViewDelegate {
  
  private func createSpinnerFooter () -> UIView {
    let footview = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 150))
    let spinner = UIActivityIndicatorView()
    spinner.startAnimating()
    spinner.color = .black
    spinner.center = footview.center
    footview.addSubview(spinner)
    return footview
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
    let position = scrollView.contentOffset.y + scrollView.frame.size.height
    if (!isLoaded && !isSearch) {
      guard pages.count < maxPagesCount else {return}
      if (position > scrollView.contentSize.height) {
        print("load data")
        tableView.tableFooterView = createSpinnerFooter()
        isLoaded = true
        NetworlManager.fetchDataRickAndMorty(url: url + String(pages.count + 1)) { page in
          self.pages.append(page)
          self.characters += page.results
          DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.tableFooterView = nil
            self.isLoaded = false
          }
        }
      }
    }
  }
}

extension ViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchText == "") {
      isSearch = false
    }
    else {
      sortedCharacters = characters.filter {$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()}
      isSearch = true
    }
    tableView.reloadData()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSearch = false
    searchBar.text = ""
    tableView.reloadData()
  }
}

