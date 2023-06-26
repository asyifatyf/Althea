//
//  GameView.swift
//  WorldView
//
//  Created by Theresa Tiffany on 20/06/23.
//

import Foundation
import SpriteKit
import SwiftUI

class CookScene: SKScene {
    
    let game = RealTimeGame.shared
    
    var characterNavigator: SKSpriteNode = SKSpriteNode()
    var characterSupply: SKSpriteNode = SKSpriteNode()
    var characterCook: SKSpriteNode = SKSpriteNode()
    var sceneCamera = SKCameraNode()
    
    var padUp: SKSpriteNode = SKSpriteNode()
    var padDown: SKSpriteNode = SKSpriteNode()
    var padLeft: SKSpriteNode = SKSpriteNode()
    var padRight: SKSpriteNode = SKSpriteNode()
    
    private enum CharacterState {
        case upStop, upRun, rightStop, rightRun, downStop, downRun, leftStop, leftRun
    }
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
        
        characterCook = childNode(withName: "down_stop") as! SKSpriteNode
        characterNavigator = childNode(withName: "down_stop_nav") as! SKSpriteNode
        characterSupply = childNode(withName: "down_stop_sup") as! SKSpriteNode
        sceneCamera = childNode(withName: "sceneCamera") as! SKCameraNode
        
        
        padUp = childNode(withName: "padUp") as! SKSpriteNode
        padUp.setScale(0.05)
        padUp.zPosition = 10
        padDown = childNode(withName: "padDown") as! SKSpriteNode
        padDown.setScale(0.05)
        padDown.zPosition = 10
        padLeft = childNode(withName: "padLeft") as! SKSpriteNode
        padLeft.setScale(0.05)
        padLeft.zPosition = 10
        padRight = childNode(withName: "padRight") as! SKSpriteNode
        padRight.setScale(0.05)
        padRight.zPosition = 10
        
        camera = sceneCamera
        
        if let camera = camera {
            let cameraOffset = CGPoint(x: camera.position.x - size.width / 2 , y: camera.position.y - size.height / 2)
            padUp.position = CGPoint(x: padUp.position.x - cameraOffset.x + 450, y: padUp.position.y - cameraOffset.y + 180)
            padDown.position = CGPoint(x: padUp.position.x - cameraOffset.x - 5, y: padUp.position.y - cameraOffset.y - 50)
            padRight.position = CGPoint(x: padUp.position.x - cameraOffset.x + 20, y: padUp.position.y - cameraOffset.y - 25)
            padLeft.position = CGPoint(x: padUp.position.x - cameraOffset.x - 30, y: padUp.position.y - cameraOffset.y - 25)
        }
//        let zoomInAction = SKAction.scale(to: 0.5, duration: 1)
//        sceneCamera.run(zoomInAction)
        
    }
    
    private enum Direction {
        case up, right, down, left
    }
    
    private var characterState: CharacterState = .upStop {
        didSet {
            updateCharacter()
        }
    }
    
    private func updateCharacter() {
        switch characterState {
        case .upStop:
            characterCook.texture = SKTexture(imageNamed: "up_stop")
        case .upRun:
            characterCook.texture = SKTexture(imageNamed: "up_run")
            
        case .rightStop:
            characterCook.texture = SKTexture(imageNamed: "right_stop")
        case .rightRun:
            characterCook.texture = SKTexture(imageNamed: "right_run")
            
        case .downStop:
            characterCook.texture = SKTexture(imageNamed: "down_stop")
        case .downRun:
            characterCook.texture = SKTexture(imageNamed: "down_run")
            
        case .leftStop:
            characterCook.texture = SKTexture(imageNamed: "left_stop")
        case .leftRun:
            characterCook.texture = SKTexture(imageNamed: "left_run")
            
        }
    }
    
    private func moveCharacter(direction: Direction) {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        switch direction {
            
        case .up:
            yOffset = 20
            game.sendCookData(xPosition: xOffset, yPosition: yOffset)
        case .right:
            xOffset = 20
            game.sendCookData(xPosition: xOffset, yPosition: yOffset)

        case .down:
            yOffset = -20
            game.sendCookData(xPosition: xOffset, yPosition: yOffset)

        case .left:
            xOffset = -20
            game.sendCookData(xPosition: xOffset, yPosition: yOffset)
        }
        
        let moveAction = SKAction.moveBy(x: xOffset, y: yOffset, duration: 0.5)
        characterCook.run(moveAction)
        
        
//        let moveVectorSupply = CGVector(dx: game.supplyPosition.x, dy: game.supplyPosition.y)
//        let moveSupply = SKAction.move(by: moveVectorSupply, duration: 0.5)
//        characterSupply.run(moveSupply)
//
//        let moveVectorNavigator = CGVector(dx: game.navigatorPosition.x, dy: game.navigatorPosition.y)
//        let moveNavigator = SKAction.move(by: moveVectorNavigator, duration: 0.5)
//        characterNavigator.run(moveNavigator)
        
        NSLog("xOffset: %f, yOffset: %f", Double(xOffset), Double(yOffset))
    }
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        
        for node in touchedNodes {
            switch node.name {
            case "padUp":
                moveCharacter(direction: .up)
                characterState = .upRun
                
//                let position = characterCook.position
//                game.sendCookData(position: position)
//                print(position)

            case "padRight":
                moveCharacter(direction: .right)
                characterState = .rightRun
                
//                let position = characterCook.position
//                game.sendCookData(position: position)
//                print(position)


            case "padDown":
                moveCharacter(direction: .down)
                characterState = .downRun
                
//                let position = characterCook.position
//                game.sendCookData(position: position)
//                print(position)


            case "padLeft":
                moveCharacter(direction: .left)
                characterState = .leftRun
                
//                let position = characterCook.position
//                game.sendCookData(position: position)
//                print(position)


            default:
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        handleTouch(touches)
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        handleTouch(touches)
        
    }
    
//    override func didFinishUpdate() {
////        let navigatorAction = SKAction.moveBy(x: game.navigatorXPosition, y: game.navigatorYPosition, duration: 0.5)
////        characterNavigator.run(navigatorAction)
////
////        let supplyAction = SKAction.moveBy(x: game.supplyXPosition, y: game.supplyYPosition, duration: 0.5)
////        characterSupply.run(supplyAction)
//    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let offsetcamX = characterCook.position.x - size.width / 2
        let offsetcamY = characterCook.position.y - size.height / 2
        
        // Adjust the camera's position to follow the characterImage
        camera?.position.x += offsetcamX
        camera?.position.y += offsetcamY
        
        // Adjust the position of other nodes to follow the camera movement
        
        for node in children{
            if node != padUp  && node != padDown && node != padRight && node != padLeft{
                node.position.x -= offsetcamX
                node.position.y -= offsetcamY
            }
        }
        
//        print("posisi navigator: \(game.navigatorPosition)")
//        print("posisi supply: \(game.supplyPosition)")
        
//        let moveVectorSupply = CGVector(dx: game.supplyPosition.x, dy: game.supplyPosition.y)
//        let moveSupply = SKAction.move(by: moveVectorSupply, duration: 2)
//        characterSupply.run(moveSupply)
//
//        let moveVectorNavigator = CGVector(dx: game.navigatorPosition.x, dy: game.navigatorPosition.y)
//        let moveNavigator = SKAction.move(by: moveVectorNavigator, duration: 2)
//        characterNavigator.run(moveNavigator)
        
//        characterNavigator.position = game.navigatorPosition
//        characterSupply.position = game.supplyPosition
        

        
    }
}
