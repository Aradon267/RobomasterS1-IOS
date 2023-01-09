//
//  LocalData.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import Foundation

//
//  LocalData.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 30/09/2022.
//

import Foundation
import Combine

/// The class that holds the local data about the Tutorials
final class LocalData: ObservableObject{
    @Published var tutorials: [RobotFunctionTutorial] = load("tutorial.json")
}


/// The function will load the content of a JSON file to a list.
/// - Parameter filename: The name of the JSON file.
/// - Returns: A list of the contents of the given JSON file.
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
