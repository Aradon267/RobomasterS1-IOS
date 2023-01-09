//
//  Queue.swift
//  Robomaster
//
//  Created by Arad Donenfeld on 01/10/2022.
//

import Foundation

/// A struct that servers as a Queue.
public struct Queue<T> {
  private var elements: [T] = []
    
    /// The function adds a value to the back of Queue.
    /// - Parameter value: The value to add.
  mutating func enqueue(_ value: T) {
    elements.append(value)
  }
    
    /// The function removes the first element in the Queue and returns it.
    /// - Returns: The value that was removed.
  mutating func dequeue() -> T? {
    guard !elements.isEmpty else {
      return nil
    }
    return elements.removeFirst()
  }
    
    /// Thhe function clears the Queue.
    mutating func clear(){
        elements.removeAll()
    }
    
    /// The function check is the Queue is empty.
    /// - Returns: True if the Queue is empty, false otherwise.
    mutating func isEmpty() -> Bool{
        return elements.isEmpty
    }

  var head: T? {
    return elements.first
  }

  var tail: T? {
    return elements.last
  }
}
