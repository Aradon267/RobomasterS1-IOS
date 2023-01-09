//
//  RobotFunctionTutorial.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 08/10/2022.
//

import Foundation

/// The class hold data about the robot functionality.
public class RobotFunctionTutorial: Decodable, Identifiable{
    public var funcName: String
    public var funcDescStart: String
    public var funcDescRest: String
    public var funcPara: String
    public var imgSrc: String

}
