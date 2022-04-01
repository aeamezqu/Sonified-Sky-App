/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct stars_coordinates: Identifiable {
  
  var id = UUID()
  var StarID: String = ""
  var Hip: String = ""
  var HD: String = ""
  var HR: String = ""
  var Gliese: String = ""
  var BayerFlamsteed: String = ""
  var ProperName: String = ""
  var RA: String = ""
  var Dec: String = ""
  var Distance: String = ""
  var Mag: String = ""
  var AbsMag: String = ""
  var Spectrum: String = ""
  var ColorIndex: String = ""

  init(raw: [String]) {
    StarID = raw[0]
    Hip = raw[1]
    HD = raw[2]
    HR = raw[3]
    Gliese = raw[4]
    BayerFlamsteed = raw[5]
    ProperName = raw[6]
    RA = raw[7]
    Dec = raw[8]
    Distance = raw[9]
    Mag = raw[10]
    AbsMag = raw[11]
    Spectrum = raw[12]
    ColorIndex = raw[13]

  
  
  }
  
}

func loadCSV(from csvName: String) -> [stars_coordinates] {
  var csvToStruct = [stars_coordinates]()
  
  // locate csv file
  guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
    return[]
  }
  
  //convert the contents of the file into one long string
  var data = ""
  do {
    data = try  String(contentsOfFile: filePath)
  } catch {
    print(error)
    return[]
  }
  
 //split the long string into an array of "rows" of data. Each row is a string
 //detect "/n" carriage return, then split
  var rows = data.components(separatedBy: "\n")
  
  //remove hedeaer rows
  //count the number of header columns before removing
  let columnCount  = rows.first?.components(separatedBy: ",").count
  rows.removeFirst()
  
  //now loop around each row and split into columns
  for row in rows {
    let csvColumns = row.components(separatedBy: ",")
    if csvColumns.count == columnCount {
       let stars_coordinatesStruct = stars_coordinates.init(raw: csvColumns)
       csvToStruct.append(stars_coordinatesStruct)
    }
  }
  
  return csvToStruct
  
}
