import UIKit
import SQLite3

class DBManager {
    
    var db: OpaquePointer?
    
    init(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("XLambton.sqlite")
        
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Agent (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, country TEXT, email TEXT)", nil, nil, nil) != SQLITE_OK {
            /*, phone TEXT*/
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Mission (id INTEGER PRIMARY KEY AUTOINCREMENT, idAgent INTEGER, date TEXT, mission TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Country (id INTEGER PRIMARY KEY, name TEXT, longitude DOUBLE, latitude DOUBLE)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }else{
            popCountries()
        }
    }
    
    func popCountries() {
        var query = "DELETE FROM Country;"
        
        var deleteCountry: OpaquePointer?
        if sqlite3_prepare_v2(db, query, -1, &deleteCountry, nil) == SQLITE_OK {
            if sqlite3_step(deleteCountry) == SQLITE_DONE {
                print("Successfully deleted Country.")
            } else {
                print("Could not delete Country.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteCountry)
        
        /*query = "INSERT INTO Country (id, name, longitude, latitude) VALUES (1, 'Brasil', -47.641, -15.7998);"
        query += "INSERT INTO Country (id, name, longitude, latitude) VALUES (2, 'Canada', -75.6833, 45.4229);"
        query += "INSERT INTO Country (id, name, longitude, latitude) VALUES (3, 'Denmark', 10.1958, 56.1665);"
        query += "INSERT INTO Country (id, name, longitude, latitude) VALUES (4, 'England', -0.1250, 51.5007);"
        query += "INSERT INTO Country (id, name, longitude, latitude) VALUES (5, 'France,' 2.3210, 48.8654);"
        query += "INSERT INTO Country (id, name, longitude, latitude) VALUES (6, 'Japan', 139.6915, 35.6893);"*/
        
        var x = 0
        let c = ["Brasil", "Canada", "Denmark", "England", "France", "Japan"]
        let lon = [-47.641, -75.6833, 10.1958, -0.1250, 2.3210, 139.6915]
        let lat = [-15.7998, 45.4229, 56.1665, 51.5007, 48.8654, 35.6893]
        var insertCountry: OpaquePointer?
        
        while x >= 0 {
            if (x < c.count) {
                query = "INSERT INTO Country (id, name, longitude, latitude) VALUES (\(x+1), '\(c[x])', \(lon[x]), \(lat[x]));"
                
                if sqlite3_prepare_v2(db, query, -1, &insertCountry, nil) == SQLITE_OK {
                    if sqlite3_step(insertCountry) == SQLITE_DONE {
                        print("Successfully insert Country.")
                    } else {
                        print("Could not insert Country.")
                    }
                } else {
                    print("INSERT statement could not be prepared")
                }
                
                x += 1
            } else {
                x = -1
            }
        }
        sqlite3_finalize(insertCountry)
        
    }
    
    func readCountry() -> [Country]{
        var countries: [Country] = []
        var country = Country(id: 0, name: "", longitude: 0, latitude: 0)
        
        let query = "SELECT * FROM Country"
        
        var readCountry:OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &readCountry, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing Select: \(errmsg)")
            return []
        }
        
        while(sqlite3_step(readCountry) == SQLITE_ROW) {
            let id = sqlite3_column_int(readCountry, 0)
            let name = String(cString: sqlite3_column_text(readCountry, 1))
            let longitude = sqlite3_column_double(readCountry, 2)
            let latitude = sqlite3_column_double(readCountry, 3)
            country.id = Int(id)
            country.name = name
            country.longitude = longitude
            country.latitude = latitude
            countries.append(country)
        }
        sqlite3_finalize(readCountry)
        return countries
    }
    
    func readValues() -> [Agent] {
        var agents: [Agent] = []
        
        let queryAgents = "SELECT * FROM Agent"
        
        var readAgent:OpaquePointer?
        
        if sqlite3_prepare(db, queryAgents, -1, &readAgent, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return []
        }
        
        while(sqlite3_step(readAgent) == SQLITE_ROW) {
            let id = sqlite3_column_int(readAgent, 0)
            let name = String(cString: sqlite3_column_text(readAgent, 1))
            let country = String(cString: sqlite3_column_text(readAgent, 2))
            let email = String(cString: sqlite3_column_text(readAgent, 3))
            /*var phone = ""
            if let phoneDB = sqlite3_column_text(readAgent, 4) {
                phone = String(cString: phoneDB)
            }*/
            
            var agent = Agent(id: Int(id), name: name, country: country, email: email, mission: []/*, countryInfo: []*/)
            
            /*CAROL COUNTRY
            let queryCountry = " SELECT * FROM Country WHERE id = \(country)"
            var readCountry: OpaquePointer?
            if sqlite3_prepare(db, queryCountry, -1, &readCountry, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return []
            }
            while (sqlite3_step(readCountry) == SQLITE_ROW) {
                let idCountry = sqlite3_column_int(readCountry, 0)
                let nameCountry = String(cString: sqlite3_column_text(readCountry, 1))
                let longitude = String(cString: sqlite3_column_text(readCountry, 2))
                let latitude = String(cString: sqlite3_column_text(readCountry, 3))
                var countryAdd = Country(id: Int(idCountry), name: nameCountry, longitude: longitude, latitude: latitude)
                agent.countryInfo.append(countryAdd)
            }
            /CAROL COUNTRY*/
            
            let queryMission = " SELECT * FROM Mission WHERE idAgent = \(id)"
            var  readMission: OpaquePointer?
            if sqlite3_prepare(db, queryMission, -1, &readMission, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return []
            }
            while (sqlite3_step(readMission) == SQLITE_ROW) {
                //let mission = String(cString: sqlite3_column_text(stmtMission, 0))
                let idMission = sqlite3_column_int(readMission, 0)
                let idAgent = sqlite3_column_int(readMission, 1)
                let dateMission = String(cString: sqlite3_column_text(readMission, 2))
                let missionType = String(cString: sqlite3_column_text(readMission, 3))
                
                var missionToAppend = Mission(id: Int(idMission), idAgent: Int(idAgent), date: dateMission, mission: missionType)
                agent.mission.append(missionToAppend)
            }
 
            agents.append(agent)
            sqlite3_finalize(readMission)
        }
        sqlite3_finalize(readAgent)
        return agents
    }
    
    
    func save(_ agent: Agent) -> Bool{
        var newAgent = encrypt(agent: agent)
        let id = newAgent.id
        let name = newAgent.name
        let country = newAgent.country
        let email = newAgent.email
        /*let id = agent.id
        let name = agent.name
        let country = agent.country
        let email = agent.email*/
        //let phone = agent.phone
        //let missions = agent.mission
        
        if name.isEmpty {
            return false
        }
        
        // New Agent
        if id == 0 {
            var saveNew: OpaquePointer?
            //let query = "INSERT INTO Agents (name, country, email, phone) VALUES ('\(name)', '\(country)', '\(email)', '\(phone)'"
            let query = "INSERT INTO Agent (name, country, email) VALUES ('\(name)', '\(country)', '\(email)')"
            
            if sqlite3_prepare(db, query, -1, &saveNew, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            //executing the query to insert values
            if sqlite3_step(saveNew) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting Agent: \(errmsg)")
                return false
            }
            
            let queryID = "SELECT last_insert_rowid()"
            
            if sqlite3_prepare(db, queryID, -1, &saveNew, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            if (sqlite3_step(saveNew) == SQLITE_ROW) {
                let id = sqlite3_column_int(saveNew, 0)
                self.save(newAgent.mission/*agent.mission*/, idAgent: id)
            }
            sqlite3_finalize(saveNew)
            
        } else {
            // Update a Agent
            let updateStatementString = "UPDATE Agent SET name = '\(name)', country = '\(country)', email = '\(email)' WHERE id = \(id);"
            
            var updateStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    delete(id)
                    self.save(newAgent.mission,/*agent.mission*/ idAgent: Int32(id))
                    print("Successfully updated row.")
                } else {
                    print("Could not update row.")
                }
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_finalize(updateStatement)
        }
        return true
    }
    
    func save (_ mission: [Mission], idAgent: Int32) {
        var missionInsert: OpaquePointer?

        for x in mission {
            let query = "INSERT INTO Mission (idAgent, date, mission) VALUES (\(idAgent), '\(x.date)', '\(x.mission)')"

            if sqlite3_prepare(db, query, -1, &missionInsert, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            if sqlite3_step(missionInsert) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting Agent: \(errmsg)")
                return 
            }
        }
        sqlite3_finalize(missionInsert)
    }
    
    // delete Mission
    func delete (_ id: Int) {
        let query = "DELETE FROM Mission WHERE idAgent = \(id);"

        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }

        sqlite3_finalize(deleteStatement)
    }
    
    func delete (_ agent: Agent) {
        delete(agent.id)
        let query = "DELETE FROM Agents WHERE id = \(agent.id);"
        
        var deleteAgent: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &deleteAgent, nil) == SQLITE_OK {
            if sqlite3_step(deleteAgent) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteAgent)
    }
}
