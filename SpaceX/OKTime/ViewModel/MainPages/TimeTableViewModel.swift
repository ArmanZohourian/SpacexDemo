//
//  TimeTableViewModel.swift
//  OKTime
//
//  Created by Arman Zohourian on 11/18/22.
//

import Foundation
import SwiftUI

/// Each view model has a bunch of parameters
/// the request manager and the language ( being used to throw the suitable error)
/// request manager can be used to make the request in do catch block
/// and fills the variables required by that view if successfull
/// otherwise throwing error using , ThrowError function( Should be set to BaseViewModel)
/// Using async and await
class TimeTableViewModel : ObservableObject {
    
    
    var language = LocalizationService.shared.language
    
    @Published var choosenContact = ContactData(id: 0, name: "", phone: "")
    
    @Published var choosenService = SubCategory(serverId: -1,name: "", price: "")
    
    @Published var hasError = false
    
    @Published var errorMessage = ""
    
    @Published var isRequesting = false
    
    @Published var isSuccessfull = false
    
    @Published var isLoaded = false
    
    @Published var selectedDate = Date()
    
    @Published var timeTableReserves = [Reserve]()
    
    var newGeneratedTimeStart : Int = 0
    
    var newGeneratedTimeEnd: Int = 0
    
    
    var dayDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        return df
    }
    
    
    @Published var timeTable : [TimeTable] = [TimeTable]() {
        didSet {
            for shift in timeTable {
                
                for day in shift.weekDay {
                    if day == dayDateFormatter.string(from: selectedDate).uppercased() {
                        print("Day is: \(day)")
                        ////Out of range time table at the start of the shift ( identifier -1 )
                        let outOfTimeGeneratedTimeTableFirstIndex = GeneratedTimeTable(title: "+", time: "", day: "", id: -1, parentId: shift.id, isReserved: nil)
                        generatedTimeTables.append(outOfTimeGeneratedTimeTableFirstIndex)
                        
                        
                        ////Generated time table with the given shift information
                        generateNewTimeTable(with: shift)
                        
                        
                        ////Out of range time table at the end of the shift ( identifier  -2 )
                        let outOfTimeGeneratedTimeTableLastIndex = GeneratedTimeTable(title: "+", time: "", day: "", id: -2, parentId: shift.id, isReserved: nil)
                        
                        generatedTimeTables.append(outOfTimeGeneratedTimeTableLastIndex)
                        
                        
                        //// Appending the shift configuration to the collection
                        let shiftDurationTime = convertToSeconds(with: shift.bookDuration)
                        let shiftEndTime = calculateTimeStamp(with: shift.end)
                        let calculatedEndTime = calculateDateFromTimeStampStr(with: shiftEndTime - shiftDurationTime)
                        
                        
                        generatedTimeTableCollection.append(GeneratedTimeTableCollection(id: nil, generatedTimeTable: generatedTimeTables, startTime: shift.start, duration: shift.bookDuration, endTime: calculatedEndTime, unique: shift.id, name: shift.name))
                        
                        generatedTimeTables = [GeneratedTimeTable]()
                    }
                }
            }
        }
    }
    
    @Published var generatedTimeTables = [GeneratedTimeTable]()
    
    
    
    
    @Published  var generatedTimeTableCollection = [GeneratedTimeTableCollection(id: nil, generatedTimeTable: [GeneratedTimeTable](), startTime: "", duration: "", endTime: "", unique: -100, name: "")]
    
    private var requestManager = RequestManager.shared
    //TimeTables published
    
    //MARK: API call(s)
    func getTimeTables(selectedDate: Date) async {
        
        var dateFormatter: DateFormatter {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }
        
        DispatchQueue.main.async { [weak self] in
                self?.generatedTimeTableCollection = [GeneratedTimeTableCollection]()
        }
        
    
        do {
            let container: TimeTableResult = try await requestManager.perform(GetTimeTable.getTimeTables(selectedDate: dateFormatter.string(from: selectedDate)))

            if container.status {
                DispatchQueue.main.async { [weak self] in
                    for time in container.data.shifts {
                        self?.timeTable = [TimeTable]()
                        self?.timeTable.append(time)
                        self?.isLoaded = true
                        

                    }
                    
                    if let reserves = container.data.books {
                        self?.timeTableReserves = reserves
                    }
                
                }
            }
        } catch {
            
            DispatchQueue.main.async { [weak self] in
                self?.isLoaded = true
                self?.throwError(errorMessage: "Unable to get the timetables")
            }
        }
        
    }
    
    func bookTime(with price: String, choosenTime: GeneratedTimeTable, selectedDate: Date) async {
        
        do {
            
            let container : BookTimeResponse = try await requestManager.perform(BookTime.bookSelectedTime(contactId: String(choosenContact.id), start: choosenTime.time, shiftParentId: String(choosenTime.parentId), serviceId: String(choosenService.serverId), cost: price, date: selectedDayString(date: selectedDate), duration: String(1)))
            
            if container.status {
                
                DispatchQueue.main.async { [weak self] in
                    self?.isSuccessfull = true
                    self?.errorMessage = "book_time_successful".localized(LocalizationService.shared.language)
                }
                
                
                
                
            } else {
                hasError = true
                errorMessage = container.msg ?? ""
            }
            
            print("The container is \(container)")
            
        } catch {
            
            print("Error")
        }
        
    }
    
    func editBookTime(choosenTime: GeneratedTimeTable, selectedDate: Date, selectedTask: Book) async {
        

        
        DispatchQueue.main.async { [weak self] in
            self?.isRequesting = true
            
        }
        
        do {
            
            let container : BookTimeResponse = try await requestManager.perform(EditTask.editSelectedTask(taskId: String(selectedTask.id) ,contactId: String(choosenContact.id), start: choosenTime.time, shiftParentId: String(choosenTime.parentId), serviceId: String(choosenService.serverId), date: selectedDayString(date: selectedDate), duration: String(1)))
            
            DispatchQueue.main.async {[weak self] in
                self?.isRequesting = false
            }
            
            print("The container is \(container)")
            
        } catch {
            
            DispatchQueue.main.async {[weak self] in
                self?.isRequesting = false
            }
            print("Error")
        }
        
    }
    
    
    
    //MARK: Functionalities
    
    ///Generating the timetables beased on the main factors given from the server
    ///1 - Start time
    ///2 - Duration
    ///3 - End time
    ///calculading the timestamp so that we can do some math on the times
    ///adding the duration time stamp to the start time since hit the end time
    ///creating a timetable each time
    private func generateNewTimeTable(with timeTable: TimeTable) {
        
        
        var intStartTs = calculateTimeStamp(with: timeTable.start)
        let intEnd = calculateTimeStamp(with: timeTable.end)
        let intDuration = convertToSeconds(with: timeTable.bookDuration)

        
        let firstSelectedDayName = selectedDateDay()
        
        let firstIndexCalculateTime = calculateDateFromTimeStampStr(with: intStartTs)
        
        let firstGeneratedTimeTable = GeneratedTimeTable(title: timeTable.name, time: firstIndexCalculateTime, day: firstSelectedDayName, id: nil, parentId: timeTable.id, isReserved: nil)
        
        generatedTimeTables.append(firstGeneratedTimeTable)
        
        
        //// Check if the generated shift is already taken from the book response
        ///
        
        while(intStartTs < intEnd) {
            //Append a new array of time table with the
            let calculatedTime = calculateDateFromTimeStampStr(with: intStartTs + intDuration)
            
            let selectedDayName = selectedDateDay()
            
            let newGeneratedTimeTable = GeneratedTimeTable(title: timeTable.name, time: calculatedTime, day: selectedDayName, id: nil, parentId: timeTable.id, isReserved: checkIsReserved(with: calculatedTime))
            
            generatedTimeTables.append(newGeneratedTimeTable)
            
            intStartTs += intDuration
            
        }
        
        let _ =  generatedTimeTables.popLast()
        
        
    }
    
    private func convertToSeconds(with duration: String) -> Int {
        
        let splitedTime = duration.components(separatedBy: ":")
        
        let hour = Int(splitedTime[0])
        
        let minutes = Int(splitedTime[1])
        
        let seconds = Int(splitedTime[2])
        
        let finalTime = (hour! * 3600) + (minutes! * 60) + seconds!
        return finalTime
        
    }
    
    private func calculateTimeStamp(with date: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let calculatedDate = dateFormatter.date(from: date)
        let timeStamp : TimeInterval = calculatedDate!.timeIntervalSince1970
        let calculatedTs = Int(timeStamp)
        
        return calculatedTs
        
        
        
    }
    
    private func calculateDateFromTimeStampStr(with timeStamp: Int) -> String {
        
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        df.locale = Locale(identifier: "En")
        let convertedDate = df.string(from: date)
        return convertedDate
    }
    
    private func calculateTimeOutOfRange(with timeTable: TimeTable) -> Int {
        
        if timeTable.id == -1 {
            
            
            //Minus
            
        } else if timeTable.id == -2 {
            //Add
        }
        return 1
    }
    
    func selectedDateDay() -> String {
        
        //MARK: Date should be fetched
        
        let date = selectedDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: LocalizationService.shared.language == .persian ? "Fa" : "En")
        let dayInWeek = dateFormatter.string(from: date)
        return dayInWeek
        
    }
    
    
    //MARK: Out of range shift
    func generateShiftOutOfRange(with timeTable: GeneratedTimeTable, collection: GeneratedTimeTableCollection) {
        
        
        ////Note
            ///Two cases would happen here
            /// 1 - Adding shift past the end time
            /// 2 - Adding the shift before the start time
            /// if the id is -1 , Then it's case number 2
           /// if the id is -2 , Then it's case number 1
            
        
        if timeTable.id == -1 {
            if let parentTimeTable = generatedTimeTableCollection.firstIndex(where: {
                $0.localId == collection.localId
            }) {
                
                //Getting the fixed start time
                //Getting the fixed duration
                let intStartTime = calculateTimeStamp(with: generatedTimeTableCollection[parentTimeTable].startTime)
                
                let intDuration = convertToSeconds(with: generatedTimeTableCollection[parentTimeTable].duration)
                
           
                //Calculating the new time based on the fixed time and duration
                let calculatedTime = calculateDateFromTimeStampStr(with: intStartTime - intDuration)
                    
                newGeneratedTimeStart = calculateTimeStamp(with: calculatedTime)
                
                //Changing the start start with the new out of range time
                generatedTimeTableCollection[parentTimeTable].startTime = calculatedTime
                   
                //Creating the new shift by the new generated timetable
                let newGeneratedTimeTable = GeneratedTimeTable(title: generatedTimeTableCollection[parentTimeTable].name , time: calculatedTime, day: selectedDateDay(), id: nil, parentId: generatedTimeTableCollection[parentTimeTable].unique, isReserved: nil)
                
                // appending the new generated time at the end of the index 1
                // the reason it is 1 index is because the first index in the + button in UI
                self.generatedTimeTableCollection[parentTimeTable].generateTimeTable.insert(newGeneratedTimeTable, at: 1)
                
                print(parentTimeTable)
            }
        }
        
        else if timeTable.id == -2 {
            if let parentTimeTable = generatedTimeTableCollection.firstIndex(where: {
                $0.localId == collection.localId
            }) {
                
                //Getting the fixed end time
                //Getting the fixed duration
                
                let intEndTime = calculateTimeStamp(with: generatedTimeTableCollection[parentTimeTable].endTime)
                
                let intDuration = convertToSeconds(with: generatedTimeTableCollection[parentTimeTable].duration)
                
                
                //Calculating the new time based on the fixed time and duration
                let calculatedTime = calculateDateFromTimeStampStr(with: intEndTime + intDuration)
                
                
                //Changing the end time with the new out of range time
                newGeneratedTimeStart = calculateTimeStamp(with: calculatedTime)
                
                generatedTimeTableCollection[parentTimeTable].endTime = calculatedTime
                
                //Creating the new shift by the new generated timetable
                let newGeneratedTimeTable = GeneratedTimeTable(title: generatedTimeTableCollection[parentTimeTable].name , time: calculatedTime, day: selectedDateDay(), id: nil, parentId: generatedTimeTableCollection[parentTimeTable].unique, isReserved: nil)
                
                
                // appending the new generated time at the end of the index -1
                // the reason it is -1 index is because the last index in the + button in UI
                self.generatedTimeTableCollection[parentTimeTable].generateTimeTable.insert(newGeneratedTimeTable, at: generatedTimeTableCollection[parentTimeTable].generateTimeTable.endIndex - 1)
            }
            
            
        }
    }
    
    private func checkIsReserved(with startTime: String) -> Bool {
        
        var result = false
        
        
        
        let existingIndex = timeTableReserves.first {
            $0.end == startTime
        }
        
        if let _ = existingIndex {
            return true
        } else {
            return false
        }
        
        for reserve in timeTableReserves {
            if reserve.start == startTime {
                result = true
                break
            } else {
                result = false
            }
        }
        return result
    }
    
    
    private func selectedDayString(date: Date) -> String {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "En")
        return df.string(from: date)
        
    }
    
    private func selectedTimeString(date: Date) -> String {
        
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        df.locale = Locale(identifier: "En")
        return df.string(from: date)
    }
    
    private func throwError(errorMessage: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.hasError = true
            self?.errorMessage = errorMessage ?? "unable_to_conenct_to_server".localized(LocalizationService.shared.language)
        }

    }
    
}
