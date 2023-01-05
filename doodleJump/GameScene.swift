//
//  GameScene.swift
//  doodleJump
//
//  Created by  on 12/14/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

    //makeBLOCK CLASS
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var audioPlayer = AVAudioPlayer()
    var miloMan = SKSpriteNode()
    var location = CGPoint()
    var score = SKLabelNode()
    var borderRight = SKSpriteNode()
    var borderLeft = SKSpriteNode()
    var startBlock = SKSpriteNode()
    var woodArray = [SKSpriteNode]()
    var gravityArray = [SKFieldNode]()
    var count = 0
    var waiting = false
    var jumpAgain = true
    override func didMove(to view: SKView) {
        miloMan = childNode(withName: "miloMan") as! SKSpriteNode
        startBlock = childNode(withName: "startBlock") as! SKSpriteNode
        score = childNode(withName: "Score") as! SKLabelNode
        startBlock.physicsBody?.categoryBitMask = 2
        score.physicsBody?.affectedByGravity = false
        startBlock.physicsBody?.collisionBitMask = 2
        startBlock.physicsBody?.contactTestBitMask = 2

        miloMan.zPosition = 1
        borderLeft = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 1, height: frame.height))
        borderRight = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 1, height: frame.height))
        borderLeft.position = CGPoint(x: 10, y: frame.height/2)
        borderRight.position = CGPoint(x: frame.width-10, y: frame.height/2)
        borderRight.physicsBody = SKPhysicsBody(rectangleOf: borderRight.frame.size)
        borderRight.physicsBody?.isDynamic = false
        borderRight.isPaused = true
        borderLeft.physicsBody = SKPhysicsBody(rectangleOf: borderLeft.frame.size)
        borderLeft.physicsBody?.isDynamic = false
        addChild(borderLeft)
        addChild(borderRight)
        setUpContacts()
        let create = SKAction.sequence([SKAction.run(createWood), SKAction.wait(forDuration: 2)])
        run(SKAction.repeatForever(create))
        let createGrav = SKAction.sequence([SKAction.run(gravField), SKAction.wait(forDuration: 6)])
        run(SKAction.repeatForever(createGrav))
        timer()
    }
    

    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ((miloMan.physicsBody?.velocity.dy==0 || jumpAgain) && !waiting){
            miloMan.physicsBody?.applyImpulse(CGVectorMake(0, 1750))
            jumpAgain = false
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        location = touches.first!.location(in: self)
        if (!waiting){
            miloMan.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    
    
    
    
    func createWood(){
        let randVelo = Int.random(in: 150...250)
        let rand = Int.random(in: 0...Int(frame.width))
        let newWood = SKSpriteNode(color: .brown, size: CGSize(width:
                                                                150, height: 25))
        addChild(newWood)
        newWood.position = CGPoint(x: CGFloat(rand), y: self.frame.height*0.9)
        newWood.physicsBody = SKPhysicsBody(rectangleOf: newWood.frame.size)
        newWood.physicsBody?.allowsRotation = false
        newWood.physicsBody?.mass = 10000
        newWood.physicsBody?.friction = 0
        newWood.physicsBody?.restitution = 0
        newWood.physicsBody?.affectedByGravity = false
        newWood.physicsBody?.velocity = CGVector(dx: 0, dy: -randVelo)
        newWood.physicsBody?.isDynamic = true
        newWood.zPosition = -1
        newWood.physicsBody?.collisionBitMask = 2
        newWood.physicsBody?.categoryBitMask = 2
        count+=1
        woodArray.append(newWood)
    }
    
    
    func gravField(){
        
        let gravity = SKFieldNode.radialGravityField()
        gravity.strength = 000000000000.1
        gravity.categoryBitMask = 8
        gravity.physicsBody?.collisionBitMask = 8
        let randVelo = Int.random(in: 100...300)
        let rand = Int.random(in: 0...Int(frame.width))
        let newGrav = SKSpriteNode(color: .gray, size: CGSize(width:
                                                                150, height: 25))
        addChild(newGrav)
        addChild(gravity)
        newGrav.position = CGPoint(x: CGFloat(rand), y: self.frame.height*0.9)
        newGrav.physicsBody = SKPhysicsBody(rectangleOf: newGrav.frame.size)
        newGrav.physicsBody?.allowsRotation = false
        newGrav.physicsBody?.mass = 10000
        newGrav.physicsBody?.friction = 0
        newGrav.physicsBody?.restitution = 0
        newGrav.physicsBody?.affectedByGravity = false
        newGrav.physicsBody?.velocity = CGVector(dx: 0, dy: -randVelo)
        gravity.physicsBody?.velocity = CGVector(dx: 0, dy: -randVelo)
        gravity.falloff = 1
        newGrav.physicsBody?.isDynamic = true
        newGrav.zPosition = -1
        newGrav.physicsBody?.collisionBitMask = 2
        newGrav.physicsBody?.categoryBitMask = 2
        count+=1
        gravity.position = newGrav.position
        woodArray.append(newGrav)
        gravityArray.append(gravity)
        gravity.run(SKAction.playSoundFileNamed("cringe", waitForCompletion: true))
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var dontCare = false
                if (contact.bodyA.categoryBitMask==1 || contact.bodyB.categoryBitMask==1)&&(contact.bodyA.categoryBitMask==2 || contact.bodyB.categoryBitMask==2){
                    miloMan.run(.playSoundFileNamed("mixkit-arcade-game-jump-coin-216 (1)", waitForCompletion: false))
                        jumpAgain = true
                }
    }
    
        func setUpContacts(){
            miloMan.physicsBody?.categoryBitMask = 1
            
            
            miloMan.physicsBody?.contactTestBitMask = 2
            
            physicsWorld.contactDelegate = self
        }
    
    
    
    
    
    
    func timer(){
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.count+=1
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        score.text = "Time: \(count)"
        if count%30==0 && count != 0{
            miloMan.run(SKAction.playSoundFileNamed("yes", waitForCompletion: true))
        }
            if (miloMan.physicsBody?.velocity.dy)!>0{
                miloMan.physicsBody?.collisionBitMask = 1
            } else{
                miloMan.physicsBody?.collisionBitMask = 2
//                jumpAgain = false
            }
            if miloMan.position.x<100{
                miloMan.position = CGPoint(x: frame.width-105, y: miloMan.position.y+0)
            }
            if miloMan.position.x>frame.width-100{
                miloMan.position = CGPoint(x: 105, y: miloMan.position.y+10)
            }
            if miloMan.position.y<0{
                run(SKAction.sequence([SKAction.run(resetScreen), SKAction.wait(forDuration: 2), SKAction.run(affect)]))
            }
            
            if miloMan.position.y>50{
                if gravityArray.count>4{
                    gravityArray[0].removeFromParent()
                    gravityArray.remove(at: 0)
                }
                if woodArray.count>7{
                    woodArray[0].removeFromParent()
                    woodArray.remove(at: 0)
                }
            }
            
        }
    
    
    func createThing(){
        
        let magic = SKEmitterNode(fileNamed: "MyParticle")
        magic?.position = CGPoint(x: frame.width/2, y: frame.height/2)
        magic?.zPosition = -10
        addChild(magic!)
        magic?.physicsBody = SKPhysicsBody(rectangleOf: magic?.frame.size ?? CGSize(width: 500, height: 500))
    }
    
    
    
    
    func affect(){
        waiting = false
        miloMan.physicsBody?.affectedByGravity=true
        startBlock.physicsBody?.isDynamic = true
    }
    
    
    
    
    
        func resetScreen(){
            createThing()
            waiting = true
            count = 0
            miloMan.run(.playSoundFileNamed("mixkit-cinematic-horror-trailer-long-sweep-561", waitForCompletion: true))
            miloMan.physicsBody?.velocity.dx = 0
            miloMan.physicsBody?.velocity.dy = 0
            miloMan.physicsBody?.affectedByGravity = false
            if woodArray.count>0{
                for i in woodArray{
                    i.removeFromParent()
                }
                woodArray.removeAll()
            }
            if gravityArray.count>0{
                for i in gravityArray{
                    i.removeFromParent()
                }
                gravityArray.removeAll()
            }
            miloMan.position = CGPoint(x: frame.width/2, y: frame.height/2)
            startBlock.physicsBody?.velocity.dy = 0
            startBlock.physicsBody?.velocity.dx = 0
            startBlock.physicsBody?.isDynamic = false
            startBlock.position = CGPoint(x: frame.width/2, y: frame.width/2+200)
        }
    }
