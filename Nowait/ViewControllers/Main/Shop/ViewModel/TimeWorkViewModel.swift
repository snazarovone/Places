//
//  TimeWorkViewModel.swift
//  Nowait
//
//  Created by Sergey Nazarov on 22.07.2020.
//  Copyright © 2020 Sergey Nazarov. All rights reserved.
//

import Foundation

class TimeWorkViewModel: TimeWorkViewModelType{
    
    var times: String?{
        return getTimeWork()
    }
    
    let timesWork: ([String], [String])
    
    init(timesWork: ([String], [String])){
        self.timesWork = timesWork
    }
    
    private func getTimeWork() -> String?{
        let timeOpen = timesWork.0
        let timeClose = timesWork.1
        let week = ["пн. ", "вт. ", "ср. ", "чт. ", "пт. ", "сб. ", "вс. "]
        
    
        let inFormatter = DateFormatter()
        inFormatter.locale = .current
        inFormatter.dateFormat = "HH:mm"
        inFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var dateOpen: [Date?] = [nil, nil, nil, nil, nil, nil, nil]
        var dateClose: [Date?] = [nil, nil, nil, nil, nil, nil, nil]
        
        for (i, time) in timeOpen.enumerated(){
            let d = inFormatter.date(from: "\(time)")
            dateOpen[i] = d
        }
        
        for (i, time) in timeClose.enumerated(){
            let d = inFormatter.date(from: time)
            dateClose[i] = d
        }
        
        
        if isEqualsTimeMonToFri(dateOpen: dateOpen, dateClose: dateClose){
            
            let dOpen = dateOpen.first!!
            let dClose = dateClose.first!!
            
            var result = "пн-пт. \(inFormatter.string(from: dOpen))-\(inFormatter.string(from: dClose))"
            if dateOpen[5] == dateOpen[6] && dateClose[5] == dateClose[6]{
                if dateOpen[5] == dOpen && dateClose[6] == dClose{
                    result = "пн-вс. \(inFormatter.string(from: dOpen))-\(inFormatter.string(from: dClose))"
                    return result
                }
                let oSut = dateOpen[5]!
                let cSut = dateClose[5]!
                
                result = "\(result)\nсб-вс. \(inFormatter.string(from: oSut))-\(inFormatter.string(from: cSut))"
            }
            return result
        }
        var result = ""
        for (i, open) in dateOpen.enumerated(){
            if let open = open{
                if let close = dateClose[i]{
                    result = "\(result)\(week[i])\(inFormatter.string(from: open))-\(inFormatter.string(from: close))\n"
                }
            }
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func isEqualsTimeMonToFri(dateOpen: [Date?], dateClose: [Date?]) -> Bool{
        
        guard let ddOpen = dateOpen.first, let ddClose = dateClose.first else {return false}
        guard let dOpen = ddOpen, let dClose = ddClose else {return false}
        
        for (i, open) in dateOpen.enumerated(){
            if i != 5 && i != 6{
                if open != dOpen{
                    return false
                }
                if dateClose[i] != dClose{
                    return false
                }
            }
        }
        return true
    }
}
