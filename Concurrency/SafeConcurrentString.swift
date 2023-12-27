//
//  SafeConcurrentString.swift
//  Concurrency
//
//  Created by Maksym Tkachenko on 21.12.2023.
//

import Foundation

class SafeConcurrentString {
    private let accessQueue = DispatchQueue.init(label: "com.concurrency.SafeConcurrentString",
                                                 attributes: .concurrent)
    
    private var dataString = ""
    
    func push(char: Character) {
        accessQueue.sync(flags: .barrier) { [weak self] in
          
            self?.dataString.append(char)
        }
    }
    
    func read() -> Character {
        return accessQueue.sync { [weak self] in
            if self?.dataString.count ?? 0 > 0 {
                let char: Character = self?.dataString.first ?? " "
                return char
            } else {
                return " "
            }
        }
    }
    
    func removeFirst() -> Character {
        
        accessQueue.sync(flags: .barrier) { [weak self] in
            
            if self?.dataString.count ?? 0 > 0 {
                let ch = self?.dataString.removeFirst() ?? " "
                
                return ch
            } else {
                
                return " "
            }
        }
    }
}
