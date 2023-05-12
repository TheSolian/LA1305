import SwiftUI

struct ContentView: View {
    @State var todos: [Todo] = []
    @State var isDeleting: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                List() {
                    if (todos.count > 0) {
                        ForEach(todos.indices, id: \.self) { index in
                            let todo = todos[index]
                            
                            HStack {
                                Button {
                                    todos[index].isCompleted.toggle()
                                    
                                    saveTask(id: todos[index].id, title: todos[index].title, description: todos[index].description, isCompleted: todos[index].isCompleted)
                                } label: {
                                    if (todo.isCompleted) {
                                        Image(systemName: "checkmark.circle.fill")
                                    } else {
                                        Image(systemName: "circle")
                                    }
                                }

                                VStack(alignment: .leading) {
                                    Text(todo.title)
                                        .font(.system(size: 20, weight: .bold))
                                    Text(todo.description)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    if (isDeleting) { return }
                                    
                                    isDeleting = true
                                    
                                    deleteTask(id: todos[index].id) { response in
                                        if (response!.success) {
                                            todos.remove(at: index)
                                        }
                                    }
                                    
                                    isDeleting = false
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)

                            }
                            
                        }
                        
                    } else {
                        Text("No Tasks left")

                    }
                }
                .navigationTitle("To Do")
            }
            
            Spacer()
            
            Footer(todoCount: todos.filter { $0.isCompleted == false }.count, todos: $todos)
                .ignoresSafeArea()
        }
        .padding(.bottom, 50)
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear(perform: loadInitialData)
    }
    
    func loadInitialData() {
        fetchTasks { tasks in
            
            if let tasks = tasks {
                self.todos = tasks
            } else {
                
            }
        }
    }
}

struct Todo : Hashable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
