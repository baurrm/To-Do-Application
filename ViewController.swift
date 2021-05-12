//
//  ViewController.swift
//  ToDoApp
//
//  Created by Bauyrzhan Marat on 21.04.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let table: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self,
                    forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String()]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
        title = "To Do App"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self, action: #selector(didTapAdd))
    }
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Task", message: "Enter new to do task!", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter task..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    
                    //Enter new to do list task
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "tasks") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "tasks")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    
}

