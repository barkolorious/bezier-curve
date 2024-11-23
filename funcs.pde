int binom(int x, int y){
    if(y == 0) return 1;
    if(x == y) return 1;
    int ans = 1;
    for(int i = x; i > x - y; i--) ans *= i;
    for(int i = y; i > 0; i--) ans /= i;
    return ans;
}

float pwr(float x, int y){
    if(y == 0) return 1;
    else return pow(x, y);
}

color lerpBetweenTwoColorsOkHSL(color start, color end, float t){
    float startH = Ok.getH(start);
    float startS = Ok.getS(start);
    float startL = Ok.getL(start);
    float endH = Ok.getH(end);
    float endS = Ok.getS(end);
    float endL = Ok.getL(end);
    float lerpedH = (1 - t) * startH + t * endH;
    float lerpedS = (1 - t) * startS + t * endS;
    float lerpedL = (1 - t) * startL + t * endL;
    return Ok.HSL(lerpedH, lerpedS, lerpedL);
}

color lerpBetweenTwoColorsRGB(color start, color end, float t){
    float startRed   = start >> 16 & 0xFF;
    float startGreen = start >> 8  & 0xFF;
    float startBlue  = start >> 0  & 0xFF;
    float endRed   = end >> 16 & 0xFF;
    float endGreen = end >> 8  & 0xFF;
    float endBlue  = end >> 0  & 0xFF;
    float lerpedRed   = (1 - t) * startRed   + t * endRed;
    float lerpedGreen = (1 - t) * startGreen + t * endGreen;
    float lerpedBlue  = (1 - t) * startBlue  + t * endBlue;
    return color(lerpedRed, lerpedGreen, lerpedBlue);
}

PVector calculateBezierAtTimeT(ArrayList<PVector> bezierKeys, float time){
    PVector point = new PVector(0, 0);
    int N = bezierKeys.size() - 1;
    for(int i = 0; i <= N; i++){
        float coefficent = binom(N, i);
        coefficent *= pwr(time, N - i);
        coefficent *= pwr(1 - time, i);
        point.add(PVector.mult(bezierKeys.get(i), coefficent));
    }
    return point;
}

void drawBezier(ArrayList<PVector> bezierKeys, float timeLimit, boolean isExtended, int weight, color leftLineColor, color rightLineColor){
    pushStyle();
    strokeWeight(weight);
    PVector prevPoint = new PVector(0, 0);
    float lowerTimeLimit, upperTimeLimit;
    
    if(isExtended){
        lowerTimeLimit = .5 - timeLimit;
        upperTimeLimit = .5 + timeLimit;
    } else{
        lowerTimeLimit = 0;
        upperTimeLimit = 1;
    }
    for(float t = lowerTimeLimit; t <= upperTimeLimit; t += dt){
        PVector point = calculateBezierAtTimeT(bezierKeys, t);
        stroke(lerpBetweenTwoColorsOkHSL(leftLineColor, rightLineColor, map(t, lowerTimeLimit, upperTimeLimit, 0, 1)));
        if(t == lowerTimeLimit) line(point.x, point.y, point.x, point.y);
        else line(prevPoint.x, prevPoint.y, point.x, point.y);
        prevPoint = point;
    } 
    popStyle();
}

void drawBezier(ArrayList<PVector> bezierKeys, float timeLimit, boolean isExtended, int weight, color lineColor){
    pushStyle();
    strokeWeight(weight);
    stroke(lineColor);
    PVector prevPoint = new PVector(0, 0);
    float lowerTimeLimit, upperTimeLimit;
    
    if(isExtended){
        lowerTimeLimit = .5 - timeLimit;
        upperTimeLimit = .5 + timeLimit;
    } else{
        lowerTimeLimit = 0;
        upperTimeLimit = 1;
    }
    for(float t = lowerTimeLimit; t <= upperTimeLimit; t += dt){
        PVector point = calculateBezierAtTimeT(bezierKeys, t);
        if(t == lowerTimeLimit) line(point.x, point.y, point.x, point.y);
        else line(prevPoint.x, prevPoint.y, point.x, point.y);
        prevPoint = point;
    }
    popStyle();
}

void drawKeyPoints(ArrayList<PVector> bezierKeys, int dragIdx, int pointThickness, color nonDraggedPointColor, color draggedPointColor){
    pushStyle();
    noStroke();
    fill(nonDraggedPointColor);
    for(int i = 0; i < bezierKeys.size(); i++){
        if(i == dragIdx){
            fill(draggedPointColor);
            circle(bezierKeys.get(i).x, bezierKeys.get(i).y, pointThickness);
            fill(nonDraggedPointColor);
        }
        else circle(points.get(i).x, bezierKeys.get(i).y, pointThickness);
    }
    popStyle();
}

void drawLinesBetweenKeyPoints(ArrayList<PVector> bezierKeys, int lineThickness, color lineColor){
    pushStyle();
    strokeWeight(lineThickness);
    stroke(lineColor);
    for(int i = 0; i < bezierKeys.size() - 1; i++)
        line(bezierKeys.get(i).x, bezierKeys.get(i).y, bezierKeys.get(i + 1).x, bezierKeys.get(i + 1).y);
    popStyle();
}

void handleMouse(){
    mouse.set(mouseX, mouseY);
    
    if(mousePressed) handleMousePressed();
    else handleMouseNotPressed();
}

void handleMousePressed(){
    if(mouseButton == LEFT){
        if(dragIdx != -1) handleMouseLeftClickDragging();
        else handleMouseLeftClickNotDragging();
    }
}

void handleMouseNotPressed(){
    dragIdx = -1;
}

void handleMouseLeftClickNotDragging(){
    float minDist = 999999999;
    for(int i = 0; i < points.size(); i++){
        if(PVector.dist(mouse, points.get(i)) < minDist){
            minDist = PVector.dist(mouse, points.get(i));
            dragIdx = i;
        }
    }
    if(PVector.dist(mouse, points.get(dragIdx)) > 25) dragIdx = -1;
}

void handleMouseLeftClickDragging(){
    points.get(dragIdx).set(mouse);
}

void generateBezierKeys(int N){
    for(int i = 0; i <= N; i++)
        points.add(new PVector(width / 2 + random(-width / 5, width / 5), height / 2 + random(-height / 5, height / 5)));
}
