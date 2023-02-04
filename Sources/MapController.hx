
import rice2d.App;
import kha.Color;

typedef Block = { 
    var t : Int;
    var v : Int;
}

class MapController{

    public static var mapDimension:Int = 4;

    // public static var map: Array<Block> = [
    //     {t:1,v:14}, {t:0,v:0}, {t:0,v:0}, {t:0,v:0}, 
    //     {t:0,v:0}, {t:0,v:0}, {t:0,v:0}, {t:0,v:0}, 
    //     {t:2,v:6}, {t:2,v:9}, {t:0,v:0}, {t:0,v:0}, 
    //     {t:3,v:5}, {t:0,v:0}, {t:0,v:0}, {t:0,v:0},
    // ];
    public static var map: Array<Array<Int>> = [
        [48, 0, 0, 0], 
        [0, 0, 0, 0], 
        [32, 16, 0, 0], 
        [48, 0, 0, 48],
    ];
    static var blockSize: Int = 100;

    var kb = rice2d.Input.getKeyboard();

    public function new() {

        App.notifyOnUpdate(()-> {
            if(kb.started(Up)){
                for (y in 0...4) {
                    for (x in 0...4){
                        printMap();
                        if(y > 0){
                            if(getType(x, y) == 2){
                                if(getType(x, y-1) == 0){
                                    map[y-1][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }else if(getType(x, y) == 3){
                                if(getType(x, y-1) == 0){
                                    var newY = y;
                                    while(true){
                                        if(newY > 0 && getType(x, newY-1) == 0){
                                            newY--;
                                        }else break;
                                    }
                                    map[newY][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                        }
                    }
                }
            }
            else if(kb.started(Down)){
                for (y in new ReverseIterator(4, 0)) {
                    for (x in 0...4){
                        if(y < 3){
                            if(getType(x, y) == 2){
                                if(getType(x, y+1) == 0){
                                    map[y+1][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                            else if(getType(x, y) == 3){
                                if(getType(x, y+1) == 0){
                                    var newY = y;
                                    while(true){
                                        if(newY < 3 && getType(x, newY+1) == 0){
                                            newY++;
                                        }else break;
                                    }
                                    map[newY][x] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }

                        }
                    }
                }
            }
            else if(kb.started(Left)){
                for (x in 0...4){
                    for (y in 0...4) {
                        if(x > 0){
                            if(getType(x, y) == 2){
                                if(getType(x-1, y) == 0){
                                    map[y][x-1] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                            else if(getType(x, y) == 3){
                                if(getType(x-1, y) == 0){
                                    var newX = x;
                                    while(true){
                                        if(newX > 0 && getType(newX-1, y) == 0){
                                            newX--;
                                        }else break;
                                    }
                                    map[y][newX] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                        }
                    }
                }
            }
            else if(kb.started(Right)){
                for (x in new ReverseIterator(4, 0)){
                    for (y in 0...4) {
                        if(x < 3){
                            if(getType(x, y) == 2){
                                if(getType(x+1, y) == 0){
                                    map[y][x+1] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                            else if(getType(x, y) == 3){
                                if(getType(x+1, y) == 0){
                                    var newX = x;
                                    while(true){
                                        if(newX < 3 && getType(newX+1, y) == 0){
                                            newX++;
                                        }else break;
                                    }
                                    map[y][newX] = map[y][x];
                                    map[y][x] = 0;
                                }
                            }
                        }
                    }
                }
            }
        });

        App.notifyOnRenderG2((canvas)->{
            var windowDimension = rice2d.Window.getWindowSize();
            var mapWidth = mapDimension*blockSize;
            var mapHeight = mapDimension*blockSize;
            var mapWidth2 = mapWidth / 2;
            var mapHeight2 = mapHeight / 2;
            var mapPosX = (windowDimension.width/2) - mapWidth2;
            var mapPosY = (windowDimension.height/2) - mapHeight2;
            var g = canvas.g2;
            var col = g.color;
            g.color = Color.Red;
            for (y in 0...4) {
                for (x in 0...4){
                    var type = getType(x, y);
                    if(type == 0) g.color = Color.White;
                    else if(type == 1) g.color = Color.Red;
                    else if(type == 2) g.color = Color.Green;
                    else if(type == 3) g.color = Color.Blue;
                    g.fillRect(x*blockSize+mapPosX, y*blockSize+mapPosY, blockSize, blockSize);
                }
            }
            g.color = col;
        });

    }

    public static function getType(x: Int, y: Int): Int {
        var type = map[y][x] & (3 << 4);
        if(type == 16) return 1;
        else if(type == 32) return 2;
        else if(type == 48) return 3;
        else return 0;
    }

    public static function printMap(){
        trace(
            map[0] + ", " + map[1] + ", " + map[2] + ", " + map[3] + "\n"
            + map[4] + ", " + map[5] + ", " + map[6] + ", " + map[7] + "\n"
            + map[8] + ", " + map[9] + ", " + map[10] + ", " + map[11] + "\n"
        );
    }

}

class ReverseIterator {
  var end:Int;
  var i:Int;

  public inline function new(start:Int, end:Int) {
    this.i = start;
    this.end = end;
  }

  public inline function hasNext() return i >= end;
  public inline function next() return i--;
}