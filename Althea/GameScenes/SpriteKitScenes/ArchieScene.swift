//
//  NaviScene.swift
//  Althea
//
//  Created by Rosa Tiara Galuh on 22/06/23.
//

import Foundation
import SwiftUI
import SpriteKit
import GameplayKit
import CoreHaptics

class ArchieScene: SKScene, SKPhysicsContactDelegate {
    var sceneCamera = SKCameraNode()
    
    let game = RealTimeGame.shared

    var characterNavigator: SKSpriteNode = SKSpriteNode()
    var characterSupply: SKSpriteNode = SKSpriteNode()
    var characterCook: SKSpriteNode = SKSpriteNode()
    
    var middleArea = SKSpriteNode()
    var cornerArea = SKSpriteNode()
    var bombNodes: [SKSpriteNode] = []

    
    var treasureBigArea = SKSpriteNode()// area luar treasure, beep sound play tp blm cepet.
    var treasureLocation = SKSpriteNode() // area treasure yg bisa di-dig, beep sound makin cepet.
    
    var isPlayerInTreasureLocation = false
    
    var itemsCollected: [String: Int] = [:]
    var isMetalDetectorActive = false
    
    var padUp = SKSpriteNode()
    var padDown = SKSpriteNode()
    var padLeft = SKSpriteNode()
    var padRight = SKSpriteNode()
    
    // haptics
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var directionHeld: Direction? = nil
    
    
    let walkingSound = SKAction.playSoundFileNamed("footstep.mp3", waitForCompletion: false)
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
        
//        let bomb = SKSpriteNode(imageNamed: "Bomb")
//        bomb.name = "Bomb"
        
