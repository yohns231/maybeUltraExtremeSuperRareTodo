/*
 Version : alpha 1_0_1
 Date : 2025-01-17(Fri)
 Contents : insert, select, select all, update, delete
 */

import Foundation
import SwiftData

@Model
final class User {
    private var Bool_printDebug: Bool = true
    private var Bool_printError: Bool = true
    
    private var UUID_userId: UUID
    private var Str_userName: String
    
    init() {
        self.UUID_userId = UUID()
        self.Str_userName = ""
    }
    
    //insert
    public func insertUserData(context: ModelContext,UUID_userId : UUID, userName : String) -> Bool {
        let result = Func_Main_insertData(context: context, UUID_userId: UUID_userId, userName: userName)
        return result
    }
    
    private func Func_Main_insertData(context: ModelContext,UUID_userId : UUID, userName : String) -> Bool {
        self.UUID_userId = UUID_userId
        self.Str_userName = userName
        
        do {
            context.insert(self)
            try context.save()
            return true
        }
        catch {
            Func_print("Insert Error : \(error)",1)
            return false
        }
    }
    
    //select
    public func selectUserData(context: ModelContext, userName: String) -> [[String: Any]] {
        let result = Func_Main_selectData(context: context, userName: userName)
        return result
    }
    
    public func selectAllUserData(context: ModelContext) -> [[String: Any]] {
        let result = Func_Main_selectAllData(context: context)
        return result
    }
    
    private func Func_Main_selectAllData(context: ModelContext) -> [[String: Any]] {
        let descriptor = FetchDescriptor<User>()
        
        do {
            let allUserData = try context.fetch(descriptor)
            return Func_incodeData(decodeData: allUserData)
        }
        catch {
            Func_print("Fetching all users error: \(error)", 1)
            return []
        }
    }
    
    private func Func_selectId(context: ModelContext, userId: UUID) -> [[String: Any]] {
        let descriptor = FetchDescriptor<User>(predicate: #Predicate<User> {
            $0.UUID_userId == userId
        })
        
        do {
            if let userData = try context.fetch(descriptor).first {
                return Func_incodeData(decodeData: [userData])
            }
            else {
                Func_print("No found id: \(userId)")
                return []
            }
        }
        catch {
            Func_print("Id fetching error: \(error)")
            return []
        }
    }
    
    
    
    private func Func_Main_selectData(context: ModelContext, userName: String) -> [[String: Any]] {
        let descriptor = FetchDescriptor<User>(predicate: #Predicate<User> {
            $0.Str_userName.contains(userName)
        })
        
        do {
            if let userData = try context.fetch(descriptor).first {
                return Func_incodeData(decodeData: [userData])
            }
            else {
                Func_print("No found name: \(userName)")
                return []
            }
        }
        catch {
            Func_print("userName fetching error: \(error)",1)
            return []
        }
    }
    
    //update
    public func updateUserData(context: ModelContext, userId: UUID, newName: String) -> Bool {
        let result = Func_Main_updateData(context: context, userId: userId, newName: newName)
        return result
    }
    
    private func Func_Main_updateData(context: ModelContext, userId: UUID, newName: String) -> Bool {
        if var userData = Func_selectId(context: context, userId: userId).first {
            userData["userName"] = newName
            
            do {
                try context.save()
                Func_print("Update Suceess to: \(newName)")
                return true
            }
            catch {
                Func_print("Update Error : \(error)", 1)
                return false
            }
        }
        else { return false}
    }
    
    //delete
    public func deleteUserData(context: ModelContext, userId: UUID) -> Bool {
        let result = Func_Main_deleteData(context: context,userId: userId)
        return result
    }
    
    private func Func_Main_deleteData(context: ModelContext,userId: UUID) -> Bool {
        let descriptor = FetchDescriptor<User>(predicate: #Predicate<User> {
            $0.UUID_userId == userId
        })
        do {
            if let userData = try context.fetch(descriptor).first {
                context.delete(userData)
                try context.save()
                return true
            }
            else {
                Func_print("No found name: \(userId)")
                return false
            }
        }
        catch { Func_print("userName deletion error: \(error)",1)
            return false
        }
        
    }
    
    //subFunction
    private func Func_incodeData(decodeData: [User]) ->  [[String: Any]] {
        do {
            var UUID_incodeUserId: UUID
            var Str_incodeUserName: String
            var List_incodeResult = [[String: Any]]()
            
            for data in decodeData {
                UUID_incodeUserId = data.UUID_userId
                Str_incodeUserName = data.Str_userName
                let Dic_incodeResult: [String: Any] = [
                    "UUID_userId": UUID_incodeUserId,
                    "Str_userName": Str_incodeUserName
                ]
                
                List_incodeResult.append(Dic_incodeResult)
            }
            return List_incodeResult
        }
    }
    
    private func Func_print(_ text: String, _ type: Int = 0) {
        if type == 0 && Bool_printDebug {
            print(text)
        }
        
        else if type == 1 && Bool_printError {
            print(text)
        }
    }
}


