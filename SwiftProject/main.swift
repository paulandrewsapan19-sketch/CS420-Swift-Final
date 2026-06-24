// MARK: - Protocol
protocol Describable {
    func describe() -> String
}

// MARK: - Struct (Value Type)
struct Task: Describable {
    let title: String
    var isCompleted: Bool = false
    var priority: String = "None"

    func describe() -> String {
        let status = isCompleted ? "[Done]   " : "[Pending]"
        return "\(status) \(title) | Priority: \(priority)"
    }
}

// MARK: - Class (Reference Type)
class TaskManager {
    var tasks: [Task] = [
        Task(title: "Buy groceries", isCompleted: false, priority: "High"),
        Task(title: "Do laundry", isCompleted: true, priority: "Low"),
        Task(title: "Study Swift", isCompleted: false, priority: "Medium")
    ]

    func add(task: Task) {
        tasks.append(task)
        print("Added: \(task.title)")
    }

    func showAll() {
        print("\n--- All Tasks ---")
        if tasks.isEmpty {
            print("No tasks found.")
        } else {
            for (i, task) in tasks.enumerated() {
                print("\(i + 1). \(task.describe())")
            }
        }
    }
}

// MARK: - Extension
extension TaskManager {
    func pendingTasks() -> [Task] {
        return tasks.filter { !$0.isCompleted }
    }
    func completedCount() -> Int {
        return tasks.filter { $0.isCompleted }.count
    }
}

// MARK: - Single Inheritance
class PriorityTaskManager: TaskManager {
    var highPriorityTasks: [Task] = []

    func addHighPriority(task: Task) {
        highPriorityTasks.append(task)
        tasks.append(task)
    }
}

// MARK: - Add Task Menu (unique: set priority after adding)
func addTaskMenu(manager: TaskManager) {
    var inMenu = true
    while inMenu {
        print("\nEnter task title (or 'back' to return): ", terminator: "")
        if let title = readLine() {
            if title.lowercased() == "back" {
                inMenu = false
            } else if !title.isEmpty {
                // Unique feature: set priority
                print("Set priority for '\(title)':")
                print("1. High")
                print("2. Medium")
                print("3. Low")
                print("Enter choice: ", terminator: "")

                var priority = "None"
                if let p = readLine() {
                    switch p {
                    case "1": priority = "High"
                    case "2": priority = "Medium"
                    case "3": priority = "Low"
                    default: priority = "None"
                    }
                }

                manager.add(task: Task(title: title, priority: priority))
                print("Priority set to: \(priority)")

                print("\n--- What would you like to do next? ---")
                print("1. Add another task")
                print("2. Back to main menu")
                print("Enter choice: ", terminator: "")
                if let next = readLine(), next == "1" {
                    continue
                } else {
                    inMenu = false
                }
            } else {
                print("Title cannot be empty.")
            }
        }
    }
}

// MARK: - View Tasks Menu (unique: delete a task)
func viewTasksMenu(manager: TaskManager) {
    var inMenu = true
    while inMenu {
        manager.showAll()
        print("\n--- What would you like to do? ---")
        print("1. Delete a task")
        print("2. Back to main menu")
        print("Enter choice: ", terminator: "")

        if let next = readLine() {
            switch next {
            case "1":
                print("Enter task number to delete (1-\(manager.tasks.count)): ", terminator: "")
                if let numStr = readLine(), let num = Int(numStr), num > 0, num <= manager.tasks.count {
                    let removed = manager.tasks.remove(at: num - 1)
                    print("Deleted: \(removed.title)")
                    print("\n1. Delete another task")
                    print("2. Back to main menu")
                    print("Enter choice: ", terminator: "")
                    if let again = readLine(), again == "1" {
                        continue
                    } else {
                        inMenu = false
                    }
                } else {
                    print("Invalid number.")
                }
            default:
                inMenu = false
            }
        }
    }
}

