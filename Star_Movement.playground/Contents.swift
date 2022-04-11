import Foundation
import Darwin
import PlaygroundSupport
import SwiftUI

// Import Star Data
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
  rows.removeFirst()
  
  //now loop around each row and split into columns
  for row in rows {
    let csvColumns = row.components(separatedBy: ",")
    let stars_coordinatesStruct = stars_coordinates.init(raw: csvColumns)
    csvToStruct.append(stars_coordinatesStruct)
  }
  
  return csvToStruct
}

let starData = loadCSV(from: "StarData_Small")
var names: [String] = []
var right_ascension: [Double] = []
var declination: [Double] = []
for star in starData {
    names.append(star.ProperName)
    right_ascension.append(Double(star.RA)!)
    declination.append(Double(star.Dec)!)
}

// Retrieve current date and time in UTC.
let date = Date()
var calendar = Calendar.current
calendar.timeZone = TimeZone(identifier: "UTC")!
// Assign variables to
var components = calendar.dateComponents([.year], from: date)
let year = components.year
components = calendar.dateComponents([.month],from: date)
let month = components.month
components = calendar.dateComponents([.day],from: date)
let day = components.day
components = calendar.dateComponents([.hour], from: date)
let hour = components.hour
components = calendar.dateComponents([.minute], from: date)
let minute = components.minute
components = calendar.dateComponents([.second], from: date)
let second = components.second

// Count Number of Leap Years
// Rules:
// If a year is not the start of a new century and divisible by four then it is a leap year.
// The year at the turn of a new century is a leap year if it is divisible by 400.
var leapYears: [Int] = []
var leapYearCount: Int = 0
var years = -4712..<year!
let numberofYears = years.count
for i in years {
    if (i < 1582 && abs(i) % 4 == 0) {
        leapYears.append(i)
        leapYearCount += 1
    }
    else if (i > 1582 && i % 100 != 0 && i % 4 == 0) {
        leapYears.append(i)
        leapYearCount += 1
    }
    else if (i > 1582 && i % 100 == 0 && i % 400 == 0) {
        leapYears.append(i)
        leapYearCount += 1
    }
}

// Calculate the number of days between January 1st 4713 BCE to January 1st of the present year.
// Leap Year Rule:
// On a leap year Febuary 29th is added to the calendar and there are 366 days in a year.
// -10 is added to account for 10 "missing days" accounted for from transition from Julian to Gregorian calendar.
let nonLeapYearCount = numberofYears - leapYearCount
let daysBetweenYears = leapYearCount*366 + nonLeapYearCount*365 - 10

// Count number of days from January 1st to current day of year.
var interval = calendar.dateInterval(of: .year, for: date)!
let daysInYear = calendar.dateComponents([.day], from: interval.start, to: date).day!

// calculate fraction of the day that has passed.
let hourFraction: Double = Double(hour!) + (Double(minute!)/Double(60.0)) + (Double(second!)/Double(3600.0))
let dayFraction: Double = hourFraction/Double(24.0)

// Calculate fractional day that has passed since midnight January 1st 4713 BCE in UTC
let totalDays: Double = Double(daysBetweenYears) + Double(daysInYear) + dayFraction

// Calculate Julian Date
// Julian Date begins at noon so we subtract by half a day.
let JD: Double = totalDays - Double(0.5)

// Calculate Julian Centuries from 2000 Jan. 1 12h UT1.
// Calculate Time of day in seconds.
let d: Double = JD - Double(2451545.0)
let T_U: Double = d / Double(36525.0)
let h: Int = hour!
let min: Int = minute!
let s: Int = second!
let t = Double(h)*Double(3600.0) + Double(min)*Double(60.0) + Double(s)
let sidereal_Second_In_Day: Double = 86164.0905

let H_0: Double = Double(24110.54841) + Double(8640184.812866)*T_U + Double(0.093104*pow(T_U, Double(2))) - Double(0.0000062*pow(T_U, Double(3)))
let rotation_Rate: Double = Double(1.00273790935) + Double(5.9*pow(Double(10), Double(-11)))*T_U
let H: Double = H_0 + rotation_Rate*t
let GMST_Seconds: Double = H.truncatingRemainder(dividingBy: Double (86400))
let GMST_Hour = GMST_Seconds / Double(3600)
let sidereal_Minute: Double = Double(60)*GMST_Hour.truncatingRemainder(dividingBy: Double(floor(GMST_Hour)))
let sidereal_Second: Double = Double(60)*sidereal_Minute.truncatingRemainder(dividingBy: Double(floor(sidereal_Minute)))

// Calculate Local Sidereal Time.
// Retrieve observers current latitude and longitude.
// We will use gps corrdinates for this later.
// But first let's just use my current latitude and longitude at ASU.
// Negative latitude will represent southern latitudes.
// Positive longitudes will represent western latitudes.
// Negative longitudes will be interpretated as eastern longitudes.

var latitude: Double = 33.4242
var longitude: Double = 111.9281
if (longitude < 0.0) {
    longitude = 360.0 + longitude
}

