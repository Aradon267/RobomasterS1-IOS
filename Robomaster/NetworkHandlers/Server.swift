//
//  Server.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 01/10/2022.
//
import Network
import Foundation

/// The class handle the connection to the server and sends messages to it.
public class Server{
    private var serverIP: String = ""
    private var serverPort: String = ""
    private var connection: NWConnection
    private var hasConnected: Bool = false
    
    /// Initializes the server.
    /// - Parameters:
    ///   - ip: The server's IP.
    ///   - port: The server's listening port.
    public init(ip: String, port: String){
        self.serverIP = ip
        self.serverPort = port
        let PORT: NWEndpoint.Port = NWEndpoint.Port(self.serverPort)!
        let ipAddress :NWEndpoint.Host = NWEndpoint.Host(self.serverIP)
        let tcp = NWProtocolTCP.Options.init()
        tcp.noDelay = true
        let params = NWParameters.init(tls: nil, tcp: tcp)
        self.connection = NWConnection(to: NWEndpoint.hostPort(host: ipAddress, port: PORT), using: params)
        connection.stateUpdateHandler = { (newState) in

                    switch (newState) {
                    case .ready:
                        print("Socket State: Ready")
                        UserDefaults.standard.set(true, forKey: "isConnected")
                        break
                    case .cancelled:
                        UserDefaults.standard.set(false, forKey: "isConnected")
                        break
                    case .failed:
                        print("Failed")
                        UserDefaults.standard.set(false, forKey: "isConnected")
                        break
                    default:
                        UserDefaults.standard.set(false, forKey: "isConnected")
                        break
                    }
                }
    }
    
    /// The function check if the server is connected.
    /// - Returns: True if connecyed, false otherwise.
    public func isConnected() -> Bool{
        return self.hasConnected
    }
    
    /// The function will close connection with the server.
    /// - Returns: True if disconnected, false if wasn't connected before.
    public func closeConnection() -> Bool{
        if(!isConnected()){
            return false
        }
        self.connection.cancel()
        self.hasConnected = false
        return true
    }
    
    /// The function will start the connection with the server
    /// - Returns: True if managed to connect, false otherwise.
    public func establishConnection() -> Bool{
        let queue = DispatchQueue(label: "TCP Client Queue")
        self.connection.start(queue: queue)
        self.hasConnected = true
        return self.hasConnected
    }
    
    /// The function will send a message to the server.
    /// - Parameter message: The message to send.
    public func sendMSG(message: String) {
        print(message)
        let content: Data = message.data(using: .utf8)!
        self.connection.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
                if (NWError == nil) {
                    print("Data was sent to TCP destination ")
                    
                } else {
                    print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
                }
            })))
        }
}
