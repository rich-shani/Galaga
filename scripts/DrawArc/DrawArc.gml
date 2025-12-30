/// @function draw_arc(x, y, radius, startAngle, endAngle, filled)
/// @description Draws an arc using standard GameMaker functions
/// @param {real} x - Center X position
/// @param {real} y - Center Y position  
/// @param {real} radius - Arc radius
/// @param {real} startAngle - Starting angle in degrees
/// @param {real} endAngle - Ending angle in degrees
/// @param {bool} filled - Whether to fill the arc (true) or just outline (false)
function draw_arc(x, y, radius, startAngle, endAngle, filled) {
    // Convert angles from degrees to radians
    var startRad = degtorad(startAngle);
    var endRad = degtorad(endAngle);
    
    // Calculate the number of segments based on radius for smoothness
    var segments = max(8, ceil(radius * 0.5));
    
    // Calculate angle step
    var angleStep = (endRad - startRad) / segments;
    
    if (filled) {
        // Draw filled arc using triangle fan
        draw_primitive_begin(pr_trianglefan);
        // Center point
        draw_vertex(x, y);
        
        // Calculate points along the arc
        for (var i = 0; i <= segments; i++) {
            var angle = startRad + (angleStep * i);
            var px = x + cos(angle) * radius;
            var py = y + sin(angle) * radius;
            draw_vertex(px, py);
        }
        draw_primitive_end();
    } else {
        // Draw outline arc using line strip
        draw_primitive_begin(pr_linestrip);
        
        // Calculate points along the arc
        for (var i = 0; i <= segments; i++) {
            var angle = startRad + (angleStep * i);
            var px = x + cos(angle) * radius;
            var py = y + sin(angle) * radius;
            draw_vertex(px, py);
        }
        draw_primitive_end();
    }
}