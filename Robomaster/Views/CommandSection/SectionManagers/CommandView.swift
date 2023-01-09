//
//  Command.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 07/10/2022.
//

import SwiftUI
import AlertToast

/// A view that a user can send commands to robot from it.
struct CommandView: View {
    
    @State private var frSpeed: String = ""
    @State private var flSpeed: String = ""
    @State private var blSpeed: String = ""
    @State private var brSpeed: String = ""
    @State private var moveDuration: String = ""
    
    @State private var R: String = ""
    @State private var G: String = ""
    @State private var B: String = ""
    @State private var blinkDuration: String = ""
    
    @State private var customCommand: String = ""
    
    @State private var missingArgs: Bool = false
    @State private var blinkNotInRange: Bool = false
    @State private var speedNotInRange: Bool = false
    @State private var durNotInRange: Bool = false
    
    @State public var commandArr: [Command] = []
    @State var robomaster: RobomasterClass
    var username: String
    var body: some View {
        VStack(){
            
            Group {
                Spacer()
                HStack(){
                    TextField(
                        "FR",
                        text: $frSpeed)
                    
                    TextField(
                        "FL",
                        text: $flSpeed)
                        
                    TextField(
                        "BR",
                        text: $brSpeed)
                        
                    TextField(
                        "BL",
                        text: $blSpeed)
                        
                    TextField(
                        "sc",
                        text: $moveDuration)
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            }
            
            Group {
                HStack{
                    TextField(
                        "R",
                        text: $R)
                    
                    TextField(
                        "G",
                        text: $G)
                        
                    TextField(
                        "B",
                        text: $B)
                        
                    TextField(
                        "sc",
                        text: $blinkDuration)
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(lightGreyColor)
                .cornerRadius(5.0)
                .padding(.bottom, 10)
            }
            
            TextField(
                "Add Custom Command",
                text: $customCommand)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 10)
            Divider()
            
            Group {
                HStack{
                    List{
                        ForEach(self.commandArr, id: \.id) { command in
                            Text(command.command)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    VStack{
                        Button{
                            if(flSpeed.isEmpty || frSpeed.isEmpty || blSpeed.isEmpty || brSpeed.isEmpty || moveDuration.isEmpty){
                                self.missingArgs = true
                            }
                            else{
                                if(!checkRange(min: -101, max: 101, val: flSpeed) || !checkRange(min: -101, max: 101, val: frSpeed) || !checkRange(min: -101, max: 101, val: blSpeed) || !checkRange(min: -101, max: 101, val: brSpeed)){
                                    self.speedNotInRange = true
                                }
                                else if(!checkRange(min: 0, max: 101, val: moveDuration)){
                                    self.durNotInRange = true
                                }
                                else{
                                    let message = "Drive" + "(" + flSpeed + "," + frSpeed + "," + blSpeed + "," + brSpeed + "," + moveDuration + ")"
                                    self.robomaster.addToArr(message: message)
                                    self.commandArr.append(Command(command: message))
                                    self.robomaster.addMove(fl: flSpeed, fr: frSpeed, bl: blSpeed, br: brSpeed, dur: moveDuration)
                                }
                            }
                        } label: {
                            Text("MOVE")
                        }
                        
                        Divider()
                        Button{
                            let message = "Shoot"
                            self.robomaster.addToArr(message: message)
                            self.commandArr.append(Command(command: message))
                            self.robomaster.addShoot()
                        } label: {
                            Text("SHOOT")
                        }
                        Divider()
                        Button{
                            if(R.isEmpty || G.isEmpty || B.isEmpty || blinkDuration.isEmpty){
                                self.missingArgs = true
                            }
                            else{
                                if(!checkRange(min: -1, max: 256, val: R) || !checkRange(min: -1, max: 256, val: G) || !checkRange(min: -1, max: 256, val: B)){
                                    self.blinkNotInRange = true
                                }
                                else if(!checkRange(min: 0, max: 101, val: blinkDuration)){
                                    self.durNotInRange = true
                                }
                                else{
                                    let message = "Blink" + "(" + R + "," + G + "," + B + "," + blinkDuration + ")"
                                    self.robomaster.addToArr(message: message)
                                    self.commandArr.append(Command(command: message))
                                    self.robomaster.addBlink(R: R, G: G, B: B, dur: blinkDuration)
                                }
                            }
                        } label: {
                            Text("BLINK")
                        }
                        Divider()
                        Button{
                            if(customCommand.isEmpty){
                                self.missingArgs = true
                            }
                            else{
                                self.commandArr.append(Command(command: customCommand))
                                self.robomaster.addToArr(message: customCommand)
                                self.robomaster.addCustomScript(script: customCommand)
                            }
                        } label: {
                            Text("CUSTOM")
                        }
                        
                        Spacer()
                    }
                    .frame(width: 125)
                }
            }
            .toast(isPresenting: $missingArgs, alert: {
                AlertToast(type: .error(.red), title: "Missing arguments")
            })
            .toast(isPresenting: $speedNotInRange, alert: {
                AlertToast(type: .error(.red), title: "Speed must be between -100 and 100")
            })
            .toast(isPresenting: $durNotInRange, alert: {
                AlertToast(type: .error(.red), title: "Amount of time must be between 1 and 100")
            })
            .toast(isPresenting: $blinkNotInRange, alert: {
                AlertToast(type: .error(.red), title: "Colors must be between 0 and 255")
            })
            Spacer(minLength: 20)
            Button{
                self.robomaster.clearArr()
                self.commandArr.removeAll()
                self.robomaster.sendMessagesQueue()
                if(self.robomaster.getPermaColor() != "none"){
                    handlePermaLED()
                }
            } label: {
                Text("EXECUTE")
            }
            Spacer(minLength: 100.0)
        }
        .onAppear{
            if((self.robomaster.getQ().head) == nil){
                self.commandArr.removeAll()
                self.robomaster.clearArr()
            }
            else{
                self.commandArr.removeAll()
                for dis in self.robomaster.getArr(){
                    self.commandArr.append(dis)
                }
            }
            if(self.robomaster.permaColor != "none"){
                //self.robomaster.parsePermaColor()
                handlePermaLED()
            }
        }
        .padding()
    }
    
    /// The function will handle what happens if a color was picked in the options.
    func handlePermaLED(){
        let blinkBottom: String = "led_ctrl.set_bottom_led(rm_define.armor_bottom_all, " + self.robomaster.getPermaColor() + ", rm_define.effect_breath)"
        let blinkTop: String = "led_ctrl.set_top_led(rm_define.armor_top_all, " + self.robomaster.getPermaColor() + ", rm_define.effect_breath)"
        let message: String = "Permanent(" + self.robomaster.getPermaColor() + ")"
        var tempLEDQueue = Queue<String>()
        if(self.commandArr.isEmpty){
            self.commandArr.append(Command(command: message))
            self.robomaster.addToArr(message: message)
            self.robomaster.addToMessagesQueue(message: blinkBottom)
            self.robomaster.addToMessagesQueue(message: blinkTop)
        }
        else if(self.commandArr[0].command.contains("Permanent")){
            self.commandArr.remove(at: 0)
            self.commandArr.insert(Command(command: message), at: 0)
            self.robomaster.commandArr.remove(at: 0)
            self.robomaster.commandArr.insert(Command(command: message), at: 0)
            tempLEDQueue.enqueue(blinkBottom)
            tempLEDQueue.enqueue(blinkTop)
            resetQueueContain(temp: tempLEDQueue)
        }
        else{
            tempLEDQueue.enqueue(blinkBottom)
            tempLEDQueue.enqueue(blinkTop)
            self.commandArr.insert(Command(command: message), at: 0)
            self.robomaster.commandArr.insert(Command(command: message), at: 0)
            resetQueue(temp: tempLEDQueue)
        }
    }
    
    /// The function will reset the Queue if it contains a previously picked color
    /// - Parameter temp: The Queue that needs to stay.
    func resetQueueContain(temp: Queue<String>){
        var mutableTemp: Queue<String> = temp
        var tempEventQueue: Queue<String> = self.robomaster.getQ()
        let _ = tempEventQueue.dequeue()
        let _ = tempEventQueue.dequeue()
        while(!tempEventQueue.isEmpty()){
            mutableTemp.enqueue(tempEventQueue.dequeue()!)
        }
        self.robomaster.clearQueue()
        while(!mutableTemp.isEmpty()){
            robomaster.addToMessagesQueue(message: mutableTemp.dequeue()!)
        }
    }
    
    /// The function will reset the Queue if it doesn't contain a previously selected color.
    /// - Parameter temp: The Queue that needs to stay.
    func resetQueue(temp: Queue<String>){
        var mutableTemp: Queue<String> = temp
        var tempEventQueue: Queue<String> = self.robomaster.getQ()
        while(!tempEventQueue.isEmpty()){
            mutableTemp.enqueue(tempEventQueue.dequeue()!)
        }
        self.robomaster.clearQueue()
        while(!mutableTemp.isEmpty()){
            self.robomaster.addToMessagesQueue(message: mutableTemp.dequeue()!)
        }
    }
}

/// The function will check if a given value is within the range of 2 other given values.
/// - Parameters:
///   - min: The minimum value acceptable.
///   - max: The maximum value acceptable.
///   - val: The value to check.
/// - Returns: True if the value is in the given range.
func checkRange(min: Int, max: Int, val: String) -> Bool{
    return min < Int(val)! && max > Int(val)!
}

struct CommandView_Previews: PreviewProvider {
    static var previews: some View {
        CommandView(robomaster: RobomasterClass(ip: "8.7.6.5", port: "12346"), username: "a")
    }
}
