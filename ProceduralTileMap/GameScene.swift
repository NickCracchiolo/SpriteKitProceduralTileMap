//
//  GameScene.swift
//  ProceduralTileMap
//
//  MIT License
//
//  Copyright (c) 2018 Nick Cracchiolo
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
	
	override func didMove(to view: SKView) {
		let map = createMap()
		map.anchorPoint = CGPoint(x:0.5, y:0.5)
		map.xScale = 0.2
		map.yScale = 0.2
		self.addChild(map)
	}
	
	func touchDown(atPoint pos : CGPoint) {
		
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		
	}
	
	func touchUp(atPoint pos : CGPoint) {
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
	}
	
	func createNoiseMap() -> GKNoiseMap {
		//Get our noise source, this can be customized further
		let source = GKPerlinNoiseSource()
		//Initalize our GKNoise object with our source
		let noise = GKNoise.init(source)
		//Create our map
		let map = GKNoiseMap.init(noise, size: vector2(1.0, 1.0), origin: vector2(0, 0), sampleCount: vector2(100, 100), seamless: true)
		return map
	}
	
	func createMap() -> SKTileMapNode {
		//Get out noise map we made above
		let noiseMap = createNoiseMap()
		//Define our SKTileSet:
		//This is the name of the Set within the .sks TileSet file
		let tileSet = SKTileSet(named: "Sample Isometric Tile Set")!
		//Define our Tile Size:
		//This depends on the set but the Isometric set uses 128x64
		let tileSize = CGSize(width: 128, height: 64)
		//Define our Columns and Rows
		let rows = 50, cols = 50
		//Create our Tile Map
		let map = SKTileMapNode(tileSet: tileSet, columns: cols, rows: rows, tileSize: tileSize)
		map.enableAutomapping = true
		for col in 0..<cols {
			for row in 0..<rows {
				//Get a value from our Noise Map returns -1.0 to 1.0
				let val = noiseMap.value(at: vector2(Int32(row), Int32(col)))
				//We will then decide what tiles correspond to what value
				switch val {
				//Set as our water tile
				case -1.0..<(-0.5):
					if let g = tileSet.tileGroups.first(where: {
						($0.name ?? "") == "Water"}) {
						map.setTileGroup(g, forColumn: col, row: row)
					}
				case -0.5..<0:
					if let g = tileSet.tileGroups.first(where: {
						($0.name ?? "") == "Sand"}) {
						map.setTileGroup(g, forColumn: col, row: row)
					}
				case 0..<(0.45):
					if let g = tileSet.tileGroups.first(where: {
						($0.name ?? "") == "Cobblestone"}) {
						map.setTileGroup(g, forColumn: col, row: row)
					}
				//ADD OTHER CASES HERE FOR OTHER TILE GROUPS
				//Set as our grass tile
				default:
					if let g = tileSet.tileGroups.first(where: {
						($0.name ?? "") == "Grass"}) {
						map.setTileGroup(g, forColumn: col, row: row)
					}
				}
			}
		}
		return map
	}
}
