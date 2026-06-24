
// MARK: - Step 1: Primitives & Variable Declarations
let appName: String = "Swift Task Manager"
var taskCount: Int = 0
let isPremium: Bool = false
let version: Double = 1.0

print("Welcome to \(appName)")
print("Version: \(version)")
print("Tasks: \(taskCount)")

taskCount += 1
print("After adding a task: \(taskCount)\n")

// MARK: - Step 2: Methods & Parameters
func addTask(title name: String, priority level: Int) -> String {
    return "Task '\(name)' added with priority \(level)"
}

let result = addTask(title: "Buy groceries", priority: 2)
print(result)

let greet: (String) -> String = { name in "Hello, \(name)!" }
print(greet("Andrew"))

func applyToTask(task: String, action: (String) -> String) -> String {
    return action(task)
}

let output = applyToTask(task: "Do laundry") { task in
    "Completed: \(task)"
}
print(output)

// MARK: - Step 3: Struct, Class, Protocol

// Protocol (like an interface)
protocol Describable {
    func describe() -> String
}

// Struct — value type
struct Task: Describable {
    let title: String
    var isCompleted: Bool = false

    func describe() -> String {
        let status = isCompleted ? "Done" : "Pending"
        return "[\(status)] \(title)"
    }
}


// Class — reference type, inherits from another class
class TaskManager {
    var tasks: [Task] = []

    func add(task: Task) {
        tasks.append(task)
        print("Added: \(task.title)")
    }

    func showAll() {
        print("\n--- All Tasks ---")
        for task in tasks {
            print(task.describe())
        }
    }
}

// Using them
var task1 = Task(title: "Buy groceries")
var task2 = Task(title: "Do laundry", isCompleted: true)
var task3 = Task(title: "Study Swift")

let manager = TaskManager()
manager.add(task: task1)
manager.add(task: task2)
manager.add(task: task3)
manager.showAll()


// MARK: - Step 4: Imperative Features (loops, conditionals, mutation)

print("\n--- Imperative Features ---")

// For loop
print("\nLooping through tasks:")
for task in manager.tasks {
    print("- \(task.title)")
}

// While loop
var counter = 3
print("\nCountdown:")
while counter > 0 {
    print(counter)
    counter -= 1
}
print("Go!")

// Conditionals + mutation
print("\nCompleting first pending task:")
for i in 0..<manager.tasks.count {
    if !manager.tasks[i].isCompleted {
        manager.tasks[i].isCompleted = true
        print("Marked as done: \(manager.tasks[i].title)")
        break
    }
}

manager.showAll()

// MARK: - Step 5: Extensions & Type Checking

// Extension — adds functionality to an existing type
extension TaskManager {
    func pendingTasks() -> [Task] {
        return tasks.filter { !$0.isCompleted }
    }

    func completedCount() -> Int {
        return tasks.filter { $0.isCompleted }.count
    }
}

print("\n--- Extensions & Type Checking ---")

// Using the extension
let pending = manager.pendingTasks()
print("\nPending tasks: \(pending.count)")
for task in pending {
    print("- \(task.title)")
}

print("Completed: \(manager.completedCount())")

// Type checking — Swift is strongly and statically typed
// This shows optionals (Swift's way of handling nil safely)
var optionalTask: Task? = Task(title: "Optional Task")

if let unwrapped = optionalTask {
    print("\nOptional task exists: \(unwrapped.title)")
} else {
    print("\nNo task found")
}

optionalTask = nil
print("Optional task is now nil: \(optionalTask == nil)")


// MARK: - Phase 2: Interactive Menu

func showMenu() {
    print("\n--- Task Manager Menu ---")
    print("1. Add task")
    print("2. View all tasks")
    print("3. Complete a task")
    print("4. View pending tasks")
    print("5. Exit")
    print("Enter choice: ", terminator: "")
}

print("\n--- Welcome to the Interactive Task Manager ---")

var running = true
while running {
    showMenu()
    if let input = readLine() {
        switch input {
        case "1":
            print("Enter task title: ", terminator: "")
            if let title = readLine(), !title.isEmpty {
                let newTask = Task(title: title)
                manager.add(task: newTask)
            }
        case "2":
            manager.showAll()
        case "3":
            print("Enter task number to complete (1-\(manager.tasks.count)): ", terminator: "")
            if let numStr = readLine(), let num = Int(numStr), num > 0, num <= manager.tasks.count {
                var updatedTask = manager.tasks[num - 1]
                updatedTask.isCompleted = true
                manager.tasks[num - 1] = updatedTask
                print("Marked as done: \(manager.tasks[num - 1].title)")
            } else {
                print("Invalid number")
            }
        case "4":
            let pending = manager.pendingTasks()
            print("\nPending tasks: \(pending.count)")
            for task in pending {
                print("- \(task.title)")
            }
        case "5":
            print("Goodbye!")
            running = false
        default:
            print("Invalid choice, try again")
        }
    }
}

// MARK: - Step 6: Combination, Abstraction, Inheritance & Root Object

// Means of Combination — combining simple types into complex structures
let taskTitles: [String] = ["Exercise", "Read", "Code"]  // Array
let taskPriorities: [String: Int] = ["Exercise": 1, "Read": 2, "Code": 3]  // Dictionary
let taskTuple: (String, Int) = ("Exercise", 1)  // Tuple

print("\n--- Means of Combination ---")
print("Array: \(taskTitles)")
print("Dictionary: \(taskPriorities)")
print("Tuple: \(taskTuple.0) with priority \(taskTuple.1)")

// Abstraction Mechanisms — functions and classes hide complexity
print("\n--- Abstraction Mechanisms ---")
func filterTasks(by keyword: String, from tasks: [Task]) -> [Task] {
    return tasks.filter { $0.title.contains(keyword) }
}
let filtered = filterTasks(by: "laundry", from: manager.tasks)
print("Filtered tasks: \(filtered.map { $0.title })")

// Single Inheritance — PriorityTaskManager inherits from TaskManager
print("\n--- Single Inheritance ---")
class PriorityTaskManager: TaskManager {
    var highPriorityTasks: [Task] = []

    func addHighPriority(task: Task) {
        highPriorityTasks.append(task)
        tasks.append(task)
        print("Added high priority task: \(task.title)")
    }

    func showHighPriority() {
        print("\n--- High Priority Tasks ---")
        for task in highPriorityTasks {
            print(task.describe())
        }
    }
}

let priorityManager = PriorityTaskManager()
priorityManager.addHighPriority(task: Task(title: "Submit final project"))
priorityManager.addHighPriority(task: Task(title: "Pay rent"))
priorityManager.showHighPriority()

// Root Object — all Swift classes are AnyObject
print("\n--- Root Object ---")
let managers: [AnyObject] = [manager, priorityManager]
for m in managers {
    print("Type: \(type(of: m))")
}