        setupBlockedArea()
        setupPlayerNode()
        setupGamepadNode()
        setupCamera()
        setupTreasureNode()
    }
    
    func setupTreasureNode() {
        treasureBigArea = childNode(withName: "treasureBigArea") as! SKSpriteNode
        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory

//        treasureBigArea = childNode(withName: "treasureBigArea2") as! SKSpriteNode
//        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory
//
//        treasureBigArea = childNode(withName: "treasureBigArea3") as! SKSpriteNode
//        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory
//
//        treasureBigArea = childNode(withName: "treasureBigArea4") as! SKSpriteNode
//        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory
//
//        treasureBigArea = childNode(withName: "treasureBigArea5") as! SKSpriteNode
//        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory
//
//        treasureBigArea = childNode(withName: "treasureBigArea6") as! SKSpriteNode
//        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory
//
//        treasureBigArea = childNode(withName: "treasureBigArea7") as! SKSpriteNode
//        treasureBigArea.name = "TreasureBigArea" // add to PhysicsCategory
            
        
        treasureBigArea.physicsBody = SKPhysicsBody(rectangleOf: treasureBigArea.size)
        treasureBigArea.physicsBody?.isDynamic = false
        treasureBigArea.physicsBody?.categoryBitMask = PhysicsCategory.TreasureBigArea
        treasureBigArea.alpha = 0
        treasureBigArea.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        treasureBigArea.physicsBody?.collisionBitMask = 0
        
        
        treasureLocation = childNode(withName: "treasureLocation") as! SKSpriteNode
        treasureLocation.name = "TreasureLocation" // add to PhysicsCategory
        
        treasureLocation.physicsBody = SKPhysicsBody(rectangleOf: treasureLocation.size)
        treasureLocation.physicsBody?.isDynamic = false
        treasureLocation.physicsBody?.categoryBitMask = PhysicsCategory.TreasureLocation
        treasureLocation.alpha = 0
        treasureLocation.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        treasureLocation.physicsBody?.collisionBitMask = 0
        
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
        characterSupply.name = "Player"
        
        characterSupply.physicsBody = SKPhysicsBody(rectangleOf: characterSupply.size)
        characterSupply.physicsBody?.isDynamic = true
        characterSupply.physicsBody?.affectedByGravity = false
        characterSupply.physicsBody?.allowsRotation = false
        
        characterSupply.physicsBody?.categoryBitMask = PhysicsCategory.Player
        characterSupply.physicsBody?.contactTestBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea | PhysicsCategory.Apple | PhysicsCategory.Wheat | PhysicsCategory.Rock | PhysicsCategory.Pineapple | PhysicsCategory.Wood | PhysicsCategory.Bomb
        characterSupply.physicsBody?.collisionBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        
        characterCook.physicsBody = SKPhysicsBody(rectangleOf: characterCook.size)
        characterCook.physicsBody?.isDynamic = true
        characterCook.physicsBody?.affectedByGravity = false
        characterCook.physicsBody?.allowsRotation = false
        
        characterCook.physicsBody?.categoryBitMask = PhysicsCategory.Playerss
        characterCook.physicsBody?.contactTestBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        characterCook.physicsBody?.collisionBitMask = PhysicsCategory.CornerArea | PhysicsCategory.MiddleArea
        
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
        
        let magnet = SKSpriteNode(imageNamed: "Magnet")
        apple.name = "Magnet" // PhysicsCategory
        
        let bomb = SKSpriteNode(imageNamed: "Bomb")
        bomb.name = "Bomb"
        
        bombNodes.append(bomb)
        bomb.alpha = 0
        bomb.setScale(0.2)

        addChild(bomb)
        
        
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
        let items = ["Apple", "Wood", "Pineapple", "Wheat", "Rock", "Magnet"]
        
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
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.TreasureBigArea) ||
            (contact.bodyA.categoryBitMask == PhysicsCategory.TreasureBigArea && contact.bodyB.categoryBitMask == PhysicsCategory.Player) {
            
            print("Player got into the treasure area")
            contact.bodyA.node?.removeAction(forKey: "beepSound")
            
            if let playerNode = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyA.node : contact.bodyB.node {
                playBeepSound(on: playerNode, withSpeedMultiplier: 1.0)
            }
            startHaptic()
            contact.bodyA.node?.removeFromParent()
        }
        
        if (contact.bodyA.categoryBitMask == PhysicsCategory.Player && contact.bodyB.categoryBitMask == PhysicsCategory.TreasureLocation) ||
            (contact.bodyA.categoryBitMask == PhysicsCategory.TreasureLocation && contact.bodyB.categoryBitMask == PhysicsCategory.Player) {
            
            print("treasure area!")
            if let playerNode = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyA.node : contact.bodyB.node {
                isPlayerInTreasureLocation = true
                if isMetalDetectorActive && isPlayerInTreasureLocation {
                    playBeepSound(on: playerNode, withSpeedMultiplier: 20.0)
                }
            }
            startHaptic()
            contact.bodyA.node?.removeFromParent()
            isPlayerInTreasureLocation = true
        } else {
            isPlayerInTreasureLocation = false
            
           
        }
    }
    
    func startHaptic() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }

    func playBeepSound(on playerNode: SKNode, withSpeedMultiplier speedMultiplier: CGFloat) {
        let beepSound = SKAction.playSoundFileNamed("beep.mp3", waitForCompletion: true)

        let speedAction = SKAction.speed(to: speedMultiplier, duration: 0)

        let repeatBeepSound = SKAction.repeatForever(SKAction.sequence([speedAction, beepSound]))
        playerNode.run(repeatBeepSound, withKey: "beepSound")
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
            characterSupply.texture = SKTexture(imageNamed: "up_stop_sup")
            game.sendSupplyOrientation(supplyOrientation: "upStop")

        case .upRun:
            characterSupply.texture = SKTexture(imageNamed: "up_stop_sup")
            game.sendSupplyOrientation(supplyOrientation: "upRun")

            
        case .rightStop:
            characterSupply.texture = SKTexture(imageNamed: "right_stop_sup")
            game.sendSupplyOrientation(supplyOrientation: "rightStop")

        case .rightRun:
            characterSupply.texture = SKTexture(imageNamed: "right_stop_sup")
            characterSupply.texture = SKTexture(imageNamed: "archie1")
            characterSupply.texture = SKTexture(imageNamed: "archie2")
            characterSupply.texture = SKTexture(imageNamed: "archie3")
            game.sendSupplyOrientation(supplyOrientation: "rightRun")
            
        case .downStop:
            characterSupply.texture = SKTexture(imageNamed: "down_stop_sup")
            game.sendSupplyOrientation(supplyOrientation: "downStop")

        case .downRun:
            characterSupply.texture = SKTexture(imageNamed: "down_stop_sup")
            game.sendSupplyOrientation(supplyOrientation: "downRun")

        case .leftStop:
            characterSupply.texture = SKTexture(imageNamed: "left_stop_sup")
            game.sendSupplyOrientation(supplyOrientation: "leftStop")

        case .leftRun:
            characterSupply.texture = SKTexture(imageNamed: "left_stop_sup")
            characterSupply.texture = SKTexture(imageNamed: "archie1left")
            characterSupply.texture = SKTexture(imageNamed: "archie2left")
            characterSupply.texture = SKTexture(imageNamed: "archie3left")
            game.sendSupplyOrientation(supplyOrientation: "leftRun")
            
        }
    }
    
    private func moveCharacter(direction: Direction) {
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        switch direction {
            
        case .up:
            yOffset = 5
            game.sendSupplyData(xPosition: 0, yPosition: 5)

        case .right:
            xOffset = 5
            game.sendSupplyData(xPosition:  5, yPosition: 0)
            
        case .down:
            yOffset = -5
            game.sendSupplyData(xPosition: 0, yPosition: -5)

        case .left:
            xOffset = -5
            game.sendSupplyData(xPosition:  -5, yPosition: 0)

        }
        
        let moveAction = SKAction.moveBy(x: xOffset, y: yOffset, duration: 0.5)
        characterSupply.run(moveAction)
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
        let offsetX = characterSupply.position.x - size.width / 2
        let offsetY = characterSupply.position.y - size.height / 2
        
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
        
        while game.isCookData{
            let cookAction = SKAction.moveBy(x: game.cookXPosition, y: game.cookYPosition, duration: 0.5)
            characterCook.run(cookAction)
            
            switch game.cookOrientation {
            case "upStop":
                characterCook.texture = SKTexture(imageNamed: "up_stop_cook")
                
            case "upRun":
                characterCook.texture = SKTexture(imageNamed: "up_stop_cook")
                
            case "rightStop":
                characterCook.texture = SKTexture(imageNamed: "right_stop_cook")
                
            case "rightRun":
                characterCook.texture = SKTexture(imageNamed: "right_stop_cook")
                
            case "downStop":
                characterCook.texture = SKTexture(imageNamed: "down_stop_cook")
                
            case "downRun":
                characterCook.texture = SKTexture(imageNamed: "down_stop_cook")
                
            case "leftStop":
                characterCook.texture = SKTexture(imageNamed: "left_stop_cook")
                
            case "leftRun":
                characterCook.texture = SKTexture(imageNamed: "left_stop_cook")
                
            default:
                return
            }
            
            game.isCookData = false
        }
    }
}

