import SwiftUI

struct Footer: View {
    var todoCount: Int
    @Binding var todos: [Todo]
    
    @State var isCreatePageVisible: Bool = false
    @State var newTaskTitle = ""
    @State var newTaskDescription = ""
    
    var body: some View {
        HStack {
            Spacer()
            Text("\(todoCount) Tasks left")
            Spacer()
            Button(action: {
                isCreatePageVisible.toggle()
            }, label: {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 25, height: 25)
            })
            .popover(isPresented: $isCreatePageVisible) {
                VStack {
                    HStack {
                        Button {
                            self.isCreatePageVisible = false
                        } label: {
                            Text("Cancel")
                        }
                        Spacer()
                        Text("New Task")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Button {
                            todos.append(.init(title: newTaskTitle, description: newTaskDescription))
                            
                            let newTask = todos[todos.count - 1]
                            
                            saveTask(id: newTask.id, title: newTask.title, description: newTask.description, isCompleted: newTask.isCompleted)
                            
                            self.isCreatePageVisible = false
                            self.newTaskTitle = ""
                            self.newTaskDescription = ""
                        } label: {
                            Text("Add Task")
                        }
                    }
                    .padding(.bottom)
                    VStack(alignment: .leading) {
                        Text("Title")
                        TextField("", text: $newTaskTitle)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    VStack(alignment: .leading) {
                        Text("Description")
                        TextEditor(text: $newTaskDescription)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 10.0)
    }
}
