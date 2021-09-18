//
//  ContentView.swift
//  Json
//
//  Created by Aryaman Puri on 18/09/21.
//

import SwiftUI


struct Todo : Codable, Identifiable {
    // The struct conforms to the Codable protocol to be able to decode the model from the JSON File and the struct conforms to the Identifiable protocol, which allows the items to be listed in a List.
    

    public var id : Int
    public var title : String
    public var completed : Bool
}

class FetchTodo : ObservableObject {
    @Published var todos = [Todo]()
    
    init() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
                    do {
                        if let todoData = data {
                            // 3.
                            let decodedData = try JSONDecoder().decode([Todo].self, from: todoData)
                            DispatchQueue.main.async {
                                self.todos = decodedData
                            }
                        } else {
                            print("No data")
                        }
                    } catch {
                        print("Error")
                    }
                }.resume()

    }
}

@available(iOS 15.0, *)
struct ContentView: View {
    @State var searchText = ""
    @ObservedObject var fetch = FetchTodo()
    var body: some View {
        NavigationView{
        VStack{
            List(fetch.todos) {
                todo in
                VStack(alignment: .leading) {
                    Text(todo.title)
                    Text("\(todo.completed.description)")
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                }
                
            }

            
        }
        .searchable(text: $searchText)
        }
    }
}

@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
