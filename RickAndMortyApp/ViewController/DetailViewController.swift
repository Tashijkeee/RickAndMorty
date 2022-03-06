//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Александр on 26.02.2022.
//

import UIKit

class DetailViewController: UIViewController {

    var character: RickAndMortyModel?
    
    private lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
  private lazy var imageView : UIImageView = {
        let im = UIImageView()
        im.translatesAutoresizingMaskIntoConstraints = false
        im.clipsToBounds = true
        im.contentMode = .scaleToFill
        return im
    }()
    
  private lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  private lazy var episodesLabel : UILabel = {
        let label = UILabel()
        label.text = "Episodes"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
  private lazy var myView : [DetailView] = {
        var views = [DetailView]()
        for i in 0...3 {
            let view = DetailView()
            view.translatesAutoresizingMaskIntoConstraints = false
            views.append(view)
        }
        
        return views
    }()
    
  private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
        configure()
    }
    
    private func configure() {
        guard let character = character else {return}
        
        NetworlManager.fetchImage(url: character.image) { data in
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data) ?? nil
            }
        }
        
        nameLabel.text = character.name
        myView[0].systemLabel.text = "Live status:"
        myView[0].customLabel.text = character.status
        
        myView[1].systemLabel.text = "Species and gender:"
        myView[1].customLabel.text = character.species + " - " + character.gender
        
        myView[2].systemLabel.text = "Last known location:"
        myView[2].customLabel.text = character.location.name
        
        myView[3].systemLabel.text = "First seen in:"
        
        NetworlManager.fetchEpisode(url: character.episode[0]) { episode in
            DispatchQueue.main.async {
                self.myView[3].customLabel.text = episode.name
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: episodesLabel.bottomAnchor).isActive = true
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    private func setupLayout () {
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height*0.2).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 237).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        for i in myView {
            stackView.addArrangedSubview(i)
        }
        
        view.addSubview(episodesLabel)
        episodesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        episodesLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character?.episode.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DetailTableViewCell {
            cell.configureCell(url: character?.episode[indexPath.row] ?? "")
            return cell
        }
        return UITableViewCell()
    }
}
