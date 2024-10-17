//
//  Todo.swift
//  TodosList
//
//  Created by Ali Haider on 16/10/2024.
//

import Foundation

struct Todo {
    let title: String
    var isCompleted: Bool = false
    
    func completeToggled() -> Todo {
        return Todo(title: title, isCompleted: !isCompleted)
    }
}
