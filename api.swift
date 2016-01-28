//
//  api.swift
//  COR-Framework-iOS
//
//  Created by denis lavrov on 8/01/16.
//  Copyright © 2016 Denis Lavrov. All rights reserved.
//

import Foundation


public class Message {
    public var atype: String
    public var payload: Any
    
    public init(atype: String, payload: Any) {
        self.atype = atype
        self.payload = payload
    }
    
    
}

public class CORModule {
    private var moduleID: String
    private var produces: [String] = []
    private var consumes: [String: (Message) -> Void] = [:]
    public let networkAdapter: NetworkAdapter
    
    public init(moduleID: String, networkAdapter: NetworkAdapter){
        self.moduleID = moduleID
        self.networkAdapter = networkAdapter
        print("Initiliaizing module with \(moduleID)\n")
    }
    
    public func addTopic(topic: String, handler: (Message) -> Void){
        self.consumes[topic] = handler
    }
    
    public func pong(ping: Message){
        let dict: [String: Any] = ["moduleID": moduleID, "in": self.consumes.keys]
        self.messageOut(Message(atype: "PONG", payload: dict))
    }
    
    public func messageIn(message: Message){
        if let consumer = self.consumes[message.atype] {
            consumer(message)
        }
    }
    
    public func messageOut(message: Message){
        networkAdapter.messageOut(message)
    }
    
}