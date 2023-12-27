//
//  ConcurrencyService.swift
//  Concurrency
//
//  Created by Maksym Tkachenko on 21.12.2023.
//

import Foundation

class ConcurrencyService {
    
    let safeConcurrentString = SafeConcurrentString()
    
    private let queue1 = DispatchQueue(label: "com.test.TasksExecutor.Task1")
    private let queue2 = DispatchQueue(label: "com.test.TasksExecutor.Task2")
    private let queue3 = DispatchQueue(label: "com.test.TasksExecutor.Task3")
    private let queue4 = DispatchQueue(label: "com.test.TasksExecutor.Task4")
    
    private let data: [Character] = ["A", "B", "C"]
    
    private var currentIndex: Int = 0 {
        didSet {
            startWrite()
        }
    }
    private var readGroup = DispatchGroup()
    
    func start() {
        startWrite()
        startRead()
    }
    
    func startWrite() {
       
        
        queue1.async {
        
            let char = self.data[self.currentIndex]
            self.safeConcurrentString.push(char: char)
            
            print("Task 1 added symbol: \(char)")
            
            self.currentIndex = (self.currentIndex + 1) % self.data.count
        }
    }
    
    func startRead() {
        
        readGroup.enter()
        
        self.queue2.async {
            let ch = self.safeConcurrentString.read()
            print("Task 2 read value: \(ch)")
            
            self.readGroup.leave()
        }
        
        readGroup.enter()
        
        self.queue3.async {
            let ch = self.safeConcurrentString.read()
            print("Task 3 read value: \(ch)")
            
            self.readGroup.leave()
        }
        
        startRemove()
    }
    
    func startRemove() {
        readGroup.notify(queue: self.queue4) {
            let ch = self.safeConcurrentString.removeFirst()
            print("Task 4 removed symbol: \(ch)")
            self.startRead()
        }
    }
}
