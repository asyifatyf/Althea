//
//  PepperScene.swift
//  Althea
//
//  Created by Asyifa Tasya Fadilah on 28/06/23.
//

import Foundation
import SpriteKit
import GameplayKit

class PepperScene: SKScene, SKPhysicsContactDelegate {
    var sceneCamera = SKCameraNode()
    
    let game = RealTimeGame.shared

    var characterNavigator: SKSpriteNode = SKSpriteNode()
    var characterSupply: SKSpriteNode = SKSpriteNode()
    var characterCook: SKSpriteNode = SKSpriteNode()
    
    var middleArea = SKSpriteNode()
    var cornerArea = SKSpriteNode()
    
    
    var itemsCollected: [String: Int] = [:]
    
    var padUp = SKSpriteNode()
    var padDown = SKSpriteNode()
    var padLeft = SKSpriteNode()
    var padRight = SKSpriteNode()
    
    // haptics
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var directionHeld: Direction? = nil
    
    
    let walkingSound = SKAction.playSoundFileNamed("footstep.mp3", waitForCompletion: true)
    let itemCollected = SKAction.playSoundFileNamed("itemCollected.mp3", waitForCompletion: false)
    
    
    private enum CharacterState {
        case upStop, upRun, rightStop, rightRun, downStop, downRun, leftStop, leftRun
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator?.prepare()
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
        
        let bomb = SKSpriteNode(imageNamed: "Bomb")
        bomb.name = "Bomb"
        
        setupBlockedArea()
        setupPlayerNode()
        setupGamepadNode()
        setupCamera()
        
    }
    
    
    func setupBlockedArea() {
        let cornerAreaTexture = SKTexture(imageNamed: "blocked")
        let cornerAreaSize = cornerAreaTexture.size()
        let cornerAreaPhysicsBody = SKPhysicsBody(texture: cornerAreaTexture, alphaThreshold: 0.5, size: cornerAreaSize)
        
        cornerAreaPhysicsBody.isDynamic = false
        cornerAreaPhysicsBody.affectedByGravity = false
        cornerAreaPhysicsBody.categoryBitMask = PhysicsCategory.CornerArea
        cornerAreaPhysicsBody.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Playerss
        cornerAreaPhysicsBody.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Playerss
        
        cornerArea = SKSpriteNode(texture: cornerAreaTexture)
        cornerArea.alpha = 0
        cornerArea.physicsBody = cornerAreaPhysicsBody
        cornerArea.name = "CornerArea"
        
    }
    
    
    func setupPlayerNode() {
        characterNavigator = childNode(withName: "down_stop_nav") as! SKSpriteNode
        characterSupply = childNode(withName: "down_stop_sup") as! SKSpriteNode
        characterCook = childNode(withName: "down_stop_cook") as! SKSpriteNode
        characterCook.name = "Player"

        
        characterCook.physicsBody = SKPhysicsBody(rectangleOf: characterCook.size)
        characterCook.physicsBody?.isDynamic = true
        characterCook.physicsBody?.affectedByGravity = false
        characterCook.physicsBody?.allowsRotation = false
        
        characterCook.physicsBody?.categoryBitMask = PhysicsCategory.Player
        characterCook.physicsBody?.contactTestBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea | PhysicsCategory.Apple | PhysicsCategory.Wheat | PhysicsCategory.Rock | PhysicsCategory.Pineapple | PhysicsCategory.Wood | PhysicsCategory.Bomb
        characterCook.physicsBody?.collisionBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        
        characterSupply.physicsBody = SKPhysicsBody(rectangleOf: characterSupply.size)
        characterSupply.physicsBody?.isDynamic = true
        characterSupply.physicsBody?.affectedByGravity = false
        characterSupply.physicsBody?.allowsRotation = false
        
        characterSupply.physicsBody?.categoryBitMask = PhysicsCategory.Playerss
        characterSupply.physicsBody?.contactTestBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        characterSupply.physicsBody?.collisionBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        
        characterNavigator.physicsBody = SKPhysicsBody(rectangleOf: characterNavigator.size)
        characterNavigator.physicsBody?.isDynamic = true
        characterNavigator.physicsBody?.affectedByGravity = false
        characterNavigator.physicsBody?.allowsRotation = false
        
        characterNavigator.physicsBody?.categoryBitMask = PhysicsCategory.Playerss
        characterNavigator.physicsBody?.contactTestBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        characterNavigator.physicsBody?.collisionBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
    }
    
    func setupLootsNode() {
        //TODO: bomb, magnet
        let apple = SKSpriteNode(imageNamed: "Apple")
        apple.name = "Apple" // PhysicsCategory
        
        let pineapple = SKSpriteNode(imageNamed: "Pineapple")
        pineapple.name = "Pineapple"
        
        let rock = SKSpriteNode(imageNamed: "Rock")
        rock.name = "Rock"
        
        let wood = SKSpriteNode(imageNamed: "Wood")
        wood.name = "Wood"
        
        let wheat = SKSpriteNode(imageNamed: "Wheat")
        wheat.name = "Wheat"
        
       
        
    }
    
