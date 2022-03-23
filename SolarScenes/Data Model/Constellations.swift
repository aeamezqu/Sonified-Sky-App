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

enum Constellations: String, CaseIterable {
  
  case Andromeda
  case Antila
  case Apus
  case Ara
  case Aries
  case Auriga
  case Bootes
  case Caelum
  case Camelopardalis
  case Cancer
  case CanesVenatici
  case CanisMajor
  case CanisMinor
  case Capricornus
  case Carina
  case Cassiopeia
  case Centaurus
  case Cepheus
  case Cetus
  case Chamaeleon
  case Circinus
  case Columba
  case ComoBerenices
  case CoronaAustralis
  case CoronaBorealis
  case Corvus
  case Crater
  case Crux
  case Cygnus
  case Delphinus
  case Dorado
  case Draco
  case Equuleus
  case Eridanus
  case Fornax
  case Gemini
  case Grus
  case Hercules
  case Horologium
  case Hydra
  case Hydrus
  case Indus
  case Lacerta
  case Leo
  case LeoMinor
  case Lepus
  case Libra
  case Lupus
  case Lynx
  case Lyra
  case Mensa
  case Microscopium
  case Monoceros
  case Musca
  case Norma
  case Octans
  case Ophiuchus
  case Orion
  case Pavo
  case Pegasus
  case Perseus
  case Phoenix
  case Pictor
  case Pisces
  case PiscisAustrinus
  case Puppis
  case Pyxis
  case Reticulus
  case Sagitta
  case Sagittarius
  case Scorpius
  case Sculptor
  case Scutum
  case Serpens
  case Sextans
  case Taurus
  case Telescopium
  case Triangulum
  case TriangulumAustrale
  case Tucana
  case UrsaMajor
  case UrsaMinor
  case Vela
  case Virgo
  case Volans
  case Vulpecula
  
  
  
  var name: String {
    rawValue.prefix(1).capitalized + rawValue.dropFirst()
  }
}
