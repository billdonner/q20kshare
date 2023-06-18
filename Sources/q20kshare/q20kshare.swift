import Foundation
public struct q20kshare {
    public private(set) var text = "Q20KSHARE"
    public private(set) var version = "0.0.7"
    public init() {
    }
}

/* Challenge(s) is the basic heart of q20k world */

public struct AIReturns: Codable,Equatable,Hashable {
 public init(question: String, topic: String, hint: String, answers: [String], correct: String, explanation: String? = nil, article: String? = nil, image: String? = nil) {
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

   public func toChallenge() -> Challenge {
      Challenge(question: self.question, topic: self.topic, hint:self.hint, answers:self.answers, correct: self.correct,id:UUID().uuidString,date:Date())
  }
}
public struct Challenge : Codable,Equatable,Hashable  {
  public init(question: String, topic: String, hint: String, answers: [String], correct: String, explanation: String? = nil, article: String? = nil, image: String? = nil, id: String? = nil, date: Date? = nil, opinions:[Opinion] = []) {
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
  public let id:String? // can be real uuid
  public let date:Date? // hmmm
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
public struct AIOpinion: Codable,Equatable,Hashable {
  public let id:String
  public let truth:String
  public let explanation:String
  
  public func toOpinion() -> Opinion{
    Opinion(id:id,truth:truth,explanation: explanation,source:"GPTBleeBlah")
  }
}

public struct Opinion : Codable, Equatable, Hashable {
  public  init(id: String, truth: String, explanation: String, source: String) {
    self.id = id
    self.truth = truth
    self.source = source
    self.explanation = explanation
    self.generated = Date()
  }

  public let id:String
  public let truth:String
  public let explanation:String
  public let source:String
  public let generated:Date
  
}

