shader_type canvas_item;

uniform float darkness : hint_range(0.0, 1.0) = 0.75;
uniform vec4 night_color : source_color = vec4(0.02, 0.04, 0.12, 1.0);

uniform float fog_strength : hint_range(0.0, 1.0) = 0.45;
uniform float fog_size : hint_range(0.0, 1.0) = 0.65;
uniform float fog_softness : hint_range(0.01, 1.0) = 0.35;
uniform float fog_speed : hint_range(0.0, 2.0) = 0.15;
uniform float fog_scale : hint_range(1.0, 20.0) = 7.0;

uniform vec4 fog_color : source_color = vec4(0.25, 0.30, 0.42, 1.0);


float random(vec2 position)
{
	return fract(
		sin(dot(position, vec2(12.9898, 78.233))) * 43758.5453
	);
}


float noise(vec2 position)
{
	vec2 cell = floor(position);
	vec2 local_position = fract(position);

	float bottom_left = random(cell);
	float bottom_right = random(cell + vec2(1.0, 0.0));
	float top_left = random(cell + vec2(0.0, 1.0));
	float top_right = random(cell + vec2(1.0, 1.0));

	vec2 smooth_position =
		local_position * local_position * (3.0 - 2.0 * local_position);

	return mix(
		mix(bottom_left, bottom_right, smooth_position.x),
		mix(top_left, top_right, smooth_position.x),
		smooth_position.y
	);
}


void fragment()
{
	vec2 centered_uv = UV - vec2(0.5);

	// Corrigeert de vignette zodat hij niet ovaal wordt op breedbeeld.
	centered_uv.x *= SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

	float distance_from_center = length(centered_uv);

	float edge_mask = smoothstep(
		fog_size - fog_softness,
		fog_size,
		distance_from_center
	);

	vec2 moving_uv = UV * fog_scale;
	moving_uv.x += TIME * fog_speed;
	moving_uv.y += sin(TIME * fog_speed * 0.7) * 0.4;

	float fog_noise = noise(moving_uv);
	fog_noise += noise(moving_uv * 2.0) * 0.5;
	fog_noise /= 1.5;

	float fog = edge_mask * fog_noise * fog_strength;

	vec3 final_color = mix(
		night_color.rgb,
		fog_color.rgb,
		fog
	);

	COLOR.rgb = final_color;
	COLOR.a = clamp(darkness + fog, 0.0, 1.0);
}