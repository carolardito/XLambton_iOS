//
//  EncryptDecrypt.swift
//  XLambton
//
//  Created by user143339 on 8/16/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import Foundation

//public class EncryptDecrypt {
    
    let primeNumber: Array<String> = ["2", "3", "5", "7", "11", "13", "17", "19", "23", "29", "31", "37", "41", "43", "47", "53", "59", "61", "67", "71", "73", "79", "83", "89", "97", "101", "@", "."]
    let alphabet: Array<Character> = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "@", "."]
    let number: Array<Character> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    let numberEncrypt: Array<Character> = ["A", "C", "E", "G", "I", "K", "M", "O", "Q", "S"]
    
    //public func encrypt(line: String) -> String{
    func encrypt(agent: Agent) -> Agent {
        //var splitLine: [String]
        var name, country, date, email, mission/*agency*/ : String
        var nameEncrypt = "", emailEncrypt = "", missionEncrypt = "", countryEncrypt = "", dateEncrypt = ""/*, agencyEncrypt = ""*/
        var aux: Character
    
        if (agent != nil) {
            name = agent.name.uppercased()
            country = String(agent.country)//.uppercased()
            email = agent.email.uppercased()
        }else {
            return Agent(id: -1, name: "", country: "", email: "", mission: [])
        }
    
        //NAME
        var i = 0
        for nome in name {
            aux = nome
            
            var x = 0
            for letterarray in alphabet {
                var help = 0
                var y = 0
                for nbo in number {
                    if (aux == nbo) {
                        nameEncrypt += String(numberEncrypt[y]) + "/"
                        help = 1
                        break
                    }
                    y += 1
                }
    
                if (help == 1) {
                    help = 0
                    break
                }
    
                if (aux == letterarray) {
                    nameEncrypt += String(primeNumber[x]) + "/"
                    break
                }else if (aux == (" ")) {
                    nameEncrypt += "#/"
                    break
                }
                x += 1
            }
            i += 1
        }
        
        //EMAIL
        i = 0
        for part in email {
            aux = part
            var x = 0
            
            for letterarray in alphabet {
                var help = 0
                var y = 0
                for nbo in number {
                    if (aux == nbo) {
                        emailEncrypt += String(numberEncrypt[y]) + "/"
                        help = 1
                        break
                    }
                    y += 1
                }
                
                if (help == 1) {
                    help = 0
                    break
                }
                
                if (aux == letterarray) {
                    emailEncrypt += String(primeNumber[x]) + "/"
                    break
                }else if (aux == (" ")) {
                    emailEncrypt += "#/"
                    break
                }
                x += 1
            }
            i += 1
        }
        
        //COUNTRY
        i = 0
        for pais in country {
            aux = pais
    
            var x = 0
            for letterarray in alphabet {
                var help = 0
                var y = 0
                for nbo in number {
                    if (aux == nbo) {
                        countryEncrypt += String(numberEncrypt[y]) + "/"
                        help = 1
                        break
                    }
                    y += 1
                }
    
                if (help == 1) {
                    help = 0
                    break
                }
    
                if (aux == letterarray) {
                    countryEncrypt += String(primeNumber[x]) + "/"
                    break
                }else if (aux == (" ")) {
                    countryEncrypt += "#/"
                    break
                }
                x += 1
            }
            i += 1
        }
    
        //MISSION
        i = 0
        mission = agent.mission[0].mission.uppercased()
        for tipoMissao in mission {
            aux = tipoMissao
            
            var x = 0
            for letterarray in alphabet {
                var help = 0
                var y = 0
                for nbo in number {
                    if (aux == nbo) {
                        missionEncrypt += String(numberEncrypt[y]) + "/"
                        help = 1
                        break
                    }
                    y += 1
                }
                
                if (help == 1) {
                    help = 0
                    break
                }
                
                if (aux == letterarray) {
                    missionEncrypt += String(primeNumber[x]) + "/"
                    break
                }else if (aux == (" ")) {
                    missionEncrypt += "#/"
                    break
                }
                x += 1
            }
        }
        
        //DATE
        i = 0
        date = agent.mission[0].date
        for dt in date {
            aux = dt
            var y = 0
            for nbo in number {
                if (aux == nbo) {
                    dateEncrypt += String(numberEncrypt[y])
                    break
                }
                y += 1
            }
            i += 1
        }
    
        var agentReturn = Agent(id: agent.id, name: nameEncrypt, country: countryEncrypt, email: emailEncrypt, mission: [Mission(id: agent.mission[0].id, idAgent: agent.id, date: dateEncrypt, mission: missionEncrypt)])
        return agentReturn
    }
    
    func decrypt(agent: Agent) -> Agent {
        //var splitLine[String]
        var name, mission, country, date, email/*, agency*/ : String
        var nameEncrypt = "", missionEncrypt = "", countryEncrypt = "", dateEncrypt = "", emailEncrypt = ""/*, agencyEncrypt = ""*/
        var aux: Character
    
        if (agent != nil) {
            name = agent.name.uppercased()
            country = agent.country.uppercased()
            email = agent.email.uppercased()
        }else {
            return Agent(id: -1, name: "", country: "", email: "", mission: [])
        }
    
        //NAME
        var i = 0
        var arrayName = name.components(separatedBy: "/")
        for nome in arrayName {
            //aux = nome
            var x = 0
            for primo in primeNumber {
                var help = 0
                var y = 0
                for nbo in numberEncrypt {
                    if (nome == String(nbo)) {
                        nameEncrypt += String(number[y])
                        help = 1
                        break
                    }
                    y += 1
                }
    
                if (help == 1) {
                    help = 0
                    break
                }
    
                if (nome == (primo)) {
                    nameEncrypt += String(alphabet[x])
                    break
                }else if (nome == ("#")) {
                    nameEncrypt += " "
                    break
                }
                x += 1
            }
            i += 1
        }
        
        //EMAIL
        i = 0
        var arrayEmail = email.components(separatedBy: "/")
        for mail in arrayEmail {
            //aux = mail
            var x = 0
            for primo in primeNumber {
                var help = 0
                var y = 0
                for nbo in numberEncrypt {
                    if (mail == String(nbo)) {
                        emailEncrypt += String(number[y])
                        help = 1
                        break
                    }
                    y += 1
                }
                
                if (help == 1) {
                    help = 0
                    break
                }
                
                if (mail == (primo)) {
                    emailEncrypt += String(alphabet[x])
                    break
                }else if (mail == ("#")) {
                    emailEncrypt += " "
                    break
                }
                x += 1
            }
            i += 1
        }
    
        //COUNTRY
        i = 0
        var arrayCountry = country.components(separatedBy: "/")
        for pais in arrayCountry {
            //aux = pais
            var x = 0
            //for (int x = 0; x < primeNumber.length; x++) {
            for primo in primeNumber {
                var help = 0
                var y = 0
                //for (int y = 0; y < numberEncrypt.length; y++) {
                for nbo in numberEncrypt {
                    if (pais == String(nbo)) {
                        countryEncrypt += String(number[y])
                        help = 1
                        break
                    }
                    y += 1
                }
    
                if (help == 1) {
                    help = 0
                    break
                }
    
                if (pais == (primo)) {
                    countryEncrypt += String(alphabet[x])
                    break
                }else if (pais == ("#")) {
                    countryEncrypt += " "
                    break
                }
                x += 1
            }
            i += 1
        }
    
        //MISSION
        i = 0
        mission = agent.mission[0].mission.uppercased()
        var arrayMission = mission.components(separatedBy: "/")
        
        //for (int size = 0; size < splitMission.length; size++) {
            //aux = splitMission[size]
            //for (int x = 0; x < primeNumber.length; x++) {
        for tipoMissao in arrayMission {
            //aux = tipoMissao
            var x = 0
            for primo in primeNumber {
                /*var help = 0
                var y = 0
                //for (int y = 0; y < numberEncrypt.length; y++) {
                for nbo in number {
                    if (tipoMissao == String(nbo)) {
                        missionEncrypt += String(number[y])
                        help = 1
                        break
                    }
                    y += 1
                }
                
                if (help == 1) {
                    help = 0
                    break
                }*/
                
                if (tipoMissao == (primo)) {
                    missionEncrypt += String(alphabet[x])
                    break
                }else if (tipoMissao == ("#")) {
                    missionEncrypt += " "
                    break
                }
                x += 1
            }
            i += 1
        }
        
        //DATE
        i = 0
        date = agent.mission[0].date
        for dt in date {
            aux = dt
            var y = 0
            for nbo in numberEncrypt {
                if (aux == nbo) {
                    dateEncrypt += String(number[y])
                    break
                }
                y += 1
            }
            i += 1
        }
        var agentReturn = Agent(id: agent.id, name: nameEncrypt, country: countryEncrypt, email: emailEncrypt, mission: [Mission(id: agent.mission[0].id, idAgent: agent.id, date: dateEncrypt, mission: missionEncrypt)])
        return agentReturn
    }
//}
