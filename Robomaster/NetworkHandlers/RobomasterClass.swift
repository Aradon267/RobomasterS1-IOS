//
//  RobomasterClass.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 01/10/2022.
//

import Foundation

/// The class handles comunication between the server class and the user.
/// Only using this class the user can connect, and send messages to the server.
public class RobomasterClass{

    private var server: Server
    public var commandArr: [Command]
    public var eventQueue: Queue<String>
    public var permaColor: String
    
    /// Ininitalizes the Robomaster.
    /// - Parameters:
    ///   - ip: IP of the robomaster's server.
    ///   - port: Port of the robomaster's server.
    public init(ip: String, port: String){
        self.server = Server.init(ip: ip, port: port)
        self.commandArr = []
        self.eventQueue = Queue<String>()
        self.permaColor = "none"
    }
    
    /// The function requests establishing connection.
    /// - Returns: True if managed to connect, false otherwise.
    public func establishConnection() -> Bool{
        return self.server.establishConnection()
    }
    
    /// The function will add a message to the commands queue.
    /// - Parameter message: The message to add.
    public func addToMessagesQueue(message: String){
        self.eventQueue.enqueue(message)
    }
    
    /// The function joins the commands queue to one string.
    /// - Returns: The joined commands as a string.
    private func joinMessagesQueue() -> String{
        var currentMessage: String = ""
        var joinedCommands: [String] = []
        while(!self.eventQueue.isEmpty()){
            currentMessage = self.eventQueue.dequeue()!
            joinedCommands.append(currentMessage)
        }
        return joinedCommands.joined(separator: "\n")
    }
    
    /// The function sends a message to the server.
    /// - Parameter message: The message to send.
    private func sendMessage(message: String){
        self.server.sendMSG(message: String(message.count, radix: 2) + message)
    }
    
    /// The function sends the commands queue to the server.
    public func sendMessagesQueue(){
        self.sendMessage(message: self.joinMessagesQueue())
    }
    
    /// The function check if the server is connected.
    /// - Returns: True if connecyed, false otherwise.
    public func isConnected() -> Bool{
        return self.server.isConnected()
    }
    
    /// The function will close connection with the server.
    public func disconnect(){
        var _: Bool = self.server.closeConnection()
    }
    
    /// The function will get the commands queue.
    /// - Returns: The commands queue.
    public func getQ() -> Queue<String>{
        return self.eventQueue
    }
    
    /// The function will clear the commands queue.
    public func clearQueue(){
        self.eventQueue.clear()
    }
    
    /// The function will clear the presented commands array.
    public func clearArr(){
        self.commandArr.removeAll()
    }
    
    /// The function will return the presented commands array.
    /// - Returns: The presented commands array.
    public func getArr() -> [Command]{
        return self.commandArr
    }
    
    /// The function will add a message to the presented commands array.
    /// - Parameter message: The message to add.
    public func addToArr(message: String){
        self.commandArr.append(Command(command: message))
    }
    
    /// The function will add shoot to the commands queue.
    public func addShoot(){
        let ShootFuncName: String = "gun_ctrl.set_fire_count";
        self.addToMessagesQueue(message: ShootFuncName + "(1)")
        self.addToMessagesQueue(message: "gun_ctrl.fire_once" + "()")
    }
    
    /// The function will add move to the commands queue based on given parameters.
    /// - Parameters:
    ///   - fl: The speed of the front-left wheel.
    ///   - fr: The speed of the front-right wheel.
    ///   - bl: The speed of the back-left wheel.
    ///   - br: The speed of the back-right wheel.
    ///   - dur: The duration to move.
    public func addMove(fl: String, fr: String, bl: String, br: String, dur: String){
        let MoveFuncName: String = "chassis_ctrl.set_wheel_speed"
        let EnableAccelerationFuncName: String = "chassis_ctrl.enable_stick_overlay"
        self.addToMessagesQueue(message: MoveFuncName + "(" + fl + "," + fr + "," + bl + "," + br + ")")
        self.addToMessagesQueue(message: EnableAccelerationFuncName + "()")
        self.addToMessagesQueue(message: "time.sleep" + "(" + dur + ")")
        self.addToMessagesQueue(message: "chassis_ctrl.stop()")
    }
    
    /// The function will add blink to the commands queue based on given parameters.
    /// - Parameters:
    ///   - R: R value.
    ///   - G: G value.
    ///   - B: B value.
    ///   - dur: The duration to blink.
    public func addBlink(R: String, G: String, B: String, dur: String){
        let blinkBottom: String = "led_ctrl.set_bottom_led(rm_define.armor_bottom_all, " + R + ", " + G + ", " + B + ", rm_define.effect_breath)"
        let blinkTop: String = "led_ctrl.set_top_led(rm_define.armor_top_all, " + R + ", " + G + ", " + B + ", rm_define.effect_breath)";
        self.addToMessagesQueue(message: blinkBottom);
        self.addToMessagesQueue(message: blinkTop);
        self.addToMessagesQueue(message: "time.sleep" + "(" + dur + ")");
        if(self.permaColor != "none"){
            let blinkBottomPerma: String = "led_ctrl.set_bottom_led(rm_define.armor_bottom_all, " + self.permaColor + ", rm_define.effect_breath)"
            let blinkTopPerma: String = "led_ctrl.set_top_led(rm_define.armor_top_all, " + self.permaColor + ", rm_define.effect_breath)"
            self.addToMessagesQueue(message: blinkBottomPerma);
            self.addToMessagesQueue(message: blinkTopPerma);
        }
    }
    
    /// The function will add a custom script to the commands queue.
    /// - Parameter script: The custom script.
    public func addCustomScript(script: String){
        self.addToMessagesQueue(message: script)
    }
    
    /// The function will set a permanant color.
    /// - Parameter hex: The hex values of the permanant color.
    public func setPermaColor(hex: String){
        self.permaColor = hex
    }
    
    /// The function will parse the hex value of the permanat color to RGB.
    public func parsePermaColor(){
        let rgb = self.getPermaColor()
        let hex0 = rgb[rgb.index(rgb.startIndex, offsetBy: 0)]
        let hex1 = rgb[rgb.index(rgb.startIndex, offsetBy: 1)]
        let redHex: String = String(hex0) + String(hex1)
        let red = String(Int(redHex, radix: 16)!)
        
        let hex2 = rgb[rgb.index(rgb.startIndex, offsetBy: 2)]
        let hex3 = rgb[rgb.index(rgb.startIndex, offsetBy: 3)]
        let greenHex: String = String(hex2) + String(hex3)
        let green = String(Int(greenHex, radix: 16)!)
        
        let hex4 = rgb[rgb.index(rgb.startIndex, offsetBy: 4)]
        let hex5 = rgb[rgb.index(rgb.startIndex, offsetBy: 5)]
        let blueHex: String = String(hex4) + String(hex5)
        let blue = String(Int(blueHex, radix: 16)!)
        
        self.permaColor = red + "," + green + "," + blue
    }
    
    /// The function will return the permanant color.
    /// - Returns: The permanant color, "none" if no such color was set.
    public func getPermaColor() -> String{
        return self.permaColor
    }
}

