//
//  Command.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 07/10/2022.
//

import Foundation

/// The struct holds data about the presentable commands.
public struct Command: Identifiable, Hashable {
    public let id = UUID()
    let command: String
}
