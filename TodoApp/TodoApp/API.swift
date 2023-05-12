import UIKit

func fetchTasks(completion: @escaping ([Todo]?) -> Void) {
    guard let url = URL(string: "http://localhost:8000/tasks") else {
        completion(nil)
        return
    }
    
    let request = URLRequest(url: url)
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        do {
//            let tasks = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let tasks = try JSONDecoder().decode([Todo].self, from: data)
            completion(tasks)
        }
        catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}


func saveTask(id: UUID, title: String, description: String, isCompleted: Bool) {
    guard let url = URL(string: "http://localhost:8000/save-task") else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
    let body: [String: AnyHashable] = [
        "id": "\(id)",
        "title":"\(title)",
        "description": "\(description)",
        "isCompleted": isCompleted
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print("SUCCESS: \(response)")
        }
        catch {
            print(error)
        }
    }
    task.resume()
}

struct Response : Decodable {
    var success: Bool
}

func deleteTask(id: UUID, completion: @escaping (Response?) -> Void) {
    guard let url = URL(string: "http://localhost:8000/delete-task/\(id)") else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONDecoder().decode(Response.self, from: data)
            print("SUCCESS: \(response)")
            completion(response)
        }
        catch {
            print(error)
            completion(nil)
        }
    }
    task.resume()
}
