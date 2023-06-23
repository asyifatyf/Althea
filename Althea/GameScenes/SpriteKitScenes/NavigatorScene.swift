//
//  GameView.swift
//  WorldView
//
//  Created by Theresa Tiffany on 20/06/23.
//

import Foundation
import SpriteKit
import SwiftUI

class NavigatorScene: SKScene {
    
    @State var xPosition: CGFloat = 0
    @State var yPosition: CGFloat = 0
    var characterImage: SKSpriteNode = SKSpriteNode()
    var characterImage1: SKSpriteNode = SKSpriteNode()
    var characterImage2: SKSpriteNode = SKSpriteNode()
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
        
        characterImage = childNode(withName: "down_stop_nav") as! SKSpriteNode
        characterImage1 = childNode(withName: "down_stop_sup") as! SKSpriteNode
        characterImage2 = childNode(withName: "down_stop") as! SKSpriteNode
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
        let zoomInAction = SKAction.scale(to: 0.5, duration: 1)
        sceneCamera.run(zoomInAction)
        
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
            characterImage.texture = SKTexture(imageNamed: "up_stop_nav")
        case .upRun:
            characterImage.texture = SKTexture(imageNamed: "up_stop_nav")
            
        case .rightStop:
            characterImage.texture = SKTexture(imageNamed: "right_stop_nav")
        case .rightRun:
            characterImage.texture = SKTexture(imageNamed: "right_stop_nav")
            
        case .downStop:
            characterImage.texture = SKTexture(imageNamed: "down_stop_nav")
        case .downRun:
            characterImage.texture = SKTexture(imageNamed: "down_stop_nav")
            
        case .leftStop:
            characterImage.texture = SKTexture(imageNamed: "left_stop_nav")
        case .leftRun:
            characterImage.texture = SKTexture(imageNamed: "left_stop_nav")
            
        }
    }
    
    private func moveCharacter(direction: Direction) {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        xOffset = xPosition
        yOffset = yPosition
        switch direction {
            
        case .up:
            yOffset = 20
        case .right:
            xOffset = 20
        case .down:
            yOffset = -20
        case .left:
            xOffset = -20
        }
        
        let moveAction = SKAction.moveBy(x: xOffset, y: yOffset, duration: 0.5)
        characterImage.run(moveAction)
        
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
            case "padRight":
                moveCharacter(direction: .right)
                characterState = .rightRun
            case "padDown":
                moveCharacter(direction: .down)
                characterState = .downRun
            case "padLeft":
                moveCharacter(direction: .left)
                characterState = .leftRun
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let offsetX = characterImage.position.x - size.width / 2
        let offsetY = characterImage.position.y - size.height / 2
        
        // Adjust the camera's position to follow the characterImage
        camera?.position.x += offsetX
        camera?.position.y += offsetY
        
        // Adjust the position of other nodes to follow the camera movement
        
        for node in children{
            if node != padUp  && node != padDown && node != padRight && node != padLeft{
                node.position.x -= offsetX
                node.position.y -= offsetY
            }
        }
    }
}