// Convert longitude to hours so we can calulate LMST from GMST.
let longitudeHours = longitude / 15.0
var LMST: Double = GMST_Hour - longitudeHours
if (LMST < 0.0) {
    LMST = 24.0 + LMST
}
// Calculate LMST in minutes and seconds
let local_Sidereal_Minute: Double = Double(60)*LMST.truncatingRemainder(dividingBy: Double(floor(LMST)))
let local_Sidereal_Second: Double = Double(60)*local_Sidereal_Minute.truncatingRemainder(dividingBy: Double(floor(local_Sidereal_Minute)))

// Define important constants
let pi: Double = 3.14159265359

// Create function to calculate hour angle, horizon coordinates and spherical coordinates for every star.
// Azmiuth, x and y is undefined in certain cases so the return type is an array of optional doubles.
func starCoordinates(RA: Double, Dec: Double, latitude: Double, LMST: Double) -> [Double?] {
    
    // Convert declination and latitude to radians
    // Angles for sine and cosine functions must be in radians.
    let Dec_radians: Double = Dec*(pi/180)
    let latitude_radians: Double = latitude*(pi/180)
    
    // Calculate the Hour Angle of a star given right ascension.
    var HA: Double = LMST - RA
    if (HA < 0.0) {
        HA = HA + 24.0
    }
    
    //Convert hour angle to degrees and then to radians.
    let HA_degree: Double = 15.0*HA
    let HA_radians: Double = HA_degree * Double(pi/180.0)

    // Calculate Alitude and Azmiuth
    let altitude_radians: Double = asin(sin(Dec_radians)*sin(latitude_radians) + cos(Dec_radians)*cos(latitude_radians)*cos(HA_radians))
    let altitude: Double = altitude_radians * Double(180.0/pi)
    var azmiuth_radians: Double? = nil
    var azmiuth: Double? = nil

    var arguementOne: Double? = nil
    if (altitude_radians == pi/2 || altitude_radians == -pi/2) {
        arguementOne = nil
    }
    else {
        arguementOne = (-sin(HA_radians)*cos(Dec_radians))/cos(altitude_radians)
    }

    var argumentTwo: Double? = nil
    if (altitude_radians == pi/2 || altitude_radians == -pi/2 || latitude_radians == pi/2 || latitude_radians == -pi/2) {
        argumentTwo = nil
    }
    else {
        argumentTwo = (sin(Dec_radians) - (sin(latitude_radians)*sin(altitude_radians)))/(cos(latitude_radians)*cos(altitude_radians))
    }

    if (arguementOne != nil && argumentTwo != nil) {
        if (arguementOne! > 0.0 && argumentTwo! > 0.0) {
            azmiuth_radians = asin(arguementOne!)
            // We could have also done acos(argumentTwo!).
        }
        else if (arguementOne! > 0.0 && argumentTwo! < 0.0) {
            azmiuth_radians = pi - asin(arguementOne!)
            // We could have also done pi - acos(argumentTwo!).
        }
        else if (arguementOne! < 0.0 && argumentTwo! < 0.0) {
            azmiuth_radians = pi - asin(arguementOne!)
            // We could have also done pi + acos(argumentTwo!).
        }
        else if (arguementOne! < 0.0 && argumentTwo! > 0.0) {
            azmiuth_radians = 2*pi + asin(arguementOne!)
            // We could have also done 2*pi - acos(argumentTwo!).
        }
        else if (arguementOne! == 0.0 && argumentTwo! == 1.0) {
            azmiuth_radians = 0.0
        }
        else if (arguementOne! == 1.0 && argumentTwo! == 0.0) {
            azmiuth_radians = pi/2
        }
        else if (arguementOne! == 0.0 && argumentTwo! == -1.0) {
            azmiuth_radians = pi
        }
        else {
            azmiuth_radians = 3*pi/2
        }
    }
    else {
        azmiuth_radians = nil
    }

    if (azmiuth_radians != nil) {
        azmiuth = azmiuth_radians! * (180/pi)
    }
    else {
        azmiuth = nil
    }

    // Conversion to Cartesian Coordinates

    let r: Double = 1000000000000000.0
    var x: Double? = nil
    var y: Double? = nil
    let z: Double = r*cos(pi/2 - altitude_radians)

    if (azmiuth_radians != nil) {
        x = r*cos(azmiuth_radians!)*sin(pi/2 - altitude_radians)
        y = r*sin(azmiuth_radians!)*sin(pi/2 - altitude_radians)
    }
    return [x,y,z,azmiuth,altitude]
}
var positions: [[Double?]] = []
for i in 0...right_ascension.count-1 {
    let RA = right_ascension[i]
    let Dec = declination[i]
    positions.append(starCoordinates(RA: RA, Dec: Dec, latitude: latitude,LMST: LMST))
}
let dt: Double = 1.0
let timer = Timer.scheduledTimer(withTimeInterval: dt, repeats: true) {timer in
    LMST += 1.0/3600.0
    for i in 0...right_ascension.count-1 {
        let RA = right_ascension[i]
        let Dec = declination[i]
        positions[i] = starCoordinates(RA: RA, Dec: Dec, latitude: latitude, LMST: LMST)
        print(positions[0])
    }
}
























