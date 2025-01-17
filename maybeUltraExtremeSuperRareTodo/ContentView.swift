//
//  ContentView.swift
//  maybeUltraExtremeSuperRareTodo
//
//  Created by 고요한 on 1/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var DB_user: [User]
    @Query private var DB_contents: [Contents]
    
    @State var Bool_mainView: Bool = false

    var body: some View {
        if !Bool_mainView {
            Struct_selectUser(Bool_mainView: $Bool_mainView)
        }
        else {
            mainTodo()
        }
    }
}

struct Struct_selectUser: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var DB_user: [User]
    
    @State private var selectedUser:[String:Any] = [:]
    
    @State private var List_allUser: [[String:Any]] = []
    
    @State private var Bool_start: Bool = false
    @State private var Bool_register: Bool = false
    
    @Binding var Bool_mainView: Bool
    
    var body: some View {
        VStack {
            if !Bool_start {
                Button("시작하기!") {
                    List_allUser = loadAllUsers()
                    print(List_allUser)
                    Bool_start = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            else {
                if !Bool_register {
                    Struct_initPage(List_allUser:$List_allUser, Bool_register:$Bool_register, selectedUser: $selectedUser, Bool_mainView: $Bool_mainView)
                }
                else {
                    Struct_registerUser(Bool_register: $Bool_register,List_allUser: $List_allUser)
                }
            }
        }
    }
        
    private func loadAllUsers() -> [[String:Any]] {
        let List_allUser = User().selectAllUserData(context: modelContext)
        return List_allUser
    }
}

struct Struct_initPage: View {
    @Binding var List_allUser : [[String:Any]]
    @Binding var Bool_register : Bool
    @Binding var selectedUser : [String:Any]
    @Binding var Bool_mainView: Bool
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack {
            Text("사용자 목록")
                .font(.headline)
                .padding()
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(List_allUser.indices, id: \.self) { index in
                        HStack {
                            let user = List_allUser[index]
                            Button(action: {
                                selectedUser = user
                            }) {
                                Text(user["Str_userName"] as? String ?? "Unknown")
                            }
                                    
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
            
            HStack {
                Button(action: {
                    Bool_register = true
                }, label: {
                    Text("등록하기")
                })
                Button(action: {
                    deleteUser()
                }, label: {
                    Text("삭제")
                })
                Button(action: {
                    enterMainPage()
                }, label: {
                    Text("선택하기")
                })
                
            }
        }
    }
    
    private func loadAllUsers() -> [[String:Any]] {
        let List_allUser = User().selectAllUserData(context: modelContext)
        return List_allUser
    }
    
    func deleteUser() {
        let _ = User().deleteUserData(context: modelContext, userId: selectedUser["UUID_userId"] as! UUID)
        List_allUser = loadAllUsers()
    }
    
    func enterMainPage() {
        Bool_mainView = true
    }
}

struct Struct_registerUser: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var DB_user: [User]
    
    @State var userName: String = ""
    @Binding var Bool_register: Bool
    @Binding var List_allUser: [[String:Any]]
        
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("사용자 등록")
            TextField("이름을 입력하세요.", text: $userName)
            Button(action: {
                Bool_register = false
                registerUser()
                List_allUser = loadAllUsers()
                dismiss()
            },label: {
                Text("등록")
            })
        }
    }
    
    private func registerUser() {
        let state = User().insertUserData(context: modelContext, UUID_userId: UUID(), userName: userName)
        print(state)
    }
    
    private func loadAllUsers() -> [[String:Any]] {
        let List_allUser = User().selectAllUserData(context: modelContext)
        return List_allUser
    }
}

struct mainTodo: View {
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Contents.self], inMemory: true)
}
