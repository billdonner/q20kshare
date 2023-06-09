import Foundation
public struct q20kshare {
  public private(set) var text = "Q20KSHARE"
  public private(set) var version = "0.2.15"
  public init() {
  }
}

/* Challenge(s) is the basic heart of q20k world */

public struct AIReturns: Codable,Equatable,Hashable {
  public init(question: String, topic: String, hint: String, answers: [String], correct: String,   explanation: String? = nil, article: String? = nil, image: String? = nil) {
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.correct = correct
    self.explanation = explanation
    self.article = article
    self.image = image 
  }
  
  public let question: String
   
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let article: String?// URL of article about the correct Answer
  public let image:String? // URL of image of correct Answer
  
  public func toChallenge(source:String,prompt:String) -> Challenge {
    Challenge(question: self.question, topic: self.topic, hint:self.hint, answers:self.answers, correct: self.correct,id:UUID().uuidString,date:Date(),source:source,prompt:prompt)
  }
}
public struct Challenge : Codable,Equatable,Hashable  {
  public init(question: String, topic: String, hint: String, answers: [String],
              correct: String, explanation: String? = nil, article: String? = nil, image: String? = nil, id: String = "", date: Date = Date(),source: String = "", prompt:String = "", opinions:[Opinion] = []) {
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.correct = correct
    self.explanation = explanation
    self.article = article
    self.image = image
    self.id = id
    self.date = date
    self.aisource = source
    self.prompt = prompt
    self.opinions = opinions
  }
  
  public let question: String
  public let topic: String
  public let hint:String // a hint to show if the user needs help
  public let answers: [String]
  public let correct: String // which answer is correct
  public let explanation: String? // reasoning behind the correctAnswer
  public let article: String?// URL of article about the correct Answer
  public let image:String? // URL of image of correct Answer
  // these fields are hidden from the ai and filled in by pumper
  public let id:String // can be real uuid
  public let date:Date // hmmm
  public let aisource:String
  public let prompt:String
  public let opinions:[Opinion]
  
  
  public static func decodeArrayFrom(data:Data) throws -> [Challenge]{
    try JSONDecoder().decode([Challenge].self, from: data)
  }
  public static func decodeFrom(data:Data) throws -> Challenge {
    try JSONDecoder().decode( Challenge.self, from: data)
  }
  
}
/* an array of GameData is published to the IOS App */

public struct GameData : Codable, Hashable,Identifiable,Equatable {
  public  init(subject: String, challenges: [Challenge]) {
    self.subject = subject
    self.challenges = challenges //.shuffled()  //randomize
    self.id = UUID().uuidString
    self.generated = Date()
  }
  
  public   let id : String
  public   let subject: String
  public   let challenges: [Challenge]
  public   let generated: Date
}

/** Opinions arrive from multiple ChatBots */
public struct AIOpinion: Codable,Equatable,Hashable,Identifiable {
  public let id:String
  public let truth:Bool
  public let explanation:String
  
  public func toOpinion(source:String) -> Opinion{
    Opinion(id:id,truth:truth,explanation: explanation,opinionID:UUID().uuidString,source:source)
  }
}
public struct AIAltOpinion: Codable,Equatable,Hashable,Identifiable {
  public let id:String
  public let truth:String
  public let explanation:String
  
  public func toOpinion(source:String) -> Opinion?{
    let t = truth.lowercased()
    let q = Bool(t)
    if let q = q {
      return   Opinion(id:id,truth:q,explanation: explanation, opinionID:UUID().uuidString,source:source)
    }
    return nil
  }
}
public struct Opinion : Codable, Equatable, Hashable,Identifiable {
  public  init(id: String, truth: Bool, explanation: String, opinionID:String, source: String) {
    self.id = id
    self.truth = truth
    self.source = source
    self.explanation = explanation
    self.opinionID = opinionID
    self.generated = Date()
  }
  
  public let id:String
  public let truth:Bool
  public let explanation:String
  public let opinionID:String
  public let source:String
  public let generated:Date
  
}
public struct ChatGPTChoice: Codable {
  public  let text: String
}

public struct ChatGPTResponse: Codable {
  public let choices: [ChatGPTChoice]
}


public class ChatContext {
  public init(max:Int, apiKey: String, apiURL: URL, outURL:URL,model: String , verbose: Bool , dots: Bool, dontcall:Bool,comments_pattern:String,split_pattern:String, style:PumpStyle ) {
    self.max = max
    self.apiKey = apiKey
    self.apiURL = apiURL
    self.outURL = outURL
    self.model = model
    self.dots = dots
    self.verbose = verbose
    self.dontcall = dontcall
    self.comments_pattern = comments_pattern
    self.split_pattern = split_pattern
    self.style = style
  }
  
  public var apiKey:String
  public var apiURL: URL
  public var outURL: URL
  public var model: String
  public var verbose: Bool
  public var dots:Bool
  public var dontcall:Bool
  public var comments_pattern:String
  public var split_pattern:String 
  public var style:PumpStyle
  
  public var tag = ""
  public var first = true
  public var max = 1
  public var global_index = 0
  public var pumpCount = 0
  public var badJsonCount = 0
  public var networkGlitches = 0
  public var prompt = ""
  
}
public enum PumpStyle {
  case promptor
  case validator
}


public enum PumpingErrors: Error {
  case badInputURL
  case badOutputURL
  case cantWrite
  case noAPIKey
  case onlyLocalFilesSupported
  case reachedMaxLimit
  case reachedEndOfScript
}

public struct TruthQuery :Codable {
  let id:String
  let question:String
  let answer:String
  let truth:Bool?
}
