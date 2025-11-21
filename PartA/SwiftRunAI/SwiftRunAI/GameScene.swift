import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let player: UInt32      = 0x1 << 0
        static let obstacle: UInt32    = 0x1 << 1
        static let ground: UInt32      = 0x1 << 2
        static let coin: UInt32        = 0x1 << 3
        static let projectile: UInt32  = 0x1 << 4
        static let enemy: UInt32       = 0x1 << 5
        static let boss: UInt32        = 0x1 << 6
    }
    
    private var player: SKSpriteNode!
    private var ground: SKSpriteNode!
    
    private var mountainNodes: [SKSpriteNode] = []
    private var skyNodes: [SKSpriteNode] = []
    
    private var lastUpdateTime: TimeInterval = 0
    private var distance: Double = 0
    private var score: Int = 0
    private var obstaclesHit = 0
    private var startTime: TimeInterval = 0
    
    private var health: Int = 3
    
    private var obstacleSpawnTimer: TimeInterval = 0
    private var coinSpawnTimer: TimeInterval = 0
    private var enemySpawnTimer: TimeInterval = 0
    
    private var boss: SKSpriteNode?
    private var bossHealth: Int = 10
    private var bossSpawned = false
    
    var onScoreUpdate: ((Int) -> Void)?
    var onDistanceUpdate: ((Double) -> Void)?
    var onHealthUpdate: ((Int) -> Void)?
    var onGameEndWithStats: ((GameStats) -> Void)?
    
    private var isGameOver = false
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        startTime = CACurrentMediaTime()
        
        setupBackground()
        setupGround()
        setupPlayer()
        
        obstacleSpawnTimer = currentObstacleInterval()
        coinSpawnTimer = currentCoinInterval()
        enemySpawnTimer = currentEnemyInterval()
        
        onHealthUpdate?(health)
    }
    
    // MARK: - Background
    
    private func setupBackground() {
        for i in 0..<2 {
            let sky = SKSpriteNode(imageNamed: "sky1")
            sky.size = CGSize(width: size.width, height: size.height)
            sky.position = CGPoint(x: CGFloat(i) * size.width + size.width / 2, y: size.height / 2)
            sky.zPosition = -30
            addChild(sky)
            skyNodes.append(sky)
        }
        
        for i in 0..<2 {
            let mountain = SKSpriteNode(imageNamed: "mountain")
            mountain.size = CGSize(width: size.width, height: size.height * 0.4)
            mountain.anchorPoint = CGPoint(x: 0.5, y: 0)
            mountain.position = CGPoint(x: CGFloat(i) * size.width + size.width / 2,
                                        y: groundHeight())
            mountain.zPosition = -20
            addChild(mountain)
            mountainNodes.append(mountain)
        }
    }
    
    private func updateParallax(dt: TimeInterval) {
        let skySpeed: CGFloat = 30
        let mountainSpeed: CGFloat = 60
        
        for sky in skyNodes {
            sky.position.x -= skySpeed * CGFloat(dt)
            if sky.position.x < -size.width / 2 {
                sky.position.x += size.width * 2
            }
        }
        
        for mountain in mountainNodes {
            mountain.position.x -= mountainSpeed * CGFloat(dt)
            if mountain.position.x < -size.width / 2 {
                mountain.position.x += size.width * 2
            }
        }
    }
    
    private func groundHeight() -> CGFloat {
        return 90
    }
    
    // MARK: - Player
    
    private func setupPlayer() {
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 120, height: 120)
        player.position = CGPoint(x: size.width * 0.3, y: groundHeight() + 40)
        player.zPosition = 5
        
        let body = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        body.allowsRotation = false
        body.categoryBitMask = PhysicsCategory.player
        body.contactTestBitMask = PhysicsCategory.obstacle |
                                  PhysicsCategory.enemy |
                                  PhysicsCategory.coin |
                                  PhysicsCategory.boss
        body.collisionBitMask = PhysicsCategory.ground
        player.physicsBody = body
        
        addChild(player)
    }
    
    // MARK: - Ground
    
    private func setupGround() {
        ground = SKSpriteNode(color: .brown, size: CGSize(width: size.width * 2, height: 90))
        ground.zPosition = 0
        ground.position = CGPoint(x: size.width / 2, y: groundHeight() / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
    }
    
    // MARK: - Difficulty
    
    private func currentDifficultyMultiplier() -> Double {
        return min(1.0 + distance / 500.0, 3.0)
    }
    private func currentObstacleInterval() -> TimeInterval {
        return max(0.4, 1.5 / currentDifficultyMultiplier())
    }
    private func currentCoinInterval() -> TimeInterval {
        return max(0.4, 1.2 / currentDifficultyMultiplier())
    }
    private func currentEnemyInterval() -> TimeInterval {
        return max(1.3, 3.0 / currentDifficultyMultiplier())
    }
    
    // MARK: - Spawning
    
    private func spawnObstacle() {
        let obstacle = SKSpriteNode(imageNamed: "pole")
        obstacle.size = CGSize(width: 80, height: 160)
        obstacle.position = CGPoint(x: size.width + 100, y: groundHeight() + 80)
        obstacle.zPosition = 4
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        
        addChild(obstacle)
        
        obstacle.run(.sequence([
            .moveBy(x: -size.width - 300, y: 0, duration: 2.8),
            .removeFromParent()
        ]))
    }
    
    private func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.size = CGSize(width: 90, height: 90)
        enemy.position = CGPoint(x: size.width + 120, y: groundHeight() + CGFloat.random(in: 100...240))
        enemy.zPosition = 4
        
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 45)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        
        addChild(enemy)
        
        enemy.run(.sequence([
            .moveBy(x: -size.width - 320, y: 0, duration: 3),
            .removeFromParent()
        ]))
    }
    
    private func spawnBoss() {
        guard boss == nil else { return }
        boss = SKSpriteNode(imageNamed: "boss")
        boss!.size = CGSize(width: 200, height: 200)
        boss!.position = CGPoint(x: size.width + 250, y: groundHeight() + 150)
        boss!.zPosition = 6
        
        let body = SKPhysicsBody(circleOfRadius: 100)
        body.isDynamic = false
        body.categoryBitMask = PhysicsCategory.boss
        boss!.physicsBody = body
        
        addChild(boss!)
    }
    
    private func shootProjectile() {
        let projectile = SKSpriteNode(color: .cyan, size: CGSize(width: 40, height: 20))
        projectile.position = CGPoint(x: player.position.x + 60, y: player.position.y)
        projectile.zPosition = 5
        
        let body = SKPhysicsBody(rectangleOf: projectile.size)
        body.isDynamic = true
        body.affectedByGravity = false
        body.categoryBitMask = PhysicsCategory.projectile
        body.contactTestBitMask = PhysicsCategory.obstacle |
                                  PhysicsCategory.enemy |
                                  PhysicsCategory.boss
        body.collisionBitMask = 0
        projectile.physicsBody = body
        
        addChild(projectile)
        
        projectile.run(.sequence([
            .moveBy(x: size.width + 300, y: 0, duration: 1),
            .removeFromParent()
        ]))
    }
    
    // MARK: - Controls
    
    func playerJump() {
        if let body = player.physicsBody, body.velocity.dy == 0 {
            body.applyImpulse(CGVector(dx: 0, dy: 340))
        }
    }
    func fireProjectile() { shootProjectile() }
    
    // MARK: - Game Loop
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        updateParallax(dt: dt)
        
        ground.position.x -= 350 * dt
        if ground.position.x < -size.width / 2 {
            ground.position.x += size.width
        }
        
        distance += 200 * dt
        onDistanceUpdate?(distance)
        
        obstacleSpawnTimer -= dt
        enemySpawnTimer -= dt
        
        if obstacleSpawnTimer <= 0 {
            spawnObstacle()
            obstacleSpawnTimer = currentObstacleInterval()
        }
        if enemySpawnTimer <= 0 {
            spawnEnemy()
            enemySpawnTimer = currentEnemyInterval()
        }
        
        if !bossSpawned && distance > 900 {
            bossSpawned = true
            spawnBoss()
        }
    }
    
    // MARK: - Collision
    
    func didBegin(_ contact: SKPhysicsContact) {
        if isGameOver { return }
        
        let a = contact.bodyA
        let b = contact.bodyB
        
        let mask = a.categoryBitMask | b.categoryBitMask
        
        func damagePlayer(_ amount: Int) {
            health -= amount
            onHealthUpdate?(health)
            if health <= 0 { gameOver() }
        }
        
        // Player hits pole or enemy
        if mask == PhysicsCategory.player | PhysicsCategory.obstacle ||
            mask == PhysicsCategory.player | PhysicsCategory.enemy {
            damagePlayer(1)
        }
        
        // Player hits boss
        if mask == PhysicsCategory.player | PhysicsCategory.boss {
            damagePlayer(2)
        }
        
        // Projectile hits pole
        if mask == PhysicsCategory.projectile | PhysicsCategory.obstacle {
            a.node?.removeFromParent()
            b.node?.removeFromParent()
            score += 1
            onScoreUpdate?(score)
        }
        
        // Projectile hits enemy
        if mask == PhysicsCategory.projectile | PhysicsCategory.enemy {
            a.node?.removeFromParent()
            b.node?.removeFromParent()
            score += 2
            onScoreUpdate?(score)
        }
        
        // Projectile hits boss
        if mask == PhysicsCategory.projectile | PhysicsCategory.boss {
            a.node?.removeFromParent()
            b.node?.removeFromParent()
            bossHealth -= 1
            boss?.run(.sequence([
                .fadeAlpha(to: 0.3, duration: 0.1),
                .fadeAlpha(to: 1, duration: 0.1)
            ]))
            if bossHealth <= 0 {
                boss?.removeFromParent()
                score += 10
                onScoreUpdate?(score)
            }
        }
    }
    
    private func gameOver() {
        isPaused = true
        
        let duration = CACurrentMediaTime() - startTime
        
        let stats = GameStats(
            score: score,
            distance: distance,
            obstaclesHit: obstaclesHit,
            duration: duration
        )
        
        onGameEndWithStats?(stats)
    }
}
