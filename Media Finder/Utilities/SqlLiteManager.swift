//
//  SqlLiteManager.swift
//  Media Finder
//
//  Created by Nafea Elkassas on 02/06/2023.
//

import Foundation
import SQLite

class sqlLiteManager {
    
   //MARK: -  Properties
    var database : Connection!
    let tableUser: Table = Table("Users")
    let userData = Expression<Data>("userData" )

    // for saving last played result
    let LastResultTableUser: Table = Table("LastResult")
    let lastCellData = Expression<Data>("lastCellData")
    
    // for saving last search
    let lastSearchResultTable: Table = Table("SearchResultTable")
    let lastSearchSavedString = Expression<String>("SearchResultString")
    
       //MARK: - Singleton
    static let shared = sqlLiteManager()
    
       //MARK: - Setting Connection
    func setConnection(){
        do{
            let docummentationDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let filePath = docummentationDirectory.appendingPathComponent("Users Database").appendingPathExtension("sqlite3")
            let database = try Connection(filePath.path)
            self.database = database
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func createTable(){
        let createTable = self.tableUser.create{table in
              table.column(self.userData)
        }
        do {
            try self.database.run(createTable)
            print("Table added")
        } catch {
            print(error.localizedDescription)
        }
    }
    
// Inserting New User
    func insertUser(user: User,  userData: Data) {
        let insertUser = self.tableUser.insert(self.userData <- userData)
        do {
            try self.database.run(insertUser)
            print("User inserted")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Retrieving User's Data
    func retrieveData() -> [User] {
        var users = [User]()
        do {
            let usersTable = try self.database.prepare(self.tableUser)
            for user in usersTable {
                let userData = user[self.userData]
                let retrievedUser = try JSONDecoder().decode(User.self, from: userData)
                users.append(retrievedUser)
            }
        } catch {
            print(error.localizedDescription)
        }
        return users
    }
}

   //MARK: - For Last Played Media Manipulation
extension sqlLiteManager {
    
    func createLastResultTable(){
        let createTable = self.LastResultTableUser.create{table in
            table.column(self.lastCellData)
        }
        do {
            try self.database.run(createTable)
            print("Table added")
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func insertResult(lastCellRowData: mediaData, lastCellData: Data ){
        let insertResult = self.LastResultTableUser.insert(self.lastCellData <- lastCellData)
        do {
            try self.database.run(insertResult)
            print("User added")

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func retrieveLastResult() -> [mediaData] {
        var lastCellDatas = [mediaData]()
        do {
            let lastData = try self.database.prepare(self.LastResultTableUser)
            for lastOneData in lastData {
                let lastUserData = lastOneData[self.lastCellData]
                let retrievedData = try JSONDecoder().decode(mediaData.self, from: lastUserData)
                lastCellDatas.append(retrievedData)
            }
        } catch {
            print(error.localizedDescription)
        }
        return lastCellDatas
    }
}

extension sqlLiteManager{
    func createLastSearchTable(){
        let createTable = self.lastSearchResultTable.create{table in
            table.column(self.lastSearchSavedString)
        }
        do {
            try self.database.run(createTable)
            print("Table added")
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func insertResult(lastSearch: String){
        let insertSearchResult = self.lastSearchResultTable.insert(self.lastSearchSavedString <- lastSearchSavedString)
        do {
            try self.database.run(insertSearchResult)
            print("User added")

        } catch {
            print(error.localizedDescription)
        }
    }
    
    func retrieveLastSearchResult() -> [String] {
        var lastSearchData = [String]()
        do {
            let lastSearch = try self.database.prepare(self.lastSearchResultTable)
            for lastSearchOneData in lastSearch {
                let lastUserSearch = lastSearchOneData[self.lastSearchSavedString]
                lastSearchData.append(lastUserSearch)
            }
        } catch {
            print(error.localizedDescription)
        }
        return lastSearchData
    }

}

    

