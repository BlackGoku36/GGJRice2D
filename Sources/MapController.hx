
import rice2d.App;
import kha.Color;

enum State {
  Won;
  Failed;
  Playing;
}

class MapController{

    public static var mapDimension:Int = 4;

    public static var map: Array<Array<Int>> = [[]];
    static var blockSize: Int = 150;

    public static var paused = false;

    var kb = rice2d.Input.getKeyboard();

    static var state: State = Playing;
    static var level = 1;
    static var time = 0.0;
    static var timeLimit = 0.0; // In seconds

    public function new() {
        setLevel(level, true);
        time = haxe.Timer.stamp();

        App.notifyOnUpdate(()-> {
            if(paused) return;
            if((haxe.Timer.stamp()-time) > timeLimit) state = State.Failed;
            if(state == State.Won || state == State.Failed) return;

            if(kb.started(Up)){
                for (y in 0...4) {
                    for (x in 0...4){
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

            if(state == State.Playing){
                var square_root = 0;
                var x_pos = 0;
                var y_pos = 0;
                for(y in 0...3){
                    if(state == State.Won) break;
                    for (x in 0...3) {
                        var block1 = getValue(x, y);
                        var block2 = getValue(x+1, y);
                        var block3 = getValue(x, y+1);
                        var block4 = getValue(x+1, y+1);
                        if(block1 == 0 || block2 == 0 || block3 == 0 || block4 == 0) continue;
                        var sum = block1+block2+block3+block4;
                        if(sum > 0){
                            var sr = Math.sqrt(sum);
                            if(sr * sr == (sum*1.0)){
                                state = State.Won;
                            }else{
                                state = State.Playing;
                            }
                            // BEWARE OF FLOATING POINT!!!!!!!
                            square_root = Math.ceil(sr);
                            x_pos = x;
                            y_pos = y;
                        }
                    }
                }
                if(state == State.Won){
                    trace("Level completed!");
                    map[y_pos][x_pos] = square_root + 768;
                    map[y_pos+1][x_pos] = 0;
                    map[y_pos][x_pos+1] = 0;
                    map[y_pos+1][x_pos+1] = 0;
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
            g.font = rice2d.App.font;
            g.fontSize = 35;
            if(state == State.Won){
                g.clear(Color.Green);
            }else if(state == State.Failed){
                g.clear(Color.Red);
            }else{
                for (y in 0...4) {
                    for (x in 0...4){
                        var type = getType(x, y);
                        if(type == 0) g.color = Color.White;
                        else if(type == 1) g.color = Color.Red;
                        else if(type == 2) g.color = Color.Green;
                        else if(type == 3) g.color = Color.Blue;
                        g.fillRect(x*blockSize+mapPosX, y*blockSize+mapPosY, blockSize, blockSize);
                        g.color = Color.Black;
                        g.drawString(getValue(x, y) + "", x*blockSize+mapPosX, y*blockSize+mapPosY);
                    }
                }
            }
            g.color = col;
        });

    }

    public static function reset(resume: Bool){
        state = Playing;
        time = haxe.Timer.stamp();
        paused = !resume;
    }

    public static function setLevel(level: Int, resume: Bool){
        var invalidLevel = false;
        switch (level) {
            case 1:{
                map = Levels.level1;
                timeLimit = Levels.level1TimeLimit;
            }
            case 2:{
                map = Levels.level2;
                timeLimit = Levels.level2TimeLimit;
            }
            default: invalidLevel = true;
        }
        if(!invalidLevel) reset(resume);
        else{
            trace("INVALID LEVEL!");
            reset(false);
        }
    }

    public static function getType(x: Int, y: Int): Int {
        var type = map[y][x] & (3 << 8);
        if(type == 256) return 1;
        else if(type == 512) return 2;
        else if(type == 768) return 3;
        else return 0;
    }

    public static function getValue(x:Int, y:Int): Int {
        return map[y][x] & 255;
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