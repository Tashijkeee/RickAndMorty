//
//  DetailTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Александр on 26.02.2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        textLabel?.text = ""
        detailTextLabel?.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell (url: String) {
        NetworlManager.fetchEpisode(url: url) { episode in
            DispatchQueue.main.async {
                self.textLabel?.text = episode.name
                self.detailTextLabel?.text = episode.episode
            }
        }
    }
    
    
    
}