    func setupGamepadNode() {
        padUp = childNode(withName: "padUp") as! SKSpriteNode
        padUp.setScale(0.75)
        padUp.zPosition = 1
        padDown = childNode(withName: "padDown") as! SKSpriteNode
        padDown.setScale(0.75)
        padDown.zPosition = 1
        padLeft = childNode(withName: "padLeft") as! SKSpriteNode
        padLeft.setScale(0.75)
        padLeft.zPosition = 1
        padRight = childNode(withName: "padRight") as! SKSpriteNode
        padRight.setScale(0.75)
        padRight.zPosition = 1
    }
    
    func setupCamera() {
        sceneCamera = childNode(withName: "sceneCamera") as! SKCameraNode
        camera = sceneCamera
        if let camera = camera {
            let cameraOffset = CGPoint(x: camera.position.x - size.width / 2 , y: camera.position.y - size.height / 2)
            
            padUp.position = CGPoint(x: padUp.position.x - cameraOffset.x + 450, y: padUp.position.y - cameraOffset.y + 182)
            padDown.position = CGPoint(x: padUp.position.x - cameraOffset.x, y: padUp.position.y - cameraOffset.y - 50)
            padRight.position = CGPoint(x: padUp.position.x - cameraOffset.x + 30, y: padUp.position.y - cameraOffset.y - 25)
            padLeft.position = CGPoint(x: padUp.position.x - cameraOffset.x - 32, y: padUp.position.y - cameraOffset.y - 25)
        }
        
        let zoomInAction = SKAction.scale(to: 0.75, duration: 1)
        sceneCamera.run(zoomInAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("appleeeee")
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        let items = ["Apple", "Wood", "Pineapple", "Wheat", "Rock"]
        
        setupLootsNode()
        
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            if items.contains(nodeA.name ?? "") && nodeB.name == "Player" {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
                print("first body is not player")
            }
        }
        
        if let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node {
            if nodeA.name == "Bomb" && nodeB.name == "Player" {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
                print("first body is not player")
            }
        }
        
        if items.contains(firstBody.node?.name ?? "") && secondBody.node?.name == "Player" {
            let itemName = firstBody.node?.name ?? ""
            
            if let itemCount = itemsCollected[itemName] {
                itemsCollected[itemName] = itemCount + 1
                NotificationCenter.default.post(name: NSNotification.Name("UpdateInventory"), object: itemsCollected)
                
                print("Item collected: \(itemName)")
                firstBody.node?.removeFromParent()
                run(itemCollected)
            } else {
                itemsCollected[itemName] = 1
                NotificationCenter.default.post(name: NSNotification.Name("UpdateInventory"), object: itemsCollected)
                
                print("Item collected: \(itemName)")
                
                firstBody.node?.removeFromParent()
                run(itemCollected)
            }
        } else if firstBody.node?.name == "Bomb" && secondBody.node?.name == "Player" {
            firstBody.node?.removeFromParent()
            game.sendObjectType(objectType: "Bomb")
            game.objectType = "Bomb"

        }
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
            characterCook.texture = SKTexture(imageNamed: "up_stop_cook")
            game.sendCookOrientation(cookOrientation: "upStop")

        case .upRun:
            characterCook.texture = SKTexture(imageNamed: "up_stop_cook")
            game.sendCookOrientation(cookOrientation: "upRun")

            
        case .rightStop:
            characterCook.texture = SKTexture(imageNamed: "right_stop_cook")
            game.sendCookOrientation(cookOrientation: "rightStop")

        case .rightRun:
            characterCook.texture = SKTexture(imageNamed: "right_stop_cook")
            characterCook.texture = SKTexture(imageNamed: "chef1")
            characterCook.texture = SKTexture(imageNamed: "chef2")
            characterCook.texture = SKTexture(imageNamed: "chef3")
            game.sendCookOrientation(cookOrientation: "rightRun")

            
        case .downStop:
            characterCook.texture = SKTexture(imageNamed: "down_stop_cook")
            game.sendCookOrientation(cookOrientation: "downStop")

        case .downRun:
            characterCook.texture = SKTexture(imageNamed: "down_stop_cook")
            game.sendCookOrientation(cookOrientation: "downRun")
            
        case .leftStop:
            characterCook.texture = SKTexture(imageNamed: "left_stop_cook")
            game.sendCookOrientation(cookOrientation: "leftStop")

        case .leftRun:
            characterCook.texture = SKTexture(imageNamed: "left_stop_cook")
            characterCook.texture = SKTexture(imageNamed: "chef1left")
            characterCook.texture = SKTexture(imageNamed: "chef2left")
            characterCook.texture = SKTexture(imageNamed: "chef3left")
            game.sendCookOrientation(cookOrientation: "leftRun")
            
        }
    }
    
    private func moveCharacter(direction: Direction) {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        switch direction {
            
        case .up:
            yOffset = 5
            game.sendCookData(xPosition: 0, yPosition: 5)

        case .right:
            xOffset = 5
            game.sendCookData(xPosition: 5, yPosition: 0)

        case .down:
            yOffset = -5
            game.sendCookData(xPosition: 0, yPosition: -5)

        case .left:
            xOffset = -5
            game.sendCookData(xPosition: -5, yPosition: 0)
            
        }
        
        let moveAction = SKAction.moveBy(x: xOffset, y: yOffset, duration: 0.5)
        characterCook.run(moveAction)
    }
    private func startMovingCharacter(direction: Direction) {
        if directionHeld == nil {
            directionHeld = direction
            switch direction {
            case .up:
                padUp.alpha = 1
                characterState = .upRun
                run(walkingSound)
                
            case .right:
                padRight.alpha = 1
                characterState = .rightRun
                run(walkingSound)
                
                
            case .down:
                padDown.alpha = 1
                characterState = .downRun
                run(walkingSound)
                
                
            case .left:
                padLeft.alpha = 1
                characterState = .leftRun
                run(walkingSound)
                
            }
            moveCharacter(direction: direction)
        }
    }
    
    private func stopMovingCharacter() {
        if let direction = directionHeld {
            directionHeld = nil
            switch direction {
            case .up:
                characterState = .upStop
                padUp.alpha = 0.5
                
            case .right:
                characterState = .rightStop
                padRight.alpha = 0.5
                
            case .down:
                characterState = .downStop
                padDown.alpha = 0.5
                
            case .left:
                characterState = .leftStop
                padLeft.alpha = 0.5
                
            }
        }
    }
    
    private func handleTouch(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        for node in touchedNodes {
            switch node.name {
            case "padUp":
                startMovingCharacter(direction: .up)
                
            case "padRight":
                startMovingCharacter(direction: .right)
                
            case "padDown":
                startMovingCharacter(direction: .down)
                
            case "padLeft":
                startMovingCharacter(direction: .left)
                
            default:
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouch(touches)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stopMovingCharacter()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let offsetX = characterCook.position.x - size.width / 2
        let offsetY = characterCook.position.y - size.height / 2
        
        camera?.position.x += offsetX
        camera?.position.y += offsetY
        
        for node in children {
            if node != padUp  && node != padDown && node != padRight && node != padLeft {
                node.position.x -= offsetX
                node.position.y -= offsetY
            }
        }
        
        if let direction = directionHeld {
            moveCharacter(direction: direction)
        }
        
        while game.isNavigatorData{
            let navigatorAction = SKAction.moveBy(x: game.navigatorXPosition, y: game.navigatorYPosition, duration: 0.5)
            characterNavigator.run(navigatorAction)
            
            switch game.navigatorOrientation {
            case "upStop":
                characterNavigator.texture = SKTexture(imageNamed: "up_stop_nav")
                
            case "upRun":
                characterNavigator.texture = SKTexture(imageNamed: "up_stop_nav")
                
            case "rightStop":
                characterNavigator.texture = SKTexture(imageNamed: "right_stop_nav")
                
            case "rightRun":
                characterNavigator.texture = SKTexture(imageNamed: "right_stop_nav")
                
            case "downStop":
                characterNavigator.texture = SKTexture(imageNamed: "down_stop_nav")
                
            case "downRun":
                characterNavigator.texture = SKTexture(imageNamed: "down_stop_nav")
                
            case "leftStop":
                characterNavigator.texture = SKTexture(imageNamed: "left_stop_nav")
                
            case "leftRun":
                characterNavigator.texture = SKTexture(imageNamed: "left_stop_nav")
                
            default:
                return
            }
            
            game.isNavigatorData = false
        }
        while game.isSupplyData{
            let supplyAction = SKAction.moveBy(x: game.supplyXPosition, y: game.supplyYPosition, duration: 0.5)
            characterSupply.run(supplyAction)
            
            switch game.supplyOrientation {
            case "upStop":
                characterSupply.texture = SKTexture(imageNamed: "up_stop_sup")
                
            case "upRun":
                characterSupply.texture = SKTexture(imageNamed: "up_stop_sup")
                
            case "rightStop":
                characterSupply.texture = SKTexture(imageNamed: "right_stop_sup")
                
            case "rightRun":
                characterSupply.texture = SKTexture(imageNamed: "right_stop_sup")
                
            case "downStop":
                characterSupply.texture = SKTexture(imageNamed: "down_stop_sup")
                
            case "downRun":
                characterSupply.texture = SKTexture(imageNamed: "down_stop_sup")
                
            case "leftStop":
                characterSupply.texture = SKTexture(imageNamed: "left_stop_sup")
                
            case "leftRun":
                characterSupply.texture = SKTexture(imageNamed: "left_stop_sup")
                
            default:
                return
            }
            
            game.isSupplyData = false
        }
    }
}
