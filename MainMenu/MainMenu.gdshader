shader_type canvas_item;

uniform vec4 center_color : source_color = vec4(0.03, 0.08, 0.22, 1.0);
uniform vec4 edge_color   : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 p = UV * 2.0 - 1.0;      // (-1,-1) tot (1,1)
    float d = length(p);          // afstand tot midden

    float t = smoothstep(0.2, 1.2, d);

    COLOR = mix(center_color, edge_color, t);
}