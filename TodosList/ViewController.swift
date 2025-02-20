//
//  ViewController.swift
//  TodosList
//
//  Created by Ali Haider on 16/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var todos = [
        Todo(title: "Make Vanilla icecream"),
        Todo(title: "Put in a freezer"),
        Todo(title: "Eat it in morning")
    ]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    
    @IBSegueAction func todoViewController(_ coder: NSCoder) -> TodoViewController? {
        let viewController = TodoViewController(coder: coder)
        
        if let indexPath  = tableView.indexPathForSelectedRow {
            let todo = todos[indexPath.row]
            viewController?.todo = todo
        }
        
        viewController?.delegate = self
        viewController?.presentationController?.delegate = self
        
        return viewController
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Completed") { action, view, completed in
            print("Completed")
            let todo = self.todos[indexPath.row].completeToggled()
            self.todos[indexPath.row] = todo
            
            let cell = tableView.cellForRow(at: indexPath) as! CheckTableViewCell
            cell.set(checked: todo.isCompleted)
            
            completed(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        
        cell.delegate = self
        
        let todo = todos[indexPath.row]
        
        cell.set(title: todo.title, checked: todo.isCompleted)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let todo = todos.remove(at: sourceIndexPath.row)
        todos.insert(todo, at: destinationIndexPath.row)
    }
    
}

extension ViewController: CheckTableViewCellDelegate {
    
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let todo = todos[indexPath.row]
        
        let newTodo = Todo(title: todo.title, isCompleted: checked)
        todos[indexPath.row] = newTodo
    }
}

extension ViewController: TodoViewControllerDelegate {
    
    func todoViewController(_ viewController: TodoViewController, todo: Todo) {
        dismiss(animated: true) {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //update
                self.todos[indexPath.row] = todo
                self.tableView.reloadRows(at: [indexPath], with: .none)
            } else {
                //add new todo
                self.todos.append(todo)
                self.tableView.insertRows(at: [IndexPath(row: self.todos.count-1 , section: 0) ], with: .automatic)
            }
        }
    }
}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