// MARK: - Complete Task Menu (unique: undo a completed task)
func completeTaskMenu(manager: TaskManager) {
    var inMenu = true
    while inMenu {
        manager.showAll()
        print("\n--- What would you like to do? ---")
        print("1. Complete a task")
        print("2. Undo a completed task")
        print("3. Back to main menu")
        print("Enter choice: ", terminator: "")

        if let choice = readLine() {
            switch choice {
            case "1":
                print("Enter task number to complete (or 'back'): ", terminator: "")
                if let input = readLine() {
                    if input.lowercased() == "back" { continue }
                    if let num = Int(input), num > 0, num <= manager.tasks.count {
                        if manager.tasks[num - 1].isCompleted {
                            print("Task is already completed.")
                        } else {
                            var updated = manager.tasks[num - 1]
                            updated.isCompleted = true
                            manager.tasks[num - 1] = updated
                            print("Marked as done: \(manager.tasks[num - 1].title)")
                        }
                    } else {
                        print("Invalid number.")
                    }
                }
            case "2":
                // Unique feature: undo completed task
                let completed = manager.tasks.enumerated().filter { $0.element.isCompleted }
                if completed.isEmpty {
                    print("No completed tasks to undo.")
                } else {
                    print("\n--- Completed Tasks ---")
                    for (i, task) in completed {
                        print("\(i + 1). \(task.title)")
                    }
                    print("Enter task number to undo (or 'back'): ", terminator: "")
                    if let input = readLine() {
                        if input.lowercased() != "back",
                           let num = Int(input), num > 0, num <= manager.tasks.count,
                           manager.tasks[num - 1].isCompleted {
                            var updated = manager.tasks[num - 1]
                            updated.isCompleted = false
                            manager.tasks[num - 1] = updated
                            print("Undone: \(manager.tasks[num - 1].title) is now Pending")
                        } else {
                            print("Invalid selection.")
                        }
                    }
                }
            default:
                inMenu = false
            }
        }
    }
}

// MARK: - View Pending Menu (unique: complete directly from pending list)
func viewPendingMenu(manager: TaskManager) {
    var inMenu = true
    while inMenu {
        let pending = manager.pendingTasks()
        print("\n--- Pending Tasks (\(pending.count)) ---")
        if pending.isEmpty {
            print("No pending tasks! All done.")
            inMenu = false
            break
        }
        for (i, task) in pending.enumerated() {
            print("\(i + 1). \(task.title) | Priority: \(task.priority)")
        }

        print("\n--- What would you like to do? ---")
        print("1. Complete a task from this list")
        print("2. Back to main menu")
        print("Enter choice: ", terminator: "")

        if let choice = readLine() {
            switch choice {
            case "1":
                // Unique feature: complete directly from pending list
                print("Enter pending task number to complete (or 'back'): ", terminator: "")
                if let input = readLine() {
                    if input.lowercased() == "back" { continue }
                    if let num = Int(input), num > 0, num <= pending.count {
                        let selectedTitle = pending[num - 1].title
                        if let index = manager.tasks.firstIndex(where: { $0.title == selectedTitle }) {
                            var updated = manager.tasks[index]
                            updated.isCompleted = true
                            manager.tasks[index] = updated
                            print("Marked as done: \(selectedTitle)")
                        }
                    } else {
                        print("Invalid number.")
                    }
                }
            default:
                inMenu = false
            }
        }
    }
}

// MARK: - App Entry Point
let manager = TaskManager()

print("================================")
print("     Swift Task Manager v1.0    ")
print("================================")

var running = true
while running {
    print("\n--- Main Menu ---")
    print("1. Add task")
    print("2. View all tasks")
    print("3. Complete a task")
    print("4. View pending tasks")
    print("5. Exit")
    print("Enter choice: ", terminator: "")

    if let input = readLine() {
        switch input {
        case "1":
            addTaskMenu(manager: manager)
        case "2":
            viewTasksMenu(manager: manager)
        case "3":
            completeTaskMenu(manager: manager)
        case "4":
            viewPendingMenu(manager: manager)
        case "5":
            print("Goodbye!")
            running = false
        default:
            print("Invalid choice, try again")
        }
    }
}
