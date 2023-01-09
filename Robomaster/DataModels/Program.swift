//
//  Program.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import Foundation

/// The class holds data of programs.
public class Program: Encodable, Decodable{
    
    public var program: [String]
    public var programDisplay: [String]
    public var username: String
    public var programName: String
    public var programDescription: String
    public var date: String
    public var progid: String
    
    /// Ininializes a new program.
    /// - Parameters:
    ///   - program: List of strings with the commands.
    ///   - programDisplay: List of strings with presentable commands.
    ///   - username: The username that the program belongs too.
    ///   - programName: The program's name.
    ///   - programDescription: The program's description.
    ///   - date: The date the program was saved at.
    ///   - progid: The program ID.
    public init(program: [String], programDisplay: [String], username: String, programName: String, programDescription: String, date: String, progid: String) {
        self.program = program
        self.programDisplay = programDisplay
        self.username = username
        self.programName = programName
        self.programDescription = programDescription
        self.date = date
        self.progid = progid
    }
}
