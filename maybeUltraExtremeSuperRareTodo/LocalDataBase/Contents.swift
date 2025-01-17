/*
 Version : alpha 1_0_0
 Date : 2025-01-17(Fri)
 Contents : insert, select, update, delete
 */

import Foundation
import SwiftData

@Model
final class Contents {
    private var Bool_printDebug: Bool = true
    private var Bool_printError: Bool = true
    
    
    private var UUID_userId: UUID
    private var UUID_itemId: UUID
    private var Str_titleTodo: String
    private var Str_contentTodo: String
    private var Bool_isDone: Bool
    
    init() {
        self.UUID_userId = UUID()
        self.UUID_itemId = UUID()
        self.Str_titleTodo = ""
        self.Str_contentTodo = ""
        self.Bool_isDone = false
    }
    
    //insert
    public func insertContentData(context: ModelContext, userId: UUID, titleTodo: String, contentTodo: String, isDone: Bool = false) -> Bool {
        let result = Func_Main_insertData(context: context, userId: userId, titleTodo: titleTodo, contentTodo: contentTodo, isDone: isDone )
        return result
    }
    
    private func Func_Main_insertData(context: ModelContext, userId: UUID, titleTodo: String, contentTodo: String, isDone: Bool = false) -> Bool {
        self.UUID_userId = userId
        self.UUID_itemId = UUID()
        self.Str_titleTodo = titleTodo
        self.Str_contentTodo = contentTodo
        self.Bool_isDone = isDone
        
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
    public func selectContentData(context: ModelContext, userId: UUID, contentTodo: String) -> [[String: Any]] {
        let result = Func_Main_selectData(context: context, userId: userId, contentTodo: contentTodo)
        return result
    }
    
    private func Func_selectId(context: ModelContext, userId: UUID, itemId: UUID) -> [[String: Any]] {
        let descriptor = FetchDescriptor<Contents>(predicate: #Predicate<Contents> {
            $0.UUID_userId == userId && $0.UUID_itemId == itemId
        })
        
        do {
            if let userData = try context.fetch(descriptor).first {
                return Func_incodeData(decodeData: [userData])
            }
            else {
                Func_print("No found id: \(itemId)")
                return []
            }
        }
        catch {
            Func_print("Id fetching error: \(error)")
            return []
        }
    }
    
    private func Func_Main_selectData(context: ModelContext, userId: UUID, contentTodo: String) -> [[String: Any]] {
        let descriptor = FetchDescriptor<Contents>(predicate: #Predicate<Contents> {
            $0.UUID_userId == userId && $0.Str_titleTodo.contains(contentTodo)
            })
        
        do {
            if let todoData = try context.fetch(descriptor).first {
                return Func_incodeData(decodeData: [todoData])
            }
            else {
                Func_print("No found name: \(contentTodo)")
                return []
            }
        }
        catch {
            Func_print("userName fetching error: \(error)",1)
            return []
        }
    }
    
    //update
    public func updateUserData(context: ModelContext, userId: UUID, itemId: UUID, newTitle: String, newContent: String) -> Bool {
        let result = Func_Main_updateData(context: context, userId: userId, itemId: itemId, newTitle: newTitle, newContent: newContent)
        return result
    }
    
    private func Func_Main_updateData(context: ModelContext, userId: UUID, itemId: UUID, newTitle: String, newContent: String) -> Bool {
        if var contentData = Func_selectId(context: context,userId: userId, itemId: itemId).first {
            contentData["newTitle"] = newTitle
            contentData["newContent"] = newContent
            
            do {
                try context.save()
                Func_print("Update Suceess to contents")
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
    public func deleteUserData(context: ModelContext, userId: UUID, itemId: UUID) -> Bool {
        let result = Func_Main_deleteData(context: context, userId: userId, itemId: itemId)
        return result
    }
    
    private func Func_Main_deleteData(context: ModelContext, userId: UUID, itemId: UUID) -> Bool {
        let descriptor = FetchDescriptor<Contents>(predicate: #Predicate<Contents> {
            $0.UUID_userId == userId && $0.UUID_itemId == itemId
        })
        do {
            if let contentData = try context.fetch(descriptor).first {
                context.delete(contentData)
                try context.save()
                return true
            }
            else {
                Func_print("No found name: \(userId) or \(itemId)")
                return false
            }
        }
        catch { Func_print("userName deletion error: \(error)",1)
            return false
        }
        
    }
    
    //subFunction
    private func Func_incodeData(decodeData: [Contents]) ->  [[String: Any]] {
        do {
            var UUID_incodeUserId: UUID
            var UUID_incodeItemId: UUID
            var Str_incodeTitleTodo: String
            var Str_incodeContentTodo: String
            var Bool_incodeIsDone: Bool
            
            var List_incodeResult = [[String: Any]]()
            
            for data in decodeData {
                UUID_incodeUserId = data.UUID_userId
                UUID_incodeItemId = data.UUID_itemId
                Str_incodeTitleTodo = data.Str_titleTodo
                Str_incodeContentTodo = data.Str_contentTodo
                Bool_incodeIsDone = data.Bool_isDone
                
                let Dic_incodeResult: [String: Any] = [
                    "UUID_userId": UUID_incodeUserId,
                    "UUID_itemId": UUID_incodeItemId,
                    "Str_titleTodo": Str_incodeTitleTodo,
                    "Str_contentTodo": Str_incodeContentTodo,
                    "Bool_isDone": Bool_incodeIsDone
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


