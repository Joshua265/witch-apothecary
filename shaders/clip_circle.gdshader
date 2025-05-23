shader_type canvas_item;

void fragment() {
    // Centered UV coordinates (-0.5 to 0.5)
    vec2 centered_uv = UV - vec2(0.5);
    float radius = 0.5; // 0.5 for full rect, reduce for padding

    // Discard pixels outside circle
    if (length(centered_uv) > radius) {
        discard;
    }
    COLOR = texture(TEXTURE, UV) * COLOR;
}
