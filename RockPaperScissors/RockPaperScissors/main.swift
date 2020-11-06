//
//  RockPaperScissors - main.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

// 게임 시작시 고정 출력문
let gameStartString: [String : String] = [
    "SRP" : "가위(1), 바위(2), 보(3)! <종료: 0> : ",
    "RSP" : "묵(1), 찌(2), 빠(3)! <종료: 0> : "
]

// error 메시지
enum ErrorMessage : String {
    case errorSystem = "시스템 에러로 인해 다시 시도해주세요."
    case errorInput = "잘못된 입력입니다. 다시 시도해주세요."
    case exit = "게임을 종료합니다."
}

// 손 상태
enum HandStatus {
    case rock, scissor, paper
}

enum GameStatus : String {
    case user = "사용자"
    case computer = "컴퓨터"
    // 비겼음
    case draw
}

struct GamersStatus {
    var computerHand: HandStatus?
    var userHand: HandStatus?
    var gameTurn: GameStatus?
    
    init(computerHand: HandStatus?, userHand: HandStatus?, gameTurn: GameStatus?) {
        self.computerHand = computerHand
        self.userHand = userHand
        self.gameTurn = gameTurn
    }
}

// 턴의 주체를 반환하는 것이 아닌, 턴의 주체를 분기 태워서 그에 해당하는 턴 String을 return합니다:) -> 묵찌빠 게임 시작시 [***턴] 묵(1), 찌(2)... 이떄 사용
func turnMessage(currnetGameTurn: GameStatus) -> String {
    switch currnetGameTurn {
    case .computer:
        return "[컴퓨터 턴] "
    case .user:
        return "[사용자 턴] "
    default:
        return ""
    }
}

func winMessage(currnetGameTurn: GameStatus) -> String {
    switch currnetGameTurn {
    case .computer:
        return "컴퓨터의 승리!"
    case .user:
        return "사용자의 승리!"
    default:
        return ""
    }
}

func nextTurnMessage(nextTurn: GameStatus) -> String {
    switch nextTurn {
    case .computer:
        return "컴퓨터의 턴입니다"
    case .user:
        return "사용자의 턴입니다"
    default:
        return ""
    }
}

func game(user: HandStatus, computer: HandStatus) -> GameStatus {
    if user == computer {
        return GameStatus.draw
    }
    
    switch user {
    case .rock:
        if computer == .paper {
            return GameStatus.computer
        }
        return GameStatus.user
    case .scissor:
        if computer == .rock {
            return GameStatus.computer
        }
        return GameStatus.user
    case .paper:
        if computer == .scissor {
            return GameStatus.computer
        }
        return GameStatus.user
    }
}

func SRPNumberToHand(_ number: Int) -> HandStatus? {
    switch number {
    case 1:
        return HandStatus.scissor
    case 2:
        return HandStatus.rock
    case 3:
        return HandStatus.paper
    default:
        return nil
    }
}

func RSPNumberToHand(_ number: Int) -> HandStatus? {
    switch number {
    case 1:
        return HandStatus.rock
    case 2:
        return HandStatus.paper
    case 3:
        return HandStatus.scissor
    default:
        return nil
    }
}

// 가위바위보 게임
func gameSRP(gamersStatus: GamersStatus) -> GamersStatus? {
    var nextGamersStatus = gamersStatus
    while true {
        guard let order = gameStartString["SRP"] else {
            print(ErrorMessage.errorSystem.rawValue)
            continue
        }
        print(order)
        
        // 잘못된 입력이라면 메세지 출력 후 다시 입력 받기
        guard let input = readLine() else {
            print(ErrorMessage.errorInput.rawValue)
            continue
        }
        
        if let number = Int(input),
           number >= 0 && number <= 3 {
            // 게임 종료
            if number == 0 {
                print(ErrorMessage.exit.rawValue)
                return nil
            }
            
            nextGamersStatus.userHand = SRPNumberToHand(number)
            nextGamersStatus.computerHand = SRPNumberToHand(Int.random(in: 1...3))
            
            guard let userHand = nextGamersStatus.userHand,
                  let computerHand = nextGamersStatus.computerHand else {
                // fail convert handstatus
                print(ErrorMessage.errorSystem.rawValue)
                continue
            }
            nextGamersStatus.gameTurn = game(user: userHand, computer: computerHand)
            
            // 비긴 경우는 다시 게임
            if nextGamersStatus.gameTurn == .draw {
                print("비겼습니다!")
                continue
            }
            
            // 이기거나 진 경우는 묵찌빠로 가야하므로 탈출
            if nextGamersStatus.gameTurn == .user {
                print("이겼습니다!")
            }
            else {
                print("졌습니다!")
            }
            return nextGamersStatus
        }
        else {
            print(ErrorMessage.errorInput.rawValue)
        }
    }
    
}

// 묵찌빠 게임
func gameRSP(gamersStatus: GamersStatus) -> GamersStatus? {
    var nextGamersStatus = gamersStatus
    while true {
        guard let order = gameStartString["RSP"],
              let gameTurn = nextGamersStatus.gameTurn else {
            print(ErrorMessage.errorSystem.rawValue)
            continue
        }
        print(turnMessage(currnetGameTurn: gameTurn) + order)
        
        // 잘못된 입력이라면 메세지 출력 후 다시 입력 받기
        guard let input = readLine() else {
            print(ErrorMessage.errorInput.rawValue)
            continue
        }
        
        if let number = Int(input),
           number >= 0 && number <= 3 {
            // 개임 종료
            if number == 0 {
                print(ErrorMessage.exit.rawValue)
                return nil
            }
            
            nextGamersStatus.userHand = RSPNumberToHand(number)
            nextGamersStatus.computerHand = RSPNumberToHand(Int.random(in: 1...3))
            
            guard let userHand = nextGamersStatus.userHand,
                  let computerHand = nextGamersStatus.computerHand,
                  let gameTurn = nextGamersStatus.gameTurn else {
                // fail convert handstatus or gameTurn
                print(ErrorMessage.errorSystem.rawValue)
                continue
            }
            
            let nextTurn = game(user: userHand, computer: computerHand)
            
            if nextTurn == .draw {
                print(winMessage(currnetGameTurn: gameTurn))
                
                // 게임 종료
                return nil
            }
            
            nextGamersStatus.gameTurn = nextTurn
            print(nextTurnMessage(nextTurn: nextTurn))
        }
        else {
            print(ErrorMessage.errorInput.rawValue)
            // 잘못된 입력일 경우 무조건 컴퓨터에게로 턴이 넘어감
            nextGamersStatus.gameTurn = GameStatus.computer
        }
    }
}


func startGame() {
    // 가위바위보 게임
    var game = GamersStatus.init(computerHand: nil, userHand: nil, gameTurn: nil)
    guard let nextGame = gameSRP(gamersStatus: game) else {
        // nil을 받은 경우 -> 게임 종료된 경우
        return
    }
    game = nextGame
    
    guard let lastGame = gameRSP(gamersStatus: game) else {
        // nil을 받은 경우 -> 게임 종료된 경우
        return
    }
    game = lastGame
}

startGame()
