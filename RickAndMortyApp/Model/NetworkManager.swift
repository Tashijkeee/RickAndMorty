//
//  NetworkManager.swift
//  RickAndMortyApp
//
//  Created by Александр on 26.02.2022.
//

import Foundation
import UIKit

class NetworlManager {
    static func fetchDataRickAndMorty(url : String, comletion: @escaping (RickAndMortyPage)->()) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            do{
                let jsonData = try JSONDecoder().decode(RickAndMortyPage.self, from: data)
                comletion(jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    static func fetchImage(url : String, comletion: @escaping (Data)->()){
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            comletion(data)
        }.resume()
    }
    
    static func fetchEpisode(url : String, comletion: @escaping (Episode)->()){
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {return}
            do{
                let jsonData = try JSONDecoder().decode(Episode.self, from: data)
                comletion(jsonData)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
