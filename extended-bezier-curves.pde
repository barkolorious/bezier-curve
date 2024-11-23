import yash.oklab.*; 
// Degree of the Bézier curve
int degree = 4;
// The key points of the Bézier curve
ArrayList<PVector> points = new ArrayList<PVector>();
// Timestep
float dt = 0.01;
// Index of the point that's being dragged
// Equals -1 if dragging equals false
int dragIdx = -1;
// The limit of time
float timeLimit = 2.5;
// Vector pointing to the mouse in the screen plane not the projected plane
PVector mouse = new PVector(mouseX, mouseY);

void setup(){
    //fullScreen();
    size(1280, 720);
    generateBezierKeys(degree);
    Ok.p = this;
}

void draw(){
    // Clears the screen
    background(0);
    
    
    // Handle any mouse actions
    handleMouse();
    
    // Draws the lines between Bézier curve's key points
    // Takes the key points(ArrayList<PVector>), line thickness(int), and line color(color) as inputs
    drawLinesBetweenKeyPoints(points, 5, #FFFFFF);
    
    // Draws the Bézier curve for t in [.5 - timeLimit, .5 + timeLimit]
    // Takes the key points(ArrayList<PVector>), time limit(float), line thickness(int), 
    // is the Bézier is extended(boolean), left line color(color), right line color(color) as inputs
    // If the Bézier isn't extended, time limit is ignored and t will be in [0, 1]
    // Left and right line colors are to make a gradient
    // You can only give one color parameter if you don't want a gradient
    drawBezier(points, timeLimit, true, 10, #0056E5, #29FCD7);
    
    // Draws the Bézier curve's key points
    // Takes the key points(ArrayList<PVector>), index of the points that's being dragged,
    // color of the non-dragged points(color), and color of the dragged point(color)
    drawKeyPoints(points, dragIdx, 15, #FFFFFF, #08FFEC);
}
