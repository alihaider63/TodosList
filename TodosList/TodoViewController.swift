//
//  TodoViewController.swift
//  TodosList
//
//  Created by Ali Haider on 16/10/2024.
//

import UIKit

protocol TodoViewControllerDelegate: AnyObject {
    func todoViewController(_ viewController: TodoViewController, todo: Todo)
}

class TodoViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var todo: Todo?
    
    weak var delegate: TodoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = todo?.title
        
    }
    
    @IBAction func save(_ button: UIButton) {
        let todo = Todo(title: textField.text!)
        delegate?.todoViewController(self, todo: todo)
    }

}
