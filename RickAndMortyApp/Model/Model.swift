//
//  Model.swift
//  RickAndMortyApp
//
//  Created by Александр on 26.02.2022.
//

import Foundation

struct RickAndMortyPage : Codable {
    let results : [RickAndMortyModel]
    let info: Info
}

struct Info: Codable {
    let next: String?
    let prev: String?
}

struct RickAndMortyModel : Codable {
    let episode: [String]
    let image: String
    let name: String
    let location: Location
    let status: String
    let species: String
    let gender: String
}

struct Location : Codable {
    let name: String
}

struct Episode: Codable {
    let name: String
    let episode: String
}
