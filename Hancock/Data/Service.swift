//
//  Service.swift
//  Hancock
//
//  Created by Casey Kawamura on 3/31/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import Foundation


class Service {
    
    
    var username: String = ""
    var password: String = ""
    
    //MARK: --CREATE(POST)
    //All these functions are created for adding new entries to the database
     
    //MARK: -- UPDATED AUTH
    func CreateManager(firstName: String, lastName: String, pin: String) {
        //var newTeacher = TeacherStruct(pin: pin, students: [])
        //TODO add to defaults
    }
    
    func CreateStudent(firstName: String, lastName: String, pin: String) {
        //var newStudent = StudentStruct()
        //TOOD add student properties, bind to current teacher
    }
    // func DeleteUser(){} make work for both student and manager
    
    // func DisplayStudentData(){}
    
    static func AttemptLogin(username: String, pin: String) -> Bool{
        //make function work for both manager and student
        //TODO compare passed kvp to defaults in localstorage
        return true
        //TODO if kvp matches segue to app
    }
    //END SECTION
    
    //Upload line accuracy and time to complete
    static func updateCharacterData(localStorage: LocalStorage, teacherName: String, pin: String, studenName: String, session: String, letter: String, score: Int32, timeToComplete: Int32, totalPointsEarned: Int32, totalPointsPossible: Int32){
        
        var tempStorage: LocalStorage = DecodeData()

            // Pass in faults later
        var letterStruct = LetterStruct(letter: letter, tokens: totalPointsEarned, faults: 0)
        
        tempStorage.teachers[teacherName]?.students[studenName]?.sessions[session]?.letter.append(letterStruct)
        
        EncodeData(DataToEncode: tempStorage)
    }
    
    //Function to upload imgs
        
    static func updateImageData(localStorage: LocalStorage, teacherName: String, pin: String, studenName: String, session: String, base64: String, title: String, description: String){
        
        print(base64)
        var tempStorage: LocalStorage = DecodeData()

            if(title == "Free Draw"){
                tempStorage.teachers[teacherName]?.students[studenName]?.sessions[session]?.freeDraw.append(base64)
            }
            else{
                print("This is your data " + title)
                let tempImitation = ImitationStruct(letter: title, image: base64)
                tempStorage.teachers[teacherName]?.students[studenName]?.sessions[session]?.imitation.append(tempImitation)
            }
        
        EncodeData(DataToEncode: tempStorage)
    }
    
    //MARK: --READ(GET)
    //These functions will return a value from the database
    static func getObject(id: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = TimeReport(date: Date(), recentAct: "A", timeInapp: "3m 10s", timeInActs: "3m 10s")
        do{
            let endpoint = "https://abcgoapp.org/api/"+id
            let data = try encoder.encode(test)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
        
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "PUT"
            request.httpBody = data
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    print(error)
                }
            }.resume()
        
        } catch {
            print("Could not encode")
        }
        
    }
    //MARK: --UPDATE(PUT)
    //These will edit an existing entry in the database
    
    
    static func pushData(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let test = TimeReport(date: Date(), recentAct: "A", timeInapp: "3m 10s", timeInActs: "3m 10s")
        do{
            let endpoint = "https://abcgoapp.org/api/users/register"
            let data = try encoder.encode(test)
            guard let url = URL(string: endpoint) else {
                print("Could not set the URL, contact the developer")

                return
                
            }
                //print(String(data: data, encoding: .utf8)!)
        
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            request.httpMethod = "PUT"
            request.httpBody = data
        
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    //Ping(text: error.localizedDescription, style: .danger).show()
                    print(error)
                }
            }.resume()
        
        } catch {
            print("Could not encode")
        }
    }
    
    //MARK: --Destroy(DELETE)
    //These will remove an entry from the database1
    
    //MARK: -- Analytics: TIME
    //static var lastActive = Date() //Need to get it from the DB
    //var timeSinceActive =
    var lastInactive = Date() //Need to get it from the DB
    var lastActiveSession = Date()
    
    static func StartSession(date: Date){
        var lastActive = date
        let timeSinceActive = Date()
        print("Most recent session:",lastActive)
        
    }
    static func TimeSinceActive(lastActive: Date) -> Int32 {
        let currentTime = Date()
        print("Offset:", currentTime.seconds(from: lastActive))
        print("Current Time:", currentTime)
        print("Star Time:", startTime)
        return currentTime.seconds(from: lastActive)
        
    }
    
    //MARK : -- Analyics: ACTIVITY
}

extension Date {
    
    func years(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0)
    }
    func months(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0)
    }
    func days(from date: Date) -> Int32{
        return Int32(Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0)
    }
    func hours(from date: Date) -> Int32{
        return Int32(Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0)
    }
    func minutes(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0)
    }
    func seconds(from date: Date) -> Int32 {
        return Int32(Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0)
    }
}

func EncodeData(DataToEncode: LocalStorage) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    let defaults = UserDefaults.standard
    
    do{
        let data = try encoder.encode(DataToEncode)
        defaults.setValue(data, forKey: "Storage")
    }
    catch{
        print("It Broke")
    }
}

func DecodeData() -> LocalStorage {
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard
    
    do{
        
        let decoded = defaults.data(forKey: String("Storage"))
        print(decoded ?? "did not decode")
        let test = try decoder.decode(LocalStorage.self, from: decoded!)
        return test
    }
    catch{
        var tempStorage: LocalStorage = LocalStorage()
        EncodeData(DataToEncode: tempStorage)
        return tempStorage
    }
}
    
//    func offset(from date: Date) -> Int32 {
        //var time: Int32 = 0
//        if years(from: date) > 0 { return []}
//        if months(from: date) > 0 { return [] }
//        if days(from: date) > 0 {return [] }
//        if hours(from: date) > 0 {time[0] = date.hours(from: lastActive) }
//        if minutes(from: date) > 0 { time[1] = date.minutes(from: lastActive) }
        //if seconds(from: date) > 0 { return date.seconds(from: lastActive) }
//        print(time)
//        return seconds(from: date)
//    }


//extension NSDate {
//    func hour() -> Int{
//
//        //Get Hour
//        let calendar = NSCalendar.currentCalendar()
//        let components = calendar.components(.Hour, fromDate: self)
//        let hour = components.hour
//
//        return hour
//    }
//}



